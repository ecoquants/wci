suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(shiny)
  library(shinydashboard)
  library(leaflet)
  library(ggmap)
  library(RColorBrewer)
})

sb100 = read_sf(sb100_geo)

scores_random <<- sample(seq(0,1, by=0.1), length(practices), replace=T)