
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

    tags$head(tags$script(src="trackorientation.js")),

  # Application title
  titlePanel("Old Faithful Geyser Data"),


    # Show a plot of the generated distribution
    mainPanel(textOutput("text")

  )
))
