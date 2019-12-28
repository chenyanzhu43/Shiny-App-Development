library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel(h4("Appendix A: Case Development")),
  
  # Main panel for displaying outputs ----
  mainPanel(
    
    tags$div(checked=NA,
             tags$p("** Cases in different types represent different stages in housing litigation."),
             tags$p("** The more developed case can be deemed as an indicator of more severe property mismanagement.")
            ),
  
    tags$img(src='CTC .png', 
        width="100%", 
        height="100%",
        align = "center")
  )
  
)

server <- shinyServer(function(input, output){})

shinyApp(ui = ui, server = server)