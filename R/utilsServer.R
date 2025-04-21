# Function to load country-specific data
load_country_data <- function(country, species) {
  path <- file.path(paste0("data/europe_data.parquet/", country, ".parquet/scientificName=", URLencode(species)))
  
  tryCatch({
    dataset <- open_dataset(path) %>% collect()
    dataset$scientificName <- species
    dataset
  }, error = function(e) {
    EMPTY_DATA
  })
}

# Function to load Europe-wide data
load_europe_data <- function(species) {
  
  # Try to load data for each country and combine
  tryCatch({
    results <- lapply(COUNTRY_CODES, function(country_code) {
      # Use the existing load_country_data function
      data <- load_country_data(country_code, species)
      
      # Only return datasets that have rows (not empty)
      if (nrow(data) > 0) {
        return(data)
      } else {
        return(NULL)  # Skip empty datasets
      }
    })
    
    # Filter out NULL results (countries with no data)
    valid_results <- results[!sapply(results, is.null)]
    
    if (length(valid_results) > 0) {
      # Combine all data into a single dataframe
      combined_data <- do.call(rbind, valid_results)
      return(combined_data)
    } else {
      # Return empty dataframe if no data found
      return(EMPTY_DATA)
    }
  }, error = function(e) {
    # Return empty dataframe on any error
    return(EMPTY_DATA)
  })
}

# Main update_data function that chooses which loader to use
update_data <- function(country, species, view_mode) {
  # Only proceed if species is provided
  if (species == "") {
    return(EMPTY_DATA)
  }
  
  # Choose the appropriate data loading function based on view mode
  if (view_mode == "Europe") {
    load_europe_data(species)
  } else {
    load_country_data(country, species)
  }
}
