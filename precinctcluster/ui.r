fluidPage(sidebarPanel(
  selectInput("model", "Model Choice", c("EII", "VII", "EEI", "EVI", "VEI", "VVI")),
  numericInput('clusters', 'Cluster count', 3,
               min = 1, max = 9)),
  
  mainPanel(
    plotOutput("histogram"),
    plotOutput("textscatter")
  )
  )