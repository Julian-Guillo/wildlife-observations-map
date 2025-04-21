mod_counter_ui <- function(id) {
  ns <- NS(id)
  value_box(
    title = "Observations in the last 20 years",
    value = textOutput(ns("counter")),
    showcase = bsicons::bs_icon("camera"),
    showcase_layout = "left center"
  )
}

mod_counter_server <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$counter <- renderText({
      data <- filtered_data()
      recent_obs <- dplyr::filter(data, lubridate::year(eventDate) >= 2005)
      format(nrow(recent_obs), big.mark = ",")
    })
  })
}
