app_ui <- function() {
  page_navbar(
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