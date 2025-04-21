app_server <- function(input, output, session) {
  search_vals <- mod_search_server("search")
  mod_table_server("table", search_vals)
}