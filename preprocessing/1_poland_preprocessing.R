library(arrow)
library(dplyr)
library(data.table)

# Create partitioned parquet dataset by species---------------------------------
# Set up a CSV reader with chunking
# the raw data is not included in the repository, please make sure to download
csv_reader <- open_dataset("data/raw/occurence.csv", format = "csv")

# Convert to parquet for faster access
csv_reader %>% 
  select(
    id,
    occurrenceID,
    scientificName,
    vernacularName,
    longitudeDecimal,
    latitudeDecimal,
    coordinateUncertaintyInMeters,
    country,
    countryCode,
    stateProvince,
    locality,
    eventDate
  ) %>%
  write_dataset(
    path = "data/occurrence.parquet",
    format = "parquet",
    max_partitions = 5000L,
    max_open_files = 2000L
    )

start <- Sys.time()
# Filter for Poland observations and write directly to parquet.
## Select only the relevant columns
poland_data <- open_dataset("data/occurrence.parquet") %>%
  filter(countryCode == "PL")

# Add multimedia data to the dataset
# Read multimedia data 
multimedia_raw <- as.data.table(
  open_dataset("data/multimedia.csv", format = "csv") %>%
    select(CoreId, Identifier) %>%
    collect()
)

# Get the first Identifier per CoreId (we only want one link per observation)
# We need to collect to memory because this type of operation is not supported 
# in Arrow. If data would have been too big to fit in memory, we could have
# either joined the data in chunks or used a different approach with duckdb.
setorder(multimedia_raw, CoreId)
multimedia_data_unique <- multimedia_raw[, .SD[1], by = CoreId]

# Perform the join
poland_with_multimedia <- poland_data %>%
  left_join(multimedia_data_unique, by = c("id" = "CoreId"))

# Save the dataset to Parquet
write_dataset(
  poland_with_multimedia,
  path = "data/europe_data.parquet/PL.parquet",
  format = "parquet",
  partitioning = "scientificName",
  max_partitions = 5000L,
  max_open_files = 2000L
)

end <- Sys.time()
print(paste("Time taken to process the data:", end - start))

# Also save the filtered multimedia data to allow later use with other countries
write_dataset(
  multimedia_data_unique,
  path = "data/multimedia.parquet",
  format = "parquet",
  max_partitions = 5000L,
  max_open_files = 2000L
)



# Create vector with unique scientific names------------------------------------

# Read the dataset
poland_data <- open_dataset("data/europe_data.parquet/PL.parquet") %>%
  select(scientificName, vernacularName)

# Get unique scientific names and their corresponding vernacular names
scientific_and_vernacular_names <- poland_data %>%
  select(scientificName, vernacularName) %>%
  distinct() %>%
  arrange(scientificName) %>%
  collect()

# Create a list of names for the species
vernacular_names <- scientific_and_vernacular_names$vernacularName
scientific_names <- scientific_and_vernacular_names$scientificName
names_list <- scientific_names
names(names_list) <- ifelse(
  is.na(vernacular_names) | vernacular_names == "",
  # If vernacular name is missing, just use scientific name
  scientific_names,
  # Otherwise show "vernacular (scientific)"
  paste0(vernacular_names, " (", scientific_names, ")")  
)


# Save to rds
saveRDS(names_list, file = "data/species_names/PL_species_names.rds")