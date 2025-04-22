mod_timeline_ui <- function(id) {
  ns <- NS(id)
  card(class = "timeline", 
       style = "min-height: 20vh;",
       card_header("Evolution of observations over the last 20 years"),
       plotly::plotlyOutput(ns("timeline_plot"), height = "20vh"))
}

mod_timeline_server <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$timeline_plot <- plotly::renderPlotly({
      data <- filtered_data()
      if (nrow(data) == 0) return(NULL)
      
      timeline_data <- prepare_timeline_data(data)
      plot_timeline(timeline_data)
    })
  })
}

