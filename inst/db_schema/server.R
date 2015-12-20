library(shiny)

shinyServer(function(input, output, session) {
  source("login.R", local = TRUE)
})
