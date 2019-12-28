library(tidyverse)
library(leaflet)
library(shiny)
library(plotly)
library(rgdal)
library(raster)
library(tigris)
library(sp)
library(ggmap)
library(maptools)
library(broom)
library(httr)


load('../output/processed_data.RData') 

load('../output/building_geo.RData') 

under <- readOGR("../data/ZIP_CODE_040114.shp")

### ui ###

ui <- navbarPage(
  "Housing Litigations",
  
  tabPanel(
    "Litigation Overview",
    h1("Litigation Overview by Case"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "Zip_frequence",
          "Case Type:",
          c(
            "Comprehensive" = "Comprehensive",
            "Heat and Hot Water" = "Heat and Hot Water",
            "Access Warrant - Non-Lead" = "Access Warrant - Non-Lead",
            "Tenant Action" = "Tenant Action",
            "False Certification Non-Lead" = "False Certification Non-Lead",
            "Heat Supplemental Cases" = "Heat Supplemental Cases",
            "Tenant Action/Harrassment" = "Tenant Action/Harrassment",
            "CONH" = "CONH",
            "Access Warrant - lead" = "Access Warrant - lead",
            "Comp Supplemental Cases" = "Comp Supplemental Cases",
            "Lead False Certification" = "Lead False Certification",
            "Failure to Register Only" = "Failure to Register Only",
            "7A" = "7A",
            "HLD - Other Case Type" = "HLD - Other Case Type"), 
          selected = "Comprehensive",
          multiple = TRUE
        ),
        checkboxGroupInput("CaseOpenDate", "Case Open Date:",
                           c("2000" = "2000",
                             "2003" = "2003",
                             "2004" = "2004",
                             "2005" = "2005",
                             "2006" = "2006",
                             "2007" = "2007",
                             "2008" = "2008",
                             "2009" = "2009",
                             "2010" = "2010",
                             "2011" = "2011",
                             "2012" = "2012",
                             "2013" = "2013",
                             "2014" = "2014",
                             "2015" = "2015",
                             "2016" = "2016",
                             "2017" = "2017",
                             "2018" = "2018",
                             "2019" = "2019"), selected = "2019")
      ),
      mainPanel(leafletOutput("mymap1", height = 780))
    )
  ),
  # end of tab 1
  
  tabPanel(
    "Buildings",
    h1("Litigations of each Building"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          "numlit_t2",
          "Amount of litigations",
          min = 5,
          max = max(building_geo$n),
          value = 25
        ),
        actionButton("building_t2", "See/Update Building Details"),
        textOutput("describe_t2"),
        br(),
        plotlyOutput("histogram_t2", height = 250),
        br(),
        plotlyOutput("pie_t2", height = 300)
      ),
      mainPanel(leafletOutput("mymap_t2", height = 780))
    )
  ),
  # end of tab 2
  
  tabPanel(
    "Respondents",
    h1("Litigations of each Building"),
    
    sidebarLayout(
      sidebarPanel(
        textInput("text_t3", label = h3("Search"), value = "Enter Respondent"),
        actionButton("search_t3", "Search"),
        br(),
        plotlyOutput("histogram_t3", height = 350)
      ),
      
      mainPanel(leafletOutput("mymap_t3", height = 780))
      
    )
  ),
  # end of tab3
  
  tabPanel("Appendix A",
           
           titlePanel(h4(
             "Appendix A: Case Development"
           )),
           
           
           mainPanel(
             tags$div(
               checked = NA,
               tags$p(
                 "** Cases in different types represent different stages in housing litigation."
               ),
               tags$p(
                 "** The more developed case can be deemed as an indicator of more severe property mismanagement."
               )
             ),
             
             tags$img(
               src = 'CTC .png',
               width = "100%",
               height = "100%",
               align = "center"
             )
           )),
  # end of tab A
  
  tabPanel("Appendix B",
           titlePanel(
             h4("Appendix B: Housing Litigation Procedure")
           ),
           
           mainPanel(
             tags$div(
               checked = NA,
               tags$p(
                 "** Unless the landlord complies with orders to correct violations, the case would continue to develop as shown in the chart."
               )
             ),
             
             tags$img(
               src = 'Procedure.jpg',
               width = "100%",
               height = "100%",
               align = "center"
             )
             
           )) # end of tab B
  
)#end of navbar




### server ###

