box::use(
    shiny[NS, moduleServer, fluidPage, renderPrint, verbatimTextOutput, renderPlot, plotOutput, reactive, req],
    scater,
    scran,
    graphics
)
box::use(
    app/logic/normalize
)

ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        verbatimTextOutput(ns("preview")),
        verbatimTextOutput(ns("lib.sf")),
        plotOutput(ns("Hist")),
        verbatimTextOutput(ns("deconv")),
        plotOutput(ns("deconvplot"))
    )
}

server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        output$preview <- renderPrint(data())

        output$lib.sf <- renderPrint(summary(scater::librarySizeFactors(data())))
        lib.sf <- reactive(scater::librarySizeFactors(data()))

        output$Hist <- renderPlot(graphics::hist(log10(lib.sf()), xlab="Log10[Size factor]", col='grey80'))

        clust <- reactive(scran::quickCluster(data()))
        deconv.sf <- reactive(scran::calculateSumFactors(data(), cluster=clust()))
        output$deconv <- renderPrint(summary(deconv.sf()))

        output$deconvplot <- renderPlot({
            graphics::plot(lib.sf(), deconv.sf(), xlab="Library size factor", ylab="Deconvolution size factor", log='xy', pch=16, col=as.integer(factor(data()$level1class)))
            graphics::abline(a=0, b=1, col="red")
        })

    })
}