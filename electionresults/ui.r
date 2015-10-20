fluidPage(

  sidebarLAyout(
  
selectInput("polygon_type", label = h3("Choose local Geometry"), 
            choices = list("Choice 1" = "Senate Districts", "Choice 2" = "House Districts", "Choice 3" = "Precincts"), 
            selected = 1),

selectInput("Race", label = h3("Choose local Geometry"), 
            choices = list("Ballot Measure 1 - Repeal of A0-37" = 1, "Ballot Measure 2 - Legal Cannibus" = 2, 
                           "Ballot Measure 3 - Increase Minimum Wage" = 3, "Ballot Measure 4 - Watershed Protection" = 4,
                           "Turnout of Registered Voters" = 5), 
            selected = 1),

checkboxGroupInput("Elections", label = h3("Checkbox group"), 
                   choices = list("Ballot Measure 1 - Repeal of A0-37" = 1, "Ballot Measure 2 - Legal Cannibus" = 2, 
                                  "Ballot Measure 3 - Increase Minimum Wage" = 3, "Ballot Measure 4 - Watershed Protection" = 4),
                   selected = 1))



map$addPolygon(
  lat = as.factor(c(61.2, 61.1, 61.2)),
  lng = as.factor(c(-150.0, -150.1, -150.1)),
  layerId = 1, 
  options = list(
    weight=1.2,
    fill=TRUE,
    color='#4A9'
  ))
