library(shiny)

ui <- fluidPage(
  
  navbarPage("Strategies of Resistance Data Project",
             
             theme = bslib::bs_theme(bootswatch = "journal"),
             
             tabPanel("Movements",
                      
                      fluidPage(
                        
                        sidebarLayout(
                          
                          sidebarPanel(
                            
                            selectInput("movement", 
                                        "Select a movement:",
                                        choices = movements),
                            
                            h3("Risk assessment"),
                            
                            textOutput("risk_assessment")
                            
                          ),
                          
                          mainPanel(
                            
                            plotOutput("mvmt_map"),
                            
                            br(),
                            
                            plotOutput("movement_methods_plot")
                            
                          )
                          
                        )
                        
                      )
                      
                      )
    
  )
  
)
