app_server <- function(input, output, session) {
  
  filtered_data <- reactiveVal(MOCK_DATA)
  
  observe({
    req(search_vals$species() != "")
    filtered_data(update_data(search_vals$country(), search_vals$species(), input$view_mode))
  })
  
  search_vals <- mod_search_server("search", input$view_mode)
  selected_row <- mod_table_server("table", filtered_data)
  mod_map_server("map", filtered_data, selected_row)
  mod_timeline_server("timeline", filtered_data)
  mod_counter_server("counter", filtered_data)
}