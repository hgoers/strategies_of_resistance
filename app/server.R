library(shiny)

server <- function(input, output, session) {
  
  # movement map
  output$mvmt_map <- renderPlot(
    
    mvmt_map_plot(input$movement)
    
  )
  
  # movement risk assessment
  output$risk_assessment <- renderText(
    
    mvmt_full %>% 
      filter(group == input$movement) %>% 
      distinct(risk_assessment) %>% 
      pull()
    
  )
  
  # movement methods plot
  output$movement_methods_plot <- renderPlot(
    
    mvmt_methods_plot(input$movement)
    
  )
  
}