server <- function(input, output){
  
  ## Tab 1 output
  
  output$mymap1 <- renderLeaflet({
    data$CaseOpenDate <- as.Date(data$CaseOpenDate) %>% format("%Y")
    datasliced <-
      dplyr::filter(
        data,
        data$CaseType == input$Zip_frequence,
        data$CaseOpenDate == input$CaseOpenDate
      )
    
    ZIPCODE <- names(table(datasliced$Zip))
    frequence <- unname(table(datasliced$Zip))
    Zip <- as.data.frame(cbind(ZIPCODE, frequence))
    under1 <- subset(under, is.element(Zip$ZIPCODE, under$ZIPCODE))
    under2 <-
      subset(under1, is.element(under1$ZIPCODE, Zip$ZIPCODE))
    under2@data = merge(
      x = under2@data,
      y = Zip,
      by = "ZIPCODE",
      all.x = TRUE
    )
    subdat1 <- spTransform(under2, CRS("+init=epsg:4326"))
    subdat1@data$frequence <- as.numeric(subdat1@data$frequence)
    subdat1$lab <- paste("<p>", "ZIPCODE: ", subdat1$ZIPCODE, "<p>",
                         "<p>", "Number of litigations: ", subdat1$frequence, "<p>")  
    
    pal <- colorNumeric(palette = "Blues",
                        domain = subdat1$frequence)
    
    m <- leaflet(under) %>%
      addProviderTiles(providers$Stamen.Toner) %>%
      setView(lng = -73.98928,
              lat = 40.75042,
              zoom = 11) %>%
      addPolygons(
        data = subdat1,
        weight = 1,
        smoothFactor = 0.5,
        color = "white",
        fillOpacity = 0.8,
        fillColor = pal(subdat1$frequence),
        label = lapply(subdat1$lab, HTML),
        highlight = highlightOptions(
          weight = 10,
          color = "White",
          bringToFront = TRUE
        )
      )
  })  
  
  ## Tab 2 output
  
  output$mymap_t2 <- renderLeaflet({
    
    data <- filter(building_geo, n>= input$numlit_t2)
    
    m <- leaflet(data = data) %>%
      addTiles() %>%
      setView(lng = -73.9588,
              lat = 40.74 ,
              zoom = 11) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        lng = ~ Longitude,
        lat = ~ Latitude,
        popup = ~ paste0(
          "Address: ", HouseNumber, " ", StreetName, "<br/>Litigations: " , n, "<br/>Most Recent Respondent: " , Respondent
        ),
        radius = 4,
        color = "blue",
        fillColor = "white",
        opacity = 0.5
      )
  })
  
  output$describe_t2 <- renderText({
    paste("Click on map to choose a building, displays info on all buildings if no building selected")
  })
  
  observe({
    posi <<- reactive({
      input$mymap_t2_marker_click
    })
  })
  
  observeEvent(input$building_t2,{
    
    if(input$building_t2){
      if(is.null(posi())){
        plot_data <- data
      } else{
        plot_data <- dplyr::filter(data, Latitude==posi()$lat, Longitude==posi()$lng)}
      
      output$histogram_t2 <- renderPlotly({
        ts_data <- plot_data
        ts_data$CaseOpenDate <-
          as.Date(ts_data$CaseOpenDate) %>% format("%Y")
        ts_data <- group_by(ts_data, CaseOpenDate) %>% tally()
        colnames(ts_data) <- c("Year", "Number of litigation")
        
        ts <- ggplot(ts_data, aes(x = Year, y = `Number of litigation`)) +
          geom_bar(stat = "identity") +
          ggtitle("Amount of Litigations in each year") +
          labs(x = "Years", y = "Number of litigation") +coord_flip()
        ts <- ggplotly(ts)
        ts
      })
      
      output$pie_t2 <- renderPlotly({
        plot_ly() %>%
          add_pie(
            data = count(plot_data, CaseType),
            labels = ~ CaseType,
            values = ~ n,
            name = "Litigation by case types",
            domain = list(x = c(0, 0.45), y = c(0, 1))
          ) %>%
          add_pie(
            data = count(plot_data, CaseStatus),
            labels = ~ CaseStatus,
            values = ~ n,
            name = "Status of the litigation",
            domain = list(x = c(0.55, 1), y = c(0, 1))
          ) %>%
          layout(
            title = "Litigation details (type and case status)",
            showlegend = F,
            xaxis = list(
              showgrid = FALSE,
              zeroline = FALSE,
              showticklabels = FALSE
            ),
            yaxis = list(
              showgrid = FALSE,
              zeroline = FALSE,
              showticklabels = FALSE
            )
          )
        
      })
      
    }
    
  })
  
  
  ## Tab 3 output  
  
  output$mymap_t3 <- renderLeaflet({
    input$search_t3
    data_t3 <- filter(building_geo, Respondent == isolate(input$text_t3))
    m <- leaflet(data = data_t3) %>%
      addTiles() %>%
      setView(lng = -73.9588,
              lat = 40.74 ,
              zoom = 11) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        lng = ~ Longitude,
        lat = ~ Latitude,
        popup = ~ paste0(
          "Address: ",
          HouseNumber,
          " ",
          StreetName,
          "<br/>Litigations: " ,
          n
          
        ),
        radius = 4,
        color = "red",
        fillColor = "white",
        opacity = 0.5
      )
  })
  
  
  
  output$histogram_t3 <- renderPlotly({
    input$search_t3
    data_t3 <-
      filter(building_geo, Respondent == isolate(input$text_t3))
    if (nrow(data_t3) == 0) {
      return(NULL)
    }
    
    ts_data_t3 <- group_by(data_t3, BuildingID) %>% count()
    colnames(ts_data_t3) <-
      c("BuildingID", "Number of litigations")
    ts_data_t3 <-
      group_by(ts_data_t3, `Number of litigations`) %>% tally()
    colnames(ts_data_t3) <-
      c("Number of litigations", "Number of buildings")
    
    ts_t3 <-
      ggplot(ts_data_t3,
             aes(x = `Number of litigations`, y = `Number of buildings`)) +
      geom_bar(stat = "identity") +
      ggtitle("Histogram of buildings per litigation number") +
      labs(x = "Number of litigations", y = "Number of buildings") +
      theme(plot.title = element_text(size = 12, face = "bold"))
    ts_t3 <- ggplotly(ts_t3)
    ts_t3
  })
  
  
} # end of server


shinyApp(ui = ui, server = server)