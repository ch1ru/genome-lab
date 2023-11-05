box::use(
    shiny[h3, dateInput, actionButton, fileInput, icon, checkboxGroupInput, dateRangeInput, selectInput, radioButtons, moduleServer, NS, tableOutput, reactive, textInput, sliderInput, textAreaInput, passwordInput, fluidPage, numericInput],
)

#' @export
ui <- function(id) {
    animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

    fluidPage(
        textInput("name", "What's your name?"),
        passwordInput("password", "What's your password?"),
        textAreaInput("story", "Tell me about yourself", rows = 3),
        sliderInput("min", "Limit (minimum)", value=50, min=0, max=100),
        sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100),
        numericInput("num", "Number one", value = 0, min = 0, max = 100),
        dateInput("dob", "When were you born?"),
        dateRangeInput("holiday", "When do you want to go on vacation next?"),
        selectInput("state", "What's your favourite state?", animals),
        selectInput("state", "What's your favourite state?", animals, multiple = TRUE),
        radioButtons("animal", "What's your favourite animal?", animals),
        checkboxGroupInput("animal", "What animals do you like?", animals),
        fileInput("upload", NULL),
        actionButton("click", "Click me!", class = "btn-danger"),
        actionButton("drink", "Drink me!", class = "btn-lg btn-success"),
        actionButton("click_color", "Click me!"),
        actionButton("drink_color", "Drink me!", icon = icon("cocktail")),
    )   
}

#' @export
server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        print("server function in inputs")
    })
}