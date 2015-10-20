shinyUI(fluidPage(
  titlePanel("Anchorage Voting Precint Explorer"),
  tabPanel("Plot",
  fluidRow(
    column(2,
           wellPanel(
           checkboxInput("leverage", label = "Number of Votes Away From You", value = TRUE)),
           # Copy the chunk below to make a group of checkboxes
           wellPanel(sliderInput('Prop1Quantile', label = h3("Prop 1"), .5,
                       min = 0, max = 1),
           sliderInput('Prop2Quantile', label = h3("Prop 2"), .5,
                       min = 0, max = 1),
           sliderInput('Prop3Quantile', label = h3("Prop 3"), .5,
                       min = 0, max = 1),
           sliderInput('Prop4Quantile', label = h3("Prop 4"), .5,
                       min = 0, max = 1)),
           wellPanel(selectInput("Gov_Can", label = h3("Governor"), 
                       choices = list("Walker","Clift", "Myers", "Parnell"), 
                       selected = "Walker"),
           sliderInput('GovQuantile', label = h3("Gov"), .5,
                       min = 0, max = 1))),
    column(2,
           wellPanel(selectInput("House_Can", label = h3("US Rep"), 
                       choices = list("Young", "McDermott", "Dunbar"), 
                       selected = "Young"),
           sliderInput('HouseQuantile', label = h3("Rep"), .5,
                       min = 0, max = 1)),
           wellPanel(selectInput("Senate_Can", label = h3("US Senate"), 
                       choices = list("Begich", "Fish", "Gianoutsos", "Sullivan"), 
                       selected = "Sullivan"),
           sliderInput('SenateQuantile', label = h3("Sen"), .5,
                       min = 0, max = 1))#,
           #wellPanel(
           #img(src = "c4anc.jpg", height = 400, width = 400))
  ),
    column(5,
           plotOutput('testplot', height = 900)),
  column(3, 
         h3("About"),
         p("This web app was made off the November 2014 Election data offically", 
           tags$a(href="http://www.elections.alaska.gov/ei_return_2014_GENR.php", "here"), 
           "or unoffically", 
           tags$a(href="https://github.com/hansthompson/Anchorage-Vote-Leverage/blob/master/results-precinct.txt", "here"),
           ".  Keep in mind that the precinct names are defunct from a previous redistricting and have been converted. The converstion of these are available at the github repository for this project", 
           tags$a(href="https://github.com/hansthompson/Anchorage-Vote-Leverage", "here"),
           ".") 
           ))
  
  #https://github.com/hansthompson/Anchorage-Vote-Leverage
  #https://github.com/hansthompson/Anchorage-Vote-Leverage/blob/master/results-precinct.txt
  
  )))
