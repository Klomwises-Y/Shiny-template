library(shiny)
library(readr)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file"),
      checkboxGroupInput("var_Y", "Select variable Y"),
      checkboxGroupInput("var_X", "Select variable X"),
    ),
    
    mainPanel(
      h4("The first part of Y"),
      verbatimTextOutput("head_Y"),
      
      h4("The first part of X"),
      verbatimTextOutput("head_X")
    )
  )
)
  server <- function(input, output, session) {
    
    data <- reactive({
      req(input$file)
      read_csv(input$file$datapath)
    })
    
    observe({
      updateCheckboxGroupInput(session, "var_Y",
                               choices = names(data()),
                               selected = NULL)
    })
    
    observe({
      updateCheckboxGroupInput(session, "var_X",
                               choices = names(data()),
                               selected = NULL)
    })
    
    output$head_Y <- renderPrint({
      req(input$var_Y)
      head(data()[, input$var_Y])
    })
    
    output$head_X <- renderPrint({
      req(input$var_X)
      head(data()[, input$var_X])
    })
  }
shinyApp(ui, server)
  
  