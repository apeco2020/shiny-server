library(leaflet)
shinyUI(fluidPage(
  leafletMap("map", 800, 800, options = list(
    center = c(61.2, -150),
    zoom = 9
  )),
  htmlOutput("details")
))


