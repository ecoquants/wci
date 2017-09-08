suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(shiny)
  library(shinydashboard)
  library(sf)
  library(leaflet)
  library(ggmap)
  #library(RColorBrewer)
})

# 100 parcels in SB around 812 W Sola St (BB's home)
sb100_geo = './data/sb100.geojson'
sb100 = read_sf(sb100_geo)

practices = c(
  'Storage'        = 'storage',
  'Catchment'      = 'catchment',
  'Infiltration'   = 'infiltration',
  'Reduction'      = 'reduction',
  'Grey Water'     = 'greywater',
  'Native Habitat' = 'nativehabitat',
  'Edible Gardens' = 'ediblegardens')

scores_random <<- sample(seq(0,1, by=0.1), length(practices), replace=T)

scale_fill_ordinal = scale_fill_hue
