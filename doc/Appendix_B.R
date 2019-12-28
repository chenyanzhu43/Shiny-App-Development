library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel(h4("Appendix B: Housing Litigation Procedure")),
  
  # Main panel for displaying outputs ----
  mainPanel(
    
    tags$div(checked=NA,
             tags$p("** Unless the landlord complies with orders to correct violations, the case would continue to develop as shown in the chart.")
            ),
    
    tags$img(src='Procedure.jpg', 
             width="100%", 
             height="100%",
             align = "center"
             )
    
  )
  
)

server <- shinyServer(function(input, output){})

shinyApp(ui = ui, server = server)