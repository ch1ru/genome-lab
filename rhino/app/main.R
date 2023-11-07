box::use(
  shiny[bootstrapPage, div, moduleServer, NS, reactive, titlePanel, plotOutput, renderPlot],
  reactable[reactable],
  scRNAseq,
  scater,
  scuttle,
  SingleCellExperiment,
)
box::use (
  app/view[chart, table, inputs, outputs, reactiveDemo, qcView, filterQCView, diagnosticPlots, uploadDataView, discardChartView, normalizeView],
  app/logic/rhinos,
  app/logic/qc,
)

grid <- function(...) div(class = "grid", ...)
card <- function(...) div(class = "card", ...)


#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    titlePanel("Genome Lab"),
    grid(
      card(uploadDataView$ui(ns("uploadData"))),
      card(qcView$ui(ns("qcView"))),
      card(filterQCView$ui(ns("filterQCView"))),
      card(discardChartView$ui(ns("discardChartView"))),
      card(normalizeView$ui(ns("normalizeView")))
      
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    sce.416b <- reactive(scRNAseq::LunSpikeInData(which="416b"))
    sce.zeisel <- reactive(scRNAseq::ZeiselBrainData())
    sce_qc <- reactive(qc$runPerCellQCMetrics(sce.416b))

    uploadDataView$server("uploadData")
    qcView$server("qcView", sce_qc)
    filterQCView$server("filterQCView", sce_qc, sce.416b)
    discardChartView$server("discardChartView", sce.zeisel)
    normalizeView$server("normalizeView", sce.zeisel)

  })
}
