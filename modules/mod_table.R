mod_table_ui <- function(id) {
  ns <- NS(id)
  div(
  tags$label("Select any observation"),
  DTOutput(ns("data_table"))
  )
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
          class = 'compact small table-bordered table-striped'
        ))
      }
      
      datatable(
        data %>%
          select(Locality = locality, Date = eventDate, Photo = Identifier),
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
        class = 'compact small table-bordered table-striped'
      )
    })
    
    # Return the full row (reactively)
    selected_row <- reactive({
      req(input$data_table_rows_selected)
      filtered_data()[input$data_table_rows_selected, ]
    })
    
    return(selected_row)
  })
}
