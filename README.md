# wildlife-observations-map


This Shiny app was developed for the [Appsilon Technical Challenge](https://appsilon.com) and visualizes biodiversity observations from **Observation.org**.

It features an interactive map, species search bar, and observation timeline, built with performance and scalability in mind.


## 🔄 Data Preprocessing

The original datasets (`occurrence.csv` ~20 GB and `multimedia.csv` ~1.5 GB) were too large to load into memory or deploy directly. To overcome this, I preprocessed the data using [`arrow`](https://arrow.apache.org/) and saved it in partitioned [Parquet](https://parquet.apache.org/) format for efficient querying and scalability.

### Steps:

1. **Filtering to Poland**
   - Initially, only Polish observations were processed to test the app pipeline and reduce size.
   - The dataset was filtered and converted to Parquet using the `arrow` R package.
   - Files were **partitioned by species** (`species` column) to allow fast access to individual species without loading the full dataset.

2. **Expanding to Europe**
   - I then extended the preprocessing to include all European observations.
   - However, due to ShinyApps.io's [100MB bundle limit](https://docs.posit.co/shinyapps.io/limits/), the full European dataset could not be included in the deployment.

3. **Compromise: Selected European Countries**
   - To stay within the size limits while demonstrating scalability, I included only a few representative countries (e.g., Poland, Germany, France, Netherlands).
   - The code and file structure, however, are **designed to scale** easily:
     - More countries can be added without changes to the app logic.
     - Only the required partitions are loaded into memory at runtime.
     - This ensures minimal resource usage and fast loading.

4. **Partitioning Strategy**
   - Final Parquet files are **partitioned by species** (e.g., `species=Panthera_leo`) to allow precise and efficient data loading.
   - This enables fast, on-demand reading of species data with minimal memory usage.

---

## ⚙️ App Features

- Map displaying observation points (Leaflet).
- Timeline of observation events.
- Dynamic species search bar (with `selectizeInput` and client-side filtering).
- Optional country selector (visible only in "Per country" mode).

---

## 🚀 Deployment

Due to time limits, the deployment is done in **shinyapps.io**, so both the size of the dataset and the speed of the app are limited.
- The current demo includes only a subset of European countries.
- For full-scale deployment (e.g., Europe-wide or global), consider hosting on **Posit Connect** or **Shiny Server Pro**, or other custom options with **Shiny Proxy**.

---

## 📁 File Structure

```

---

## 📌 Notes

- The preprocessing is decoupled from the Shiny app logic and can be run independently to update or extend the dataset.
- The use of Arrow + Parquet allows reading only the required subset of data into memory — crucial for handling large datasets in Shiny.

