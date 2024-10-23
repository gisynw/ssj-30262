library(shiny);library(leaflet);library(sf);library(dplyr)
points_data <- st_read("cbsa_points.shp") 

tf_data = st_transform(points_data, crs = '+proj=longlat +datum=WGS84')

ui <- fluidPage( 
  titlePanel("Interactive Mortgage Map"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "mortgageRange",
                  label = "Mortgage Range:",
                  min = 0,
                  max = max(tf_data$Mortgage, na.rm = TRUE),
                  value = c(0, max(tf_data$Mortgage, na.rm = TRUE))),
      
      selectInput(inputId = "stateFilter", 
                  label = "Select State:",
                  choices = unique(tf_data$State), 
                  selected = unique(tf_data$State)[1], 
                  multiple = TRUE),
      ),
    
    mainPanel(
      leafletOutput(outputId = "map", height = '1500px'))
  )
)

# Define the server
server <- function(input, output) {
  # Reactive data based on filters
  filtered_data <- reactive({
    tf_data %>%
      filter(Mortgage >= input$mortgageRange[1],
             Mortgage <= input$mortgageRange[2],
             State %in% input$stateFilter)
  })
  
  # Render the leaflet map
  output$map <- renderLeaflet({
    leaflet(height = 500) %>%
      addTiles() %>%
      setView(lng = mean(st_coordinates(tf_data)[,1]), 
              lat = mean(st_coordinates(tf_data)[,2]), 
              zoom = 6)
  })

# Observe changes and update the map
  observe({
    leafletProxy("map", data = filtered_data()) %>%
      clearMarkers() %>%
      addCircleMarkers(
        radius = 3,  # Adjust size based on Mortgage value (adjust the divisor as needed)
        color = "blue",
        stroke = FALSE,
        fillOpacity = 0.5,
        label = ~paste("Mortgage:", Mortgage,"\n",  "State:", State)
      )
  })
}

shinyApp(ui, server)





