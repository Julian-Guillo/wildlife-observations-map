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
source("modules/mod_table.R")

source("R/utilsServer.R")
source("R/utilsSearch.R")

# Create a named vector for country codes
country_codes <- c("AT", "BE", "CH", "CZ", "GR", "IT", "LU", "PL", "PT")
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

# Mock data for first run of the app
mock_data <- data.frame(
  scientificName = "R Shiny Developer",
  vernacularName = "Julián",
  longitudeDecimal = -0.4,
  latitudeDecimal = 39.3,
  locality = "Albal, Valencia, Spain",
  countryCode = "ES",
  eventDate = as.Date("2025-04-21"),
  Identifier = "R Shiny Developer",
  stringsAsFactors = FALSE
)
