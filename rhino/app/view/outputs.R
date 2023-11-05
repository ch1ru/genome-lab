box::use(
    shiny[textOutput, NS, fluidPage, renderPrint, renderDataTable, renderTable, renderText, tableOutput, dataTableOutput, verbatimTextOutput, moduleServer]
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        textOutput(ns("text")),
        verbatimTextOutput(ns("code")),
        tableOutput(ns("static")),
        dataTableOutput(ns("dynamic")),
    )
}

#' @export
server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$text <- renderText("Summary")
        output$code <- renderPrint(data())
        #output$dynamic <- renderDataTable(data(), options = list(pageLength = 5))
    })
}