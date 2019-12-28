

library(ggplot2)
library(leaflet)
library(shiny)
library(plotly)


navbarPage(
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
            "HLD - Other Case Type" = "HLD - Other Case Type"
          ),
          selected = "Comprehensive",
          multiple = TRUE
        ),
        checkboxGroupInput(
          "CaseOpenDate",
          "Case Open Date:",
          c(
            "2000" = "2000",
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
            "2019" = "2019"
          ),
          selected = "2019"
        )
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
          max = 90,
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
