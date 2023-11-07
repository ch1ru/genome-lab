box::use(
    shiny[NS, fileInput, moduleServer, fluidPage, renderTable, tableOutput, reactive, req],
    vroom
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        fileInput(ns("upload"), NULL),
        tableOutput(ns("files"))
    )
}

#' @export
server <- function(id) {
    moduleServer(id, function(input, output, session) {
        output$files <- renderTable(input$upload)

          data <- reactive({
            req(input$upload)
            
            ext <- tools::file_ext(input$upload$name)
            switch(ext,
            csv = vroom::vroom(input$upload$datapath, delim = ","),
            tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
            validate("Invalid file; Please upload a .csv or .tsv file")
            )
        })
        
        output$head <- renderTable({
            head(data(), input$n)
        })
    })
}