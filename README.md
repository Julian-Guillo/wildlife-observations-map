# wildlife-observations-map

This Shiny app was developed for the [Appsilon Technical Challenge](https://appsilon.com) and visualizes biodiversity observations from [Observation.org](https://observation.org).

It features an interactive map, species search bar, observation timeline, and value boxes — built with performance, modularity, and scalability in mind.

See app [here](https://julianguillo.shinyapps.io/biodiversity_dashboard/).


## 🐦 App Highlights

- 🔍 **Search** by vernacular or scientific name.
- 🗺️ **Interactive Leaflet map** of species observation, with clickable points. If photo avialable, it is shown in the popup. Efficient usage of leafletProxy to update the map without re-rendering.
- 📆 **Timeline** displaying observation dates.
- 📊 **Value box** summarizing total observations.
- 🧭 **Data table with map interaction**: Selecting a row in the observation table highlights it on the map with a popup and zoom.
- 📦 **Efficient data loading** using partitioned Parquet files.
- 🧱 Built using **Shiny modules** for scalability and code organization.


**Psst!** Small **surprise** on first app load. Click on the table or the map point to see this weird "species"!

---

## 🔄 Data Preprocessing

The original datasets (`occurrence.csv` ~20 GB and `multimedia.csv` ~1.5 GB) were too large to load into memory or deploy directly. To overcome this, the data was preprocessed using [`arrow`](https://arrow.apache.org/) and saved in partitioned [Parquet](https://parquet.apache.org/) format for efficient querying and scalability.

### Steps:

1. **Filtering to Poland**
   - Initially filtered to only Polish observations to reduce size and simplify testing.
   - Saved to disk in Parquet format partitioned by the `scientificName` column.

2. **Expanding to Europe**
   - Preprocessing extended to include all European observations.
   - Due to ShinyApps.io's 1GB bundle limit, full Europe-wide deployment was not possible.

3. **Compromise: Selected European Countries**
   - Included some representative countries to demonstrate the app's functionality.
   - Code supports more countries with no need to modify app logic.

4. **Partitioning Strategy**
   - Final Parquet files are **partitioned by species** (e.g., `scientificName=Panthera_leo`) for fast, selective access.
   - At runtime, only the necessary species data is loaded into memory.

---

## 🚀 Deployment

Deployment is on [**shinyapps.io**](https://julianguillo.shinyapps.io/biodiversity_dashboard/) due to time constraints. Dataset and performance are limited accordingly. App should nevertheless work smoothly with the smaller dataset provided there.

- Demo includes only a few European countries.
- For full-scale deployment, consider:
  - **Posit Connect**
  - **Shiny Server Pro**
  - **ShinyProxy** or a cloud-native solution with persistent storage.

---

## 📁 File Structure

I tried to keep the file structure clean and organized without overcomplicating it. Here's a brief overview:

### Folders:
- `R/` — Contains R scripts for app logic, modules, and helper functions.
- `data/` — Preprocessed data files in Parquet format.
- `modules/` — Contains Shiny modules like `mod_map`, `mod_timeline`, `mod_valuebox`, `mod_search`, `mod_table`, `app_ui`, `app_server`.
- `preprocessing/` — Scripts for preprocessing the raw data into Parquet format.
- `renv/` — Contains environment setup for the project using **`renv`**.
- `www/` — Static files such as CSS, JS, and other utilities used in modules.

### Files:
- `global.R` — Global app setup, shared resources.
- `app.R` — Main app file, includes UI and server logic.

---

## 🔄 Data Setup

To run the app locally, you'll need the preprocessed dataset. You can download it from the following link:

[Download the dataset](https://drive.google.com/file/d/1tiAuXvj_-b3kHcYxcCvtDVdeTgyE8dZ9/view?usp=drive_link)

After downloading, place the dataset in the `data/` folder of the project directory, unzip it, and the app should work seamlessly.

---

## 🔧 Setting Up the Project

This app uses **`renv`** to manage package dependencies and ensure consistent environments across different machines.

### Steps to install and run:

1. **Install R** — Ensure you have R installed. You can download it from [here](https://cran.r-project.org/).

2. **Install Dependencies**:
   - Clone this repository or download the app files.
   - Open RStudio and navigate to the project folder.
   - Run the following command to restore the required packages from the **`renv`** environment:
     ```r
     renv::restore()
     ```
   - This will install all necessary packages as per the `renv.lock` file.

3. **Run the App**:
   - After restoring the environment, you can run the app using:
     ```r
     shiny::runApp()
     ```

By using **`renv`**, the project is self-contained, and dependencies are managed in an isolated environment, ensuring that the app runs as expected regardless of your system's installed packages.

---

## 📌 Notes

- Data preprocessing is **fully decoupled** from the Shiny logic.
- Uses **`arrow`** for fast, memory-efficient loading.
- Designed to scale: Easily extend to more species or regions without major code changes.
- Ideal for biodiversity exploration, citizen science platforms, or educational dashboards.

---

## 🛠️ Future Improvements
- **Add tests/ folder**: Implement unit tests for critical functions and modules to ensure reliability and maintainability.
  - Add unit tests with testthat.
  - Add end-to-end tests with shinytest.
- Deploy app with **larger dataset**. Need to consider hosting options like Posit Connect or ShinyProxy.
- Add **more custom CSS** styles for a more polished look. Using basic prebuilt bs theme at the moment.