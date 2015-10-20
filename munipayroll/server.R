# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  
  load(file = "payroll.rda")

  dat <- reactive({
    payroll[payroll$Bargaining.Unit == input$Bargaining.Unit & payroll$year == input$year ,]
  })
  
  output$hist <- renderPlot({
   if(input$cost == "Earnings") {
   p <- ggplot(data = dat()) + geom_bar (aes(x = Earnings, fill = Job.Title)) #+   scale_fill_brewer(palette="Set1") 
   print(p)
   }
   
   if(input$cost == "Overtime") {
     p <- ggplot(data = dat()) + geom_bar (aes(x = Overtime, fill = Job.Title))# +    scale_fill_brewer(palette="Set1")
     print(p)
   }
   
   if(input$cost == "Benefits") {
     p <- ggplot(data = dat()) + geom_bar (aes(x = Benefits, fill = Job.Title))
     print(p)
   }
  })

})
