# global.R
library(arrow)
library(bsicons)
library(bslib)
library(dplyr)
library(DT)
library(leaflet)
library(lubridate)
library(plotly)
library(shiny)

# Source all modules and functions
source("modules/app_server.R")
source("modules/app_ui.R")
source("modules/mod_counter.R")
source("modules/mod_map.R")
source("modules/mod_search.R")
source("modules/mod_table.R")
source("modules/mod_timeline.R")

source("R/utils_map.R")
source("R/utils_search.R")
source("R/utils_server.R")
source("R/utils_timeline.R")

# Create a named vector for country codes
COUNTRY_CODES <- c("AT", "BE", "CH", "CZ", "GR", "IT", "LU", "PL", "PT")
COUNTRY_NAMES <- c(
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
MOCK_DATA <- data.frame(
  id = "SUPERCOOL_ID",
  occurrenceID = "SUPERCOOL_ID",
  vernacularName = "Julian Guillo",
  longitudeDecimal = -0.4,
  latitudeDecimal = 39.3,
  locality = "Spain - Albal, Valencia",
  countryCode = "ES",
  eventDate = as.Date("2025-04-21"),
  Identifier = "static/julian_photo.jpg",
  scientificName = "R Shiny Developer",
  stringsAsFactors = FALSE
)

# Empty dataframe to load when error or no data
EMPTY_DATA <- data.frame(
  id = character(0),
  occurrenceID = character(0),
  vernacularName = character(0),
  longitudeDecimal = numeric(0),
  latitudeDecimal = numeric(0),
  locality = character(0),
  countryCode = character(0),
  eventDate = as.Date(character(0)),
  Identifier = character(0),
  scientificName = character(0),
  stringsAsFactors = FALSE
)