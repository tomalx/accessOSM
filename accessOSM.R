

if(!require(osmdata)) install.packages("osmdata")

library(osmdata)


# specify coords for bbox
#coords <- c(-2.98, 51.25, -2.25, 51.55) # west of england
coords <- c(-2.62, 51.42, -2.51, 51.48) # bristol central
coords <- c(-2.59, 51.45, -2.57, 51.46) # bristol central -smaller

# create quick map which shows extent of bbox
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(lng = c(coords[1], coords[1], coords[3], coords[3], coords[1]), 
              lat = c(coords[2], coords[4], coords[4], coords[2], coords[2]))

coords <- matrix(coords, ncol = 2, nrow = 2, byrow = FALSE, dimnames = list(c("x", "y"), c("min", "max")))
location <- coords %>% osmdata::opq()

cycleway <- location %>%
  add_osm_feature(key = "cycleway"
                 # , value = c("track")
                  ) %>%
  osmdata_sf() 

highway_cycleway <- location %>%
  add_osm_feature(key = "highway", value = c("cycleway")) %>%
  osmdata_sf()

cycleway_lines <- cycleway$osm_lines
highway_cycleway_lines <- highway_cycleway$osm_lines

# find variable names that match from the two data frames cycleway_lines and highway_cycleway_lines
intersect(names(cycleway_lines), names(highway_cycleway_lines))



# set up a colour palette function from RColorBrewer set 1 for cycleway types
pal <- colorFactor(palette = brewer.pal(9, "Set1"), domain = cycleway_lines$cycleway)






# create a quick map that shows highway and cycleway lines for cycling infrastructure
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  #add cycleway lines
  addPolylines(data = cycleway_lines,
               # colour by cycleway type using pal palette
               color = ~pal(cycleway_lines$cycleway),
               #color = cycleway_lines$highway,
              # color = cycleway, 
               weight = 4, 
               opacity = 0.5, 
               fillOpacity = 0.5,
               popup = paste0("osm_id: ", cycleway_lines$osm_id, "<br>",
                              "Name: ", cycleway_lines$name, "<br>",
                              "Highway: ", cycleway_lines$highway, "<br>",
                              "Cycleway: ", cycleway_lines$cycleway, "<br>",
                              "Bicyle: ", cycleway_lines$bicycle, "<br>",
                              "Foot: ", cycleway_lines$foot, "<br>",
                              "Segregated: ", cycleway_lines$segregated, "<br>",
                              "Surface: ", cycleway_lines$surface, "<br>",
                              "Width: ", cycleway_lines$width, "<br>",
                              "Crossing: ", cycleway_lines$crossing, "<br>",
                              "Tunnel: ", cycleway_lines$tunnel, "<br>",
                              "Bridge: ", cycleway_lines$bridge, "<br>",
                              "Notes: ", cycleway_lines$note, "<br>"),
              group = "Cycleway") %>% 
  addPolylines(data = highway_cycleway_lines,
               color = ~pal(highway_cycleway_lines$cycleway),
              # color = "red", 
               weight = 4, 
               opacity = 0.5, 
               fillOpacity = 0.5,
               popup = paste0("osm_id: ", highway_cycleway_lines$osm_id, "<br>",
                              "Name: ", highway_cycleway_lines$name, "<br>",
                              "Highway: ", highway_cycleway_lines$highway, "<br>",
                              "Cycleway: ", highway_cycleway_lines$cycleway, "<br>",
                              "Bicyle: ", highway_cycleway_lines$bicycle, "<br>",
                              "Foot: ", highway_cycleway_lines$foot, "<br>",
                              "Segregated: ", highway_cycleway_lines$segregated, "<br>",
                              "Surface: ", highway_cycleway_lines$surface, "<br>",
                              "Width: ", highway_cycleway_lines$width, "<br>",
                              "Crossing: ", highway_cycleway_lines$crossing, "<br>",
                              "Tunnel: ", highway_cycleway_lines$tunnel, "<br>",
                              "Bridge: ", highway_cycleway_lines$bridge, "<br>",
                              "Notes: ", highway_cycleway_lines$note, "<br>"),
              group = "Highway") %>% 
  addLayersControl(
    overlayGroups = c("Highway", "Cycleway"),
    options = layersControlOptions(collapsed = FALSE)
  )

# create leaflet map with cycleway lines using colour palette
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  #add cycleway lines
  addPolylines(data = cycleway_lines,
               # colour by cycleway type using pal palette
               color = ~pal(cycleway_lines$cycleway),
               #color = cycleway_lines$highway,
              # color = cycleway, 
               weight = 4, 
               opacity = 0.5, 
               fillOpacity = 0.5,
               popup = paste0("osm_id: ", cycleway_lines$osm_id, "<br>",
                              "Name: ", cycleway_lines$name, "<br>",
                              "Highway: ", cycleway_lines$highway, "<br>",
                              "Cycleway: ", cycleway_lines$cycleway, "<br>",
                              "Lit", cycleway_lines$lit, "<br>",
                              "Variable: ", cycleway_lines$variable, "<br>",
                              "Value: ", cycleway_lines$value, "<br>"))

cycleway_lines <- cycleway$osm_lines
cycleway_polygons <- cycleway$osm_polygons
cycleway_points <- cycleway$osm_points
