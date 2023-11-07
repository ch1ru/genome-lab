box::use(
    shiny[NS, moduleServer, fluidPage, plotOutput, renderPlot, reactive],
    scater,
    SummarizedExperiment,
    scuttle,
    SingleCellExperiment,
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        plotOutput(ns("plot"))
    )
}

#' @export
server <- function (id, data) {
    moduleServer(id, function(input, output, session) {

        df <- reactive({
            data_new <- scater::aggregateAcrossFeatures(data(), id=sub("_loc[0-9]+$", "", rownames(data())))
            qc <- scater::quickPerCellQC(SummarizedExperiment::colData(data_new), sub.fields=c("altexps_ERCC_percent", "subsets_Mt_percent"))
            data_new$discard <- qc$discard
            return(data_new)
        })
        
        output$plot <- renderPlot(scater::plotColData(df(), x="sum", y="subsets_Mt_percent", colour_by = "discard"))
    })
}