prepare_timeline_data <- function(data) {
  data$year <- lubridate::year(data$eventDate)
  
  counts <- data %>%
    dplyr::count(year) %>%
    dplyr::filter(!is.na(year))
  
  target_years <- 2005:2025
  full_timeline <- data.frame(year = target_years)
  
  timeline_data <- full_timeline %>%
    dplyr::left_join(counts, by = "year") %>%
    dplyr::mutate(n = tidyr::replace_na(n, 0))
  
  pre_2005 <- counts %>%
    dplyr::filter(year < 2005)
  
  if (nrow(pre_2005) > 0) {
    max_pre2005 <- pre_2005 %>%
      dplyr::filter(year == max(year))
    
    timeline_data <- dplyr::bind_rows(max_pre2005, timeline_data)
  }
  
  timeline_data %>%
    dplyr::arrange(year)
}

# plot_timeline <- function(plot_data) {
#   plotly::plot_ly(
#     plot_data,
#     x = ~year,
#     y = ~n,
#     type = "scatter",
#     mode = "lines+markers",
#     marker = list(size = 8, color = "#1f77b4"),
#     line = list(color = "#1f77b4", width = 2),
#     hoverinfo = "text",
#     text = ~paste0("Year: ", year, "<br>Observations: ", n)
#   ) %>%
#     plotly::layout(
#       # title = "Observations per Year",
#       xaxis = list(title = "Year"),
#       yaxis = list(title = "Observations")
#     )
# }

plot_timeline <- function(plot_data) {
  plotly::plot_ly(
    plot_data,
    x = ~year,
    y = ~n,
    type = "scatter",
    mode = "lines+markers",
    marker = list(size = 8, color = "#1f77b4"),
    line = list(color = "#1f77b4", width = 2),
    hoverinfo = "text",
    text = ~paste0("Year: ", year, "<br>Observations: ", n)
  ) %>%
    plotly::layout(
      # title = "Observations per Year",
      xaxis = list(title = "Year"),
      yaxis = list(title = "Observations")
    ) %>%
    plotly::config(displayModeBar = FALSE)  # This line hides the modebar completely
}
