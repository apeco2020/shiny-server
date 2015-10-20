
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Muni_Payroll_Explorer"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("Bargaining.Unit", "Labor Orgainization", levels(payroll$Bargaining.Unit)),
      selectInput('year', 'Year', levels(payroll$year)),
      selectInput('cost', 'Pay Type', c("Earnings", "Overtime", "Benefits"))
      ),
      
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("hist")
    )
)))
