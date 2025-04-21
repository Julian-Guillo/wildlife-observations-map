# global.R
library(arrow)
library(bslib)
library(dplyr)
library(DT)
library(leaflet)
library(shiny)

# Source all modules and functions
source("modules/app_server.R")
source("modules/app_ui.R")
source("modules/mod_search.R")
source("modules/mod_map.R")
source("modules/mod_timeline.R")

# Create a named vector for country codes
country_names <- c(
  "Austria" = "AT", 
  "Belgium" = "BE", 
  "Switzerland" = "CH", 
  "Czech Republic" = "CZ", 
  "Greece" = "GR", 
  "Italy" = "IT", 
  "Luxembourg" = "LU", 
  "Poland" = "PL", 
  "Portugal" = "PT"
)

