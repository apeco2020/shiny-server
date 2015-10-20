library(shiny)
library(leaflet)
library(dplyr)
load("data/all_the_data.rda")


precincts <- levels(factor(all_the_data$NAME))

#input <- list(select = "Spenard")

ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  selectInput("select", label = h3("Select box"), 
                              choices = precincts, 
                              selected = "Spenard")
                  )
    )


server <- function(input, output, session) {
    
    filteredData <- reactive({
        all_the_data %>% filter(as.character(NAME) == input$select) %>% select(x, y, zone) %>%
            rename(lng = x, lat = y)
    })

    
    output$map <- renderLeaflet({
        filtered <- filteredData()
        factpal <- colorFactor(topo.colors(length(levels(droplevels(filtered$zone)))), filtered$zone)
        leaflet(data = filtered) %>% addProviderTiles("Stamen.Toner") %>% addCircleMarkers(color = factpal(filtered$zone))
    })
    
    observe({
        
        leafletProxy("map", data = filteredData()) 
    })
    
}

shinyApp(ui, server)