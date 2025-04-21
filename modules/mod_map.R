# mod_map.R
mod_map_ui <- function(id) {
  ns <- NS(id)
  card(class = "mb-3 map",
       leafletOutput(ns("map"))
       )
}

mod_map_server <- function(id, filtered_data, selected_row) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$map <- renderLeaflet({
      data <- filtered_data()
      req(nrow(data) > 0)
      
      leaflet(data) |>
        addTiles() |>
        addCircleMarkers(
          lng = ~longitudeDecimal,
          lat = ~latitudeDecimal,
          radius = 5,
          color = "#2c7fb8",
          stroke = FALSE,
          fillOpacity = 0.8,
          label = ~paste0(locality, " — ", eventDate),
          layerId = ~id
        )
    })
    
    # Trigger popup on point click
    observeEvent(input$map_marker_click, {
      click <- input$map_marker_click
      data <- filtered_data()
      row <- data[data$id == click$id, ]
      show_popup(row)
    })
    
    # Trigger popup when selected_row changes
    observeEvent(selected_row(), {
      row <- selected_row()
      req(!is.null(row), nrow(row) == 1)
      show_popup(row)
    })
  })
}
