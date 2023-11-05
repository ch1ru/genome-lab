box::use(
    shiny[textOutput, NS, fluidPage, textInput, renderText, moduleServer]
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        textInput(ns("name"), "What's your name?"),
        textOutput(ns("greeting"))
    )
}

#' @export
server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$greeting <- renderText({
            paste0("Hello ", input$name, "!")
        })
    })
}