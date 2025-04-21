library(arrow)
library(dplyr)

# Set up a CSV reader with chunking
csv_reader <- open_dataset("data/occurrence.parquet")

# Open the multimedia dataset
multimedia <- open_dataset("data/multimedia.parquet", format = "parquet")

# Filter for Europe observations and write directly to parquet
europe_data <- csv_reader %>%
  filter(continent == "Europe") %>%
  select(
    id,
    scientificName,
    vernacularName,
    longitudeDecimal,
    latitudeDecimal,
    countryCode,
    eventDate
  )

# Perform the join
europe_with_multimedia <- europe_data %>%
  left_join(multimedia, by = c("id" = "CoreId"))

# Save the dataset to Parquet
write_dataset(
  country_with_multimedia,
  path = file.path(paste0("data/europe.parquet")),
  format = "parquet",
  partitioning = c("countryCode","scientificName"),
  max_partitions = 5000L,
  max_open_files = 2000L
)

# NOTE: the dataset ended up being too big to deploy to shinyapps.io, will try 
# to select less countries. It shouldn't be hard to use all the dataset with 
# enough storage, as the dataset is partitioned by species and the loading time 
# is very fast when using a partitioned dataset.


# Read the dataset
europe_data <- open_dataset("data/europe_data.parquet") %>%
  select(scientificName, vernacularName)

# Get unique scientific names and their corresponding vernacular names
scientific_and_vernacular_names <- europe_data %>%
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
saveRDS(names_list, file = "data/species_names/Europe_species_names.rds")