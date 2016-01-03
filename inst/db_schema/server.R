library(shiny)

shinyServer(function(input, output, session) {
  source("login.R", local = TRUE)
  source("table_list.R", local = TRUE)
  source("schema.R", local = TRUE)
})
