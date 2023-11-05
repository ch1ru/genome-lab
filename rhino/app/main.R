box::use(
  shiny[bootstrapPage, div, moduleServer, NS, reactive, titlePanel],
  reactable[reactable],
  scRNAseq,
)
box::use (
  app/view[chart, table, inputs, outputs, reactiveDemo, qcView, filterQCView],
  app/logic/rhinos,
  app/logic/qc,
)

grid <- function(...) div(class = "grid", ...)
card <- function(...) div(class = "card", ...)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    titlePanel("Rhino population"),
    grid(
      #card(table$ui(ns("table"))),
      #card(chart$ui(ns("chart"))),
      #card(inputs$ui(ns("inputs"))),
      #card(outputs$ui(ns("outputs"))),
      #card(reactiveDemo$ui(ns("reactiveDemo"))),
      card(qcView$ui(ns("qcView"))),
      card(filterQCView$ui(ns("filterQCView"))),
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    sce.416b <- reactive(scRNAseq$LunSpikeInData(which="416b"))
    data <- reactive(rhinos$fetch_data())
    sce_qc <- reactive(qc$runPerCellQCMetrics(sce.416b))

    #table$server("table", data)
    #chart$server("chart", data)
    #inputs$server("inputs", data)
    #outputs$server("outputs", sce.416b)
    #reactiveDemo$server("reactiveDemo", data)
    qcView$server("qcView", sce_qc)
    filterQCView$server("filterQCView", sce_qc)
  })
}
