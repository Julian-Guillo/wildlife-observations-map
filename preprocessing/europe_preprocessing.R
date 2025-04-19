library(arrow)
library(dplyr)

# Set up a CSV reader with chunking
csv_reader <- open_dataset("biodiversity-data/occurence.csv", format = "csv")
start <- Sys.time()
# Filter for Europe observations and write directly to parquet
csv_reader %>%
  filter(continent == "Europe") %>%
  select(
    id,
    scientificName,
    vernacularName,
    longitudeDecimal,
    latitudeDecimal,
    countryCode,
    eventDate
  ) %>%
  write_dataset(path = "data/europe_per_species.parquet",
                format = "parquet", 
                max_partitions = 10000L, 
                max_open_files = 2000L,
                max_rows_per_file = 500000L,
                partitioning = "scientificName")
end <- Sys.time()
print(paste("Time taken to process the data:", end - start))