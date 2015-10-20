##Need to combine Geojson into one file before putting into leaflet

library(shinythemes)
library(rgeos)
library(rgdal)
library(leaflet)
library(geojsonio)

load("map.rda") 
load("zones.rda")

#input <- list(feetbuffer = 500, zones = "B-3")

ui <- bootstrapPage(theme = shinytheme("spacelab"),
                    title = "Cannabis Business Zoning",
                    tags$head(includeScript("google-analytics.js")),
                    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                    leafletOutput("map", width = "100%", height = "100%"),
                    absolutePanel(class = "panel panel-default", 
                                  top = 10, right = 10, width = 330,
                                  includeMarkdown("docs/about.md"),
                                  numericInput("feetbuffer", 
                                               label = h4("Feet From Facility"), 500),
                                  selectInput("zones", "Specific Zone", as.character(levels(zones@data$ZONING_DES))),
                                  actionButton("recalc", "Update"),
                                  br(),br(),
                                  a(img(src = "codeforanc.png"), 
                                    href = "http://codeforanchorage.org/"),
                                  br(),br(),
                                  (a("Contact", href = "mailto:hans.thompson1@gmail.com"))
                                  )
                )

server <- function(input, output, session) {
  buffer <- eventReactive(input$recalc, {
      spTransform(map, CRS("+init=epsg:26934")) %>%  
      gBuffer(width = input$feetbuffer / 3.28084) %>% #input$feetbuffer is actually in meters and is converted to feet in this line
      spTransform(CRS("+proj=longlat")) %>%
      as("SpatialPolygonsDataFrame")
  }, ignoreNULL = FALSE)
  filteredZones <- eventReactive(input$updateButton, {
  zones_filtered <- zones[as.character(zones@data$ZONING_DES) == input$zone,] 
  zones_filtered <- as(zones_filtered, "SpatialPolygonsDataFrame")
  return(zones_filtered)
  })
  
  output$map <- renderLeaflet({
    #SpatialPolygons(list(buffers, zones), c("buffer", "zones"))
    leaflet() %>% 
      addTiles(urlTemplate = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>% 
      setView(-149.85, 61.15, zoom = 12) %>%
      addGeoJSON(geojson_json(buffer())) %>%
      addPolygons(data =   filteredZones(),
                  color="red")
  })

}

shinyApp(ui, server)