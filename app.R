library(shiny)
library(arrow)
library(dplyr)
library(DT)

# Load species names from RDS
species_names <- readRDS("data/poland_species_names.rds")

# Define UI
ui <- fluidPage(
  titlePanel("Poland Species Observations"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "species",
        label = "Select Scientific Name",
        choices = species_names,
        selected = NULL,
        multiple = FALSE,
        selectize = TRUE
      )
    ),
    mainPanel(
      DTOutput("data_table")
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Reactive expression to filter dataset by selected species
  filtered_data <- reactive({
    req(input$species)
    
    # Open just the partition corresponding to the selected species
    # this is faster than scanning and filtering all partitions
    path <- file.path(paste0("data/poland_with_multimedia.parquet/scientificName=", URLencode(input$species)))
    dataset <- open_dataset(path) %>%
      collect()
    dataset$scientificName <- input$species # add back the scientific name
    dataset
  })
  
  # Render the datatable
  output$data_table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10), rownames = FALSE)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
