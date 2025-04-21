# Load global config
source("global.R")

ui <- page_navbar(
  title = "Species Observations",
  fillable = TRUE,
  id = "view_mode",
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  
  nav_panel("Per country"),
  nav_panel("Europe"),
  
  layout_columns(
    col_widths = c(7, 5),
    
    div(
      class = "m-3",
      card(class = "mb-3 map", "testing"),
      card(class = "timeline", style = "min-height: 20vh;", "This is a small card, e.g., for summary or status.")
    ),
    
    div(
      class = "m-3",
      mod_search_ui("search"),
      DTOutput("data_table")
    )
  )
)

server <- function(input, output, session) {
  search_vals <- mod_search_server("search")
  
  mock_data <- data.frame(
    scientificName = "R Shiny Developer",
    vernacularName = "Julián",
    longitudeDecimal = -0.4,
    latitudeDecimal = 39.3,
    locality = "Albal, Valencia, Spain",
    countryCode = "ES",
    eventDate = "2025-04-21",
    Identifier = "R Shiny Developer",
    stringsAsFactors = FALSE
  )
  
  filtered_data <- reactiveVal(mock_data)
  
  observe({
    req(search_vals$species() != "")
    
    path <- file.path(paste0("data/europe_data.parquet/", search_vals$country(), ".parquet/scientificName=", URLencode(search_vals$species())))
    
    new_data <- tryCatch({
      dataset <- open_dataset(path) %>% collect()
      dataset$scientificName <- search_vals$species()
      dataset
    }, error = function(e) {
      data.frame(scientificName = character(0), stringsAsFactors = FALSE)
    })
    
    filtered_data(new_data)
  })
  
  output$data_table <- renderDT({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return(datatable(
        data.frame(Message = "No observations found for this species in the selected country."),
        options = list(dom = 't'),
        rownames = FALSE,
        class = 'compact small'
      ))
    }
    
    datatable(
      data,
      options = list(
        pageLength = 10,
        scrollY = "50vh",
        scrollX = TRUE,
        scroller = TRUE,
        paging = TRUE,
        dom = 'frtip'
      ),
      selection = list(mode = "single", target = "row"),
      rownames = FALSE,
      class = 'compact small'
    )
  })
}

shinyApp(ui = ui, server = server)
