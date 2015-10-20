#library(shinythemes)
library(dplyr)
library(lazyeval)
library(shiny)
library(leaflet)
library(jsonlite)
load("route_lines.rda")

#input <- list(route = 1)

ui <- shinyUI(bootstrapPage(
                      title = "Bus App!",
                      #tags$head(includeScript("google-analytics.js")),
                      tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                      leafletOutput("map", width = "100%", height = "100%"),
                      absolutePanel(class = "panel panel-default", 
                                    top = 1, right = 1, width = 150,
                                    numericInput("route", 
                                                 label = p("route"), 1)
                                    #a(img(src = "codeforanc.png"), href = "http://codeforanchorage.org/"),
                                    #br(),br(),
                                    #(a("Contact", href = "mailto:hans.thompson1@gmail.com"))
                      )
))



server <- function(input, output) {
  
  get_data <- reactive({
    locs <- fromJSON(paste0("http://akdata.org:8000/locations?route=", input$route))
    locs$latitude <- as.numeric(locs$latitude)
    locs$longitude <- as.numeric(locs$longitude)
    get_data <- locs
    get_data
  })  
  
  user_route_lines <- reactive({
     user_route_id <- input$route
     user_route_lines <- in_bound %>% filter(route == input$route) %>% select(shape_pt_lon, shape_pt_lat)
     colnames(user_route_lines) <- c("long", "lati")
     user_route_lines            
  })
  
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      addTiles(urlTemplate = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>% 
      addMarkers(~longitude, ~latitude, data = get_data(), group = "buses") %>%
      addPolylines(~long, ~lati, data = user_route_lines(), group = "stops") 
  })   
}

shinyApp(ui, server)