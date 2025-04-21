# Function to load Europe-wide data
load_europe_data <- function(species) {
  tryCatch({
    dataset <- open_dataset("data/europe_data.parquet") %>% 
      filter(scientificName == species) %>% 
      collect()
    dataset
  }, error = function(e) {
    data.frame(scientificName = character(0), stringsAsFactors = FALSE)
  })
}

# Function to load country-specific data
load_country_data <- function(country, species) {
  path <- file.path(paste0("data/europe_data.parquet/", country, ".parquet/scientificName=", URLencode(species)))
  
  tryCatch({
    dataset <- open_dataset(path) %>% collect()
    dataset$scientificName <- species
    dataset
  }, error = function(e) {
    data.frame(scientificName = character(0), stringsAsFactors = FALSE)
  })
}

# Main update_data function that chooses which loader to use
update_data <- function(country, species, view_mode) {
  # Only proceed if species is provided
  if (species == "") {
    return(data.frame(scientificName = character(0), stringsAsFactors = FALSE))
  }
  
  # Choose the appropriate data loading function based on view mode
  if (view_mode == "Europe") {
    load_europe_data(species)
  } else {
    load_country_data(country, species)
  }
}
