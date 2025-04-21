mod_table_ui <- function(id) {
  ns <- NS(id)
  DTOutput(ns("data_table"))
}

mod_table_server <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$data_table <- renderDT({
      data <- filtered_data()
      
      if (nrow(data) == 0) {
        return(datatable(
          data.frame(Message = "No observations found for this species in the selected country."),
          options = list(dom = 't'),
          rownames = FALSE,
          class = 'compact small'
        ))
      }
      
      datatable(
        data,
        options = list(
          pageLength = 10,
          scrollY = "50vh",
          scrollX = TRUE,
          scroller = TRUE,
          paging = TRUE,
          dom = 'frtip'
        ),
        selection = list(mode = "single", target = "row"),
        rownames = FALSE,
        class = 'compact small'
      )
    })
  })
}
