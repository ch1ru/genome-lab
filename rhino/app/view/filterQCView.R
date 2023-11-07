box::use(
    shiny[h3, dateInput, renderDataTable, plotOutput, renderPlot, renderPrint, verbatimTextOutput, dataTableOutput, actionButton, textOutput, fileInput, icon, checkboxGroupInput, dateRangeInput, selectInput, radioButtons, moduleServer, NS, tableOutput, reactive, textInput, sliderInput, textAreaInput, passwordInput, fluidPage, numericInput, renderText],
    S4Vectors,
    SummarizedExperiment,
    scuttle,
    scater,
)
box::use(
    app/logic/qc
)

#' @export
ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        numericInput(ns("sum"), "Max Sum", min=0, max=10, value=1e5),
        numericInput(ns("max_detected"), "Max Detected", min=0, max=200, value=5e3),
        numericInput(ns("ercc_pct"), "Max ERCC Percent %", max=100, min=0, value=10),
        numericInput(ns("mito_pct"), "Max Mito Percent %", max=100, min=0, value=10),

        dataTableOutput(ns("df")),
        verbatimTextOutput(ns("reasons")),
        verbatimTextOutput(ns("discard")),
        verbatimTextOutput(ns("low_lib_size")),
        verbatimTextOutput(ns("low_n_features")),
        verbatimTextOutput(ns("outlyingness")),
        verbatimTextOutput(ns("filtered"))
    )   
}

#' @export
server <- function(id, data, original) {
    moduleServer(id, function(input, output, session) {

        df <- reactive({
            qc.lib <- data()$sum < input$sum
            qc.nexprs <- data()$detected < input$detected
            qc.spike <- data()$altexps_ERCC_percent > input$ercc_pct
            qc.mito <- data()$subsets_Mito_percent > input$mito_pct
            discard <- qc.lib | qc.nexprs | qc.spike | qc.mito

            df <- S4Vectors::DataFrame(
                LibSize=sum(qc.lib),
                NExprs=sum(qc.nexprs),
                SpikeProp=sum(qc.spike),
                MitoProp=sum(qc.mito),
                Total=sum(discard)
            )

            return(df)
        })

        output$df <- renderDataTable(df())

        reasons <- reactive(qc$runPerCellQCFilters(data()))
        output$reasons <- renderPrint(colSums(as.matrix(reasons())))
        output$discard <- renderPrint(summary(reasons()$discard))
        output$low_lib_size <- renderPrint(attr(reasons()$low_lib_size, "thresholds"))
        output$low_n_features <- renderPrint(attr(reasons()$low_n_features, "thresholds"))
        output$outlyingness <- renderPrint(summary(qc$runRobustBaseOutliers(data())))

        #remove low quality cells
        output$filtered <- renderPrint(summary(original()[,!reasons$discard]))

       

    })

}