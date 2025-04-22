# mod_map.R
mod_map_ui <- function(id) {
  ns <- NS(id)
  card(class = "mb-3 map",
       card_header(textOutput(ns("map_card_header"))),
       card_body(
         class = "p-0",
         leafletOutput(ns("map")))
         
       )
}

mod_map_server <- function(id, filtered_data, selected_row) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Store the previous filtered data to check for changes
    prev_filtered_data <- reactiveVal(NULL)
    
    # Dynamic card header using renderText
    output$map_card_header <- renderText({
      selected_species <- filtered_data()$scientificName[1]
      req(selected_species)  # Ensure that a species is selected
      
      paste("Map of Observations for", selected_species)
    })
    
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = 15, lat = 54, zoom = 4)
    })
    
    observe({
      data <- filtered_data()
      proxy <- leafletProxy("map")
      
      # Clear existing markers
      proxy %>%
        clearMarkers() %>% 
        clearPopups()
      
      if (!is.null(data) && nrow(data) > 0) {
        proxy %>%
          addCircleMarkers(
            data = data,
            lng = ~longitudeDecimal,
            lat = ~latitudeDecimal,
            radius = 5,
            color = "#1f77b4",
            stroke = TRUE,
            fillOpacity = 0.8,
            label = ~paste0(locality, " — ", eventDate),
            layerId = ~id
          ) %>%
          setView(
            lng = mean(data$longitudeDecimal, na.rm = TRUE),
            lat = mean(data$latitudeDecimal, na.rm = TRUE),
            zoom = 5
          )
      } else {
        proxy %>%
          setView(lng = 15, lat = 54, zoom = 4)
      }
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
      req(!is.null(row),
          nrow(row) == 1,
          !is.na(row$longitudeDecimal),
          filtered_data())
      
      current_data <- filtered_data()$id
      if (identical(prev_filtered_data(), current_data) | is.null(prev_filtered_data())) {
        # Re-center the map and zoom in to the selected point
        show_popup(row)
        leafletProxy("map") %>%
        setView(lng = row$longitudeDecimal, lat = row$latitudeDecimal, zoom = 14)
        
      }
      # Update the previous filtered data
      prev_filtered_data(current_data)
    })
  })
}
