library(sf);library(leaflet);library('awtools')

dsga = read_sf('F:\\Clark_Universiy\\Clark_Teaching\\Git_Repo\\ssj-30262\\docs\\Labs\\Lab05\\dsga\\DSGA_POLY.shp')

tf_dsga <- st_transform(dsga, crs = '+proj=longlat +datum=WGS84')

basemap = leaflet() %>% 
  addProviderTiles(
    "OpenStreetMap",
    # give the layer a name
    group = "Open Street"
  ) %>% 
  addProviderTiles(
    "CartoDB.Positron",
    group = "CartoDB"
  )  %>%
  setView(lng = -70.7606, lat = 42.2057, zoom = 9) %>% 
  addLayersControl(baseGroups = c("OpenStreetMap","CartoDB"),
                   position = 'topleft')

palette_pts <- colorFactor(palette = mpalette, domain = tf_dsga$CLASS)

labels <- sprintf(
  "<strong>Class: %s</strong><br/>Begin Date: %s",
  tf_dsga$CLASS, tf_dsga$BEGIN_DATE
) %>% lapply(htmltools::HTML)

final_map = basemap %>% addPolygons(
  data = tf_dsga,
  fillColor = ~palette_pts(CLASS),  # Color based on the 'category' column
  color = "white",
  fillOpacity = 0.8,           # Adjust opacity
  label =  labels,
  weight = 1,
  highlightOptions = highlightOptions(
    weight = 5,
    color = '#666',
    bringToFront = TRUE),
  group = 'DSGA')  %>%  
  addLegend(data = tf_dsga,
              position = "bottomleft",
              pal = palette_pts, 
              values = ~CLASS,
              title = "Class",
              opacity = 1) %>% 
  addLayersControl(baseGroups = c("CartoDB", "Open Street"), overlayGroups = c("DSGA"),
                   position = "topright") 
  
library(htmlwidgets)
saveWidget(final_map, "F:\\Clark_Universiy\\Clark_Teaching\\Git_Repo\\ssj-30262\\docs\\Labs\\Lab05\\index.html", selfcontained = FALSE)





