box::use(
    shiny[moduleServer, renderPrint, verbatimTextOutput, NS, fluidPage, textOutput, renderText]
)


ui <- function(id) {
    ns <- NS(id)
    fluidPage (
        textOutput(ns("text")),
        verbatimTextOutput(ns("qc_summary")),
        verbatimTextOutput(ns("detected")),
        verbatimTextOutput(ns("mito_pct")),
        verbatimTextOutput(ns("ercc_pct")),
    )
}

server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$text <- renderText("QC summary")
        output$qc_summary <- renderPrint(summary(data()$sum))
        output$detected <- renderPrint(summary(data()$detected))
        output$mito_pct <- renderPrint(summary(data()$subsets_Mito_percent))
        output$ercc_pct <- renderPrint(summary(data()$altexps_ERCC_percent))
    })
}