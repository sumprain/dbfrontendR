# try to make a function which will provide layout for a login page
library(shiny)

shiny::shinyApp(ui = shiny::fluidPage(make_login()), server = function(input, output) {
  login_server()
  login_server1()
})

ui <- basicPage(
  DT::dataTableOutput("output_data"),
  downloadButton("download"),
  verbatimTextOutput("session_info")
)

server <- function(input, output, session) {

  output$output_data <- DT::renderDataTable({
    DT::datatable(iris)
  })

  output$session_info <- renderPrint({
    cat(session$clientData$url_search, "\n")
    cat(session$clientData$url_hostname, "\n")
    cat(session$clientData$url_port, "\n")
    cat(session$clientData$url_protocol, "\n")
    cat(session$clientData$url_pathname)
  })

  output$download <- downloadHandler(filename = function() {
    paste("data-", Sys.Date(), ".csv", sep = "")
  },

  content = function(con) {
    write.csv(iris, con)
  })
}

shinyApp(ui, server)
