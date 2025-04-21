mod_search_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    layout_columns(
      col_widths = c(4, 8),
      conditionalPanel(
        condition = "input.view_mode == 'Per country'",
        selectInput(
          inputId = ns("country"),
          label = "Country",
          choices = country_names,
          selected = "PL"
        )
      ),
      
      selectizeInput(
        inputId = ns("species"), 
        label = "Species",
        multiple = FALSE,
        choices = c("Search Bar" = ""),  # Initial empty choices
        options = list(
          create = FALSE,
          placeholder = "Write species name here...",
          maxOptions = 20,
          maxItems = '1',
          onDropdownOpen = I("function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"),
          onType = I("function (str) {if (str === \"\") {this.close();}}"),
          dropdownParent = "body"
        )
      )
    )
  )
}

mod_search_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    species_list <- reactive({
      country <- input$country
      tryCatch({
        readRDS(paste0("data/species_names/", country, "_species_names.rds"))
      }, error = function(e) {
        c("No species available for this country" = "")
      })
    })
    
    observeEvent(species_list(), {
      selected_species <- input$species
      updated_species_list <- species_list()
      
      selected_choice <- ifelse(selected_species %in% updated_species_list, selected_species, "")
      
      updateSelectizeInput(
        session = session,
        inputId = "species",
        choices = c("Search Bar" = "", updated_species_list),
        server = TRUE,
        selected = selected_choice
      )
    })
    
    return(list(
      country = reactive(input$country),
      species = reactive(input$species)
    ))
  })
}
