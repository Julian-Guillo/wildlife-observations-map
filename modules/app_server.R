app_server <- function(input, output, session) {
  
  filtered_data <- reactiveVal(MOCK_DATA)
  
  observe({
    req(search_vals$species() != "")
    filtered_data(update_data(search_vals$country(), search_vals$species(), input$view_mode))
  })
  
  search_vals <- mod_search_server("search", view_mode = input$view_mode)
  mod_table_server("table", filtered_data)
}