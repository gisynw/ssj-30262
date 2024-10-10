library(shiny);library(leaflet);library(sf);library(dplyr)
points_data <- st_read("cbsa_points.shp") 

tf_data = st_transform(points_data, crs = '+proj=longlat +datum=WGS84')

ui <- fluidPage( 
  tags$style(HTML("
    h2 {
      font-size: 35px;  /* Adjust font size for headers */
      text-align: center;
    }
    .shiny-input-container {
      font-size: 25px;  /* Adjust font size for input labels and text */
    }
    
    .control-label {
      font-size: 25px;  /* Adjust the font size of input labels */
    }
    
    .irs-grid-text {
      font-size: 20px !important;
    }
  ")),
  
  titlePanel("Mapping Housing Mortgages Across the U.S.: A State-by-State Comparison"),
  
  fluidRow(
    column(width = 8,offset = 2,
           wellPanel(
            
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
             
             radioButtons(inputId = 'showAll',
                          label = 'Show All States',
                          choices = list("All" = 'all', "Filtered" = 'filtered')),
             
             style = "height:350px"

           ))),
    
  fluidRow(
    column(width = 12,
           wellPanel(leafletOutput(outputId = "map",  height = '800px'))),
    
    )
   
  )


# Define the server
server <- function(input, output) {
  # Reactive data based on filters
  filtered_data <- reactive({
    if(input$showAll == 'all'){
      tf_data %>%
        filter(Mortgage >= input$mortgageRange[1],
               Mortgage <= input$mortgageRange[2])
    }else{
      tf_data %>%
        filter(Mortgage >= input$mortgageRange[1],
               Mortgage <= input$mortgageRange[2],
               State %in% input$stateFilter)
    }
    
  })
  
  # Render the leaflet map
  output$map <- renderLeaflet({
   
    leaflet() %>%
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
        radius = 6,  # Adjust size based on Mortgage value (adjust the divisor as needed)
        color = "blue",
        stroke = FALSE,
        fillOpacity = 0.5,
        label = ~paste("Mortgage:", Mortgage, " ", "State:", State),
        labelOptions = labelOptions(
          style = list("font-size" = "25px")  # Adjust the font size here
        )
      )
  })
}

shinyApp(ui, server)







