library(shiny)
library(ggplot2)

shinyUI(fluidPage(theme = "bootstrap.css",
  
  tags$head(includeScript("google-analytics.js")),
  navbarPage(title = "Dipnet_App!",
    tabsetPanel(
      tabPanel("2015 Real Time",
               plotOutput("realtime"),
               p("The dark line is the 35 year average escapement."),
               fluidRow(   
                 column(width = 3, a( img(src = "codeforanc.png"), href = "http://codeforanchorage.org/")),
                 column(width = 6, offset = 3, wellPanel(helpText(""),
                 helpText(HTML("<b>VERSION CONTROL</b>")),
                 HTML('Version 0.9.5'),
                 HTML('<br>'),
                 HTML('Deployed on June 3rd, 2014'),
                 HTML('<br>'),
                 HTML('<a href="https://github.com/hansthompson/shiny-server/tree/master/kenaisockeye" target="_blank">Code on GitHub</a>')
               )))), 
      tabPanel("Prior Sonar Counts",
               fluidRow(
                 sliderInput("year", "Years of Interest", min = 1979, max = 2014, value = c(2004, 2014), sep = ""),
                 textInput("start_date", "Start Date:", "06-30"),
                 textInput("end_date", "End Date:", "08-05")
               ),
               plotOutput("barchart")),
      tabPanel("About", includeMarkdown("docs/introduction.md"))
               
      ) 
    )
    
  )
)