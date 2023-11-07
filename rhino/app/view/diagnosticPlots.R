box::use(
    shiny[h3, dateInput, renderDataTable, renderPlot, plotOutput, renderPrint, verbatimTextOutput, dataTableOutput, actionButton, textOutput, fileInput, icon, checkboxGroupInput, dateRangeInput, selectInput, radioButtons, moduleServer, NS, tableOutput, reactive, textInput, sliderInput, textAreaInput, passwordInput, fluidPage, numericInput, renderText],
    S4Vectors,
    scater,
    gridExtra
)
box::use(
    app/logic/qc
)

ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        plotOutput(ns("plot"))
    )
}

server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$plot <- renderPlot({
            plotColData(data(), x="block", y="sum", colour_by="discard", other_fields="phenotype") + facet_wrap(~phenotype) + scale_y_log10() + ggtitle("Total count")
            plotColData(data(), x="block", y="detected", colour_by="discard", other_fields="phenotype") + facet_wrap(~phenotype) + scale_y_log10() + ggtitle("Detected features")
            plotColData(data(), x="block", y="subsets_Mito_percent", colour_by="discard", other_fields="phenotype") + facet_wrap(~phenotype) + ggtitle("Mito percent")
            plotColData(data(), x="block", y="altexps_ERCC_percent", colour_by="discard", other_fields="phenotype") + facet_wrap(~phenotype) + ggtitle("ERCC percent")
        })
    })
}