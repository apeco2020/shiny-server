library(dplyr)
library(XML)
library(lubridate)
library(tidyr)
library(leaflet)
load("stops.rda")


ui <- bootstrapPage(title = "People Mover Bus Tracking",
                    #tags$head(includeScript("google-analytics.js")),
                    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                    leafletOutput("map", width = "100%", height = "100%"))


server <- function(input, output, session) {
  output$map <- renderLeaflet({
    time_stamp <- Sys.time()
    base <- "http://bustracker.muni.org/InfoPoint/XML/vehiclelocation.xml"
    xml_obj <- xmlParse(base)
    locations <- xmlToDataFrame(xml_obj) %>% filter(runid != "<NA>")
    
    base <- "http://bustracker.muni.org/InfoPoint/XML/stopdepartures.xml"
    xml_obj <- xmlParse(base)
    stop_departures <- xmlToList(xml_obj) 
    removenulls <- function(x) {ifelse(is.null(x), NA, x)}
    delays <- data.frame(
      id = as.numeric(unlist(lapply(stop_departures[-1], function(x) x[[1]]))),
      routeID = unlist(lapply(stop_departures[-1], function(x) x[[3]][[5]][[1]])), 
      direction = unlist(lapply(stop_departures[-1], function(x) x[[3]][[6]])),
      dev = unlist(lapply(lapply(stop_departures[-1], function(x) x[[3]][[3]]), removenulls)),
      edt = ymd_hms(paste0(format(Sys.time(), "%Y-%m-%d"), " ", unlist(lapply(stop_departures[-1], function(x) x[[3]][[1]])), ":00")),
      sdt = unlist(lapply(stop_departures[-1], function(x) x[[3]][[2]])),
      stamp = time_stamp
    )
    
    delays <- delays %>% filter(dev != 0)
    delays$id <- as.numeric(as.character(delays$id))
    
    delays <- delays %>% 
      group_by(routeID, direction) %>% 
      mutate(ord = order(edt - Sys.time())) %>%
      filter(ord < 10)
    
    delays <- inner_join(delays, stops, by = "id") 
    
    content <- paste(locations$routeid,locations$direction)
    
    leaflet() %>%  
      setView(lng = -149.9, lat = 61.11, zoom = 11) %>%
      addTiles() %>% addCircles(data = delays, ~longitude, ~latitude) %>%
      addPopups(data = locations, ~longitude, ~latitude, popup = content) 
  })
}

shinyApp(ui, server)