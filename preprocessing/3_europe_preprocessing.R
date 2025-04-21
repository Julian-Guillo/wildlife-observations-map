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
