show_popup <- function(row) {
  req(nrow(row) == 1)
  
  locality <- row$locality
  date <- row$eventDate
  occurrence_link <- row$occurrenceID
  identifier <- sub(pattern = "photos/", replacement = "media/photo/", x = row$Identifier)
  has_photo <- !is.na(identifier) && identifier != ""
  
  popup_content <- paste0(
    "<b>Locality:</b> ", locality, "<br/>",
    "<b>Date:</b> ", date, "<br/>",
    "<b><a href='", occurrence_link, "' target='_blank'>More info</a></b><br/>"
  )
  
  if (has_photo) {
    popup_content <- paste0(
      "<img src='", gsub("/$", ".jpg", identifier), "' width='200' style='margin-bottom:5px;'/><br/>",
      popup_content
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