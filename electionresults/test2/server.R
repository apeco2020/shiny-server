library(leaflet)
load("big_list.rda")



seattle_geojson <- district_polygons



shinyServer(function(input, output, session) {
  map <- createLeafletMap(session, "map")
  session$onFlushed(once=TRUE, function() {
    map$addGeoJSON(seattle_geojson)
  })
  values <- reactiveValues(selectedFeature = NULL)
  observe({
    evt <- input$map_click
    if (is.null(evt))
      return()
    isolate({
      # An empty part of the map was clicked.
      # Null out the selected feature.
      values$selectedFeature <- NULL
    })
  })
  observe({
    evt <- input$map_geojson_click
    if (is.null(evt))
      return()
    isolate({
      # A GeoJSON feature was clicked. Save its properties
      # to selectedFeature.
      values$selectedFeature <- evt$properties
    })
  })
  output$details <- renderText({
    # Render values$selectedFeature, if it isn't NULL.
    if (is.null(values$selectedFeature))
      return(NULL)
    as.character(tags$div(
      tags$h3(values$selectedFeature$name),
      tags$div(
        "Registered Voters:",
        values$selectedFeature$population
      )
    ))
  })
})