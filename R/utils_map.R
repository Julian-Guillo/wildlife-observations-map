show_popup <- function(row) {
  req(nrow(row) == 1)
  
  locality <- row$locality
  date <- row$eventDate
  occurrence_link <- row$occurrenceID
  identifier <- row$Identifier
  
  has_photo <- !is.na(identifier) && identifier != ""
  
  popup_content <- paste0(
    "<b>Locality:</b> ", locality, "<br/>",
    "<b>Date:</b> ", date, "<br/>",
    "<b><a href='", occurrence_link, "' target='_blank'>More info</a></b><br/>"
  )
  
  if (has_photo) {
    popup_content <- paste0(
      popup_content,
      "<img src='", gsub("/$", ".jpg", identifier), ".jpg' width='200' style='margin-top:5px;'/>"
    )
  }
  
  leafletProxy("map") %>%
    clearPopups() %>%
    addPopups(
      lng = row$longitudeDecimal,
      lat = row$latitudeDecimal,
      popup = popup_content,
      layerId = "selected_popup"
    )
}