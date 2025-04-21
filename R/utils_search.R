get_species_list <- function(view_mode, country) {
  # Determine the location to load data from
  location <- switch(view_mode,
                     "Per country" = country,
                     "Europe" = "Europe"
  )
  
  # Try to read the species list file, return empty list with message on error
  tryCatch({
    readRDS(paste0("data/species_names/", location, "_species_names.rds"))
  }, error = function(e) {
    c("No species available for this country" = "")
  })
}