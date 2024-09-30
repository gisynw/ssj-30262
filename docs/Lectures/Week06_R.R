install.packages('leaflet')

library(leaflet)

## create basemap

basemap <- leaflet() %>%
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>%
  # add different provider tiles
  addProviderTiles(
    "CartoDB.Positron",
    # give the layer a name
    group = "CartoDB.Positron"
  ) %>%
  addProviderTiles(
    "Stamen.Toner",
    group = "Stamen.Toner"
  ) %>%
  addLayersControl(
    baseGroups = c(
      "CartoDB.Positron", "Stamen.Toner"),
    # position it on the topleft
    position = "topleft"
  )

icon.fa <- makeAwesomeIcon(
  icon = "flag", markerColor = "red",
  library = "fa",
  iconColor = "black"
)

map_1 <- basemap %>%
  addAwesomeMarkers(
    lat = 42.2626,
    lng = -71.8023,
    label = "Starting point",
    icon = icon.fa
  )

map_1

# Save the map as an HTML file
library(htmlwidgets)
saveWidget(map_1, "leaflet_map.html", selfcontained = TRUE)
browseURL("leaflet_map.html")
