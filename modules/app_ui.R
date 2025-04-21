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
        card(class = "timeline", style = "min-height: 20vh;", 
             "This is a small card, e.g., for summary or status.")
      ),
      
      div(
        class = "m-3",
        mod_search_ui("search"),
        mod_table_ui("table")
      )
    )
  )
}