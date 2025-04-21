app_ui <- function() {
  page_navbar(
    title = "Species Observations",
    fillable = TRUE,
    id = "view_mode",
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
    ),
    
    nav_panel(title = "Per country", class = "custom-nav-panel"),
    nav_panel(title = "Europe", class = "custom-nav-panel"),
    
    layout_columns(
      col_widths = c(7, 5),
      
      div(
        class = "m-3",
        mod_map_ui("map"),
        layout_columns(
          col_widths = c(8, 4),
          mod_timeline_ui("timeline"),
          mod_counter_ui("counter")
      )),
      
      div(
        class = "m-3",
        mod_search_ui("search"),
        mod_table_ui("table")
      )
    )
  )
}