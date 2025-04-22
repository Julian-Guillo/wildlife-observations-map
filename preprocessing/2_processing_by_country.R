library(arrow)
library(dplyr)

# Create partitioned parquet dataset by species---------------------------------
# Set up a CSV reader with chunking
# the raw data is not included in the repository, please make sure to download
csv_reader <- open_dataset("data/occurrence.parquet", format = "parquet")

# Open the multimedia dataset
multimedia <- open_dataset("data/multimedia.parquet", format = "parquet")

# select a subset of countries that fits in a shinyapps.io deployment
countries_to_process <- c("AT", "BE", "CH", "CZ", "GR", "IT", "LU", "PL")

for (country in countries_to_process) {
start <- Sys.time()
# Filter for countryCode observations and write directly to parquet.
## Select only the relevant columns
country_data <- csv_reader %>%
  filter(countryCode == country) %>%
  select(
    id,
    occurrenceID,
    scientificName,
    vernacularName,
    longitudeDecimal,
    latitudeDecimal,
    locality,
    countryCode,
    eventDate
  )

# Perform the join
country_with_multimedia <- country_data %>%
  left_join(multimedia, by = c("id" = "CoreId"))

# Save the dataset to Parquet
write_dataset(
  country_with_multimedia,
  path = file.path(paste0("data/europe_data.parquet/", country,".parquet")),
  format = "parquet",
  partitioning = "scientificName",
  max_partitions = 5000L,
  max_open_files = 2000L
)

# Create vector with unique scientific names
vernacular_names <- country_with_multimedia$vernacularName
scientific_names <- country_with_multimedia$scientificName
names_list <- scientific_names
names(names_list) <- ifelse(
  is.na(vernacular_names) | vernacular_names == "",
  scientific_names,
  paste0(vernacular_names, " (", scientific_names, ")")
)

# Save to .rds
saveRDS(names_list, file = paste0("data/species_names/", country, "_species_names.rds"))


end <- Sys.time()
print(paste("Time taken to process", country, "data:", end - start))
}


# Additional: save species of all countries to a single file--------------------
species_names_files <- list.files("data/species_names", pattern = "*.rds", full.names = TRUE)
species_names_list <- lapply(species_names_files, readRDS)
# get a vector with all the names
species_names_vector <- unlist(species_names_list)
# remove duplicates, maintain a named vector
species_names_vector <- species_names_vector[!duplicated(species_names_vector)]