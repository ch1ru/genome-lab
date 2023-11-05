# app/view/chart.R

box::use(
  shiny[h3, moduleServer, NS, tableOutput, reactive],
  reactable[reactableOutput, renderReactable],
)
box::use (
    app/logic/rhinos,
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    reactableOutput(ns("chart"))
}

#' @export
server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$chart <- renderReactable(
            rhinos$rhino_data(data())
        )
    })
}

