# mod_map.R
mod_map_ui <- function(id) {
  ns <- NS(id)
  card(class = "mb-3 map",
       leafletOutput(ns("map"))
       )
}

mod_map_server <- function(id, filtered_data) {
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
    
    observeEvent(input$map_marker_click, {
      click <- input$map_marker_click
      data <- filtered_data()
      req(nrow(data) > 0)
      
      clicked_row <- data[data$id == click$id, ]
      req(nrow(clicked_row) == 1)
      
      # Popup content
      locality <- clicked_row$locality
      date <- clicked_row$eventDate
      occurrence_link <- clicked_row$occurrenceID
      identifier <- clicked_row$Identifier
      
      has_photo <- !is.na(identifier) && identifier != ""
      
      popup_content <- paste0(
        "<b>Locality:</b> ", locality, "<br/>",
        "<b>Date:</b> ", date, "<br/>",
        "<b><a href='", occurrence_link, "' target='_blank'>More info</a><br/></b> "
      )
      
      if (has_photo) {
        popup_content <- paste0(
          popup_content,
          "<img src='", identifier, "' width='200' style='margin-top:5px;'/>"
        )
      }
      
      leafletProxy("map") |>
        addPopups(
          lng = click$lng,
          lat = click$lat,
          popup = popup_content,
          layerId = "selected_popup"
        )
    })
  })
}
