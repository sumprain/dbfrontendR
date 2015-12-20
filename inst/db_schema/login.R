authenticate <- function(user, pwd, db, host, dbtype) {
  s <- if (dbtype == "postgres") {
    try(dplyr::src_postgres(dbname = db, host = host, user = user, password = pwd))
  } else if (dbtype == "sqlite") {
    try(dplyr::src_sqlite(path = db, create = FALSE))
  }
  s
}

login_rv <- reactiveValues(src = NULL)
schema <- reactiveValues(db_main = NULL)

observe({
  if (input$login_auth > 0L) {
    isolate({
      login_rv$src <- authenticate(user = input$login_name, pwd = input$login_pass, db = input$login_db, host = input$login_loc, dbtype = input$login_dbtype)
    })
  }
})

observe({
  if (input$login_auth > 0L) {
    isolate({
      if (inherits(login_rv$src, "src")) {
        output$login_msg <- renderText("Successfully logged in.")
      } else {
        output$login_msg <- renderText("Failed to login!!")
      }
    })
  }
})

observe({
  if (input$login_auth > 0L) {
    isolate({
      schema$db_main <- try(dbMapR::dbDatabaseClass$new(login_rv$src, date_input = "ymd"))
      if (inherits(schema$db_main, "try-error")) {
        output$db_name <- renderText("Database object population failed!!")
      } else {
        output$db_name <- renderText(isolate(paste0("Database name: ", input$login_loc, "@", schema$db_main$get_name())))
        updateTextInput(session, "login_name", value = "")
        updateTextInput(session, "login_pass", value = "")
        updateTextInput(session, "login_loc", value = "")
        updateTextInput(session, "login_db", value = "")
      }
    })
  }
})

observe({
  if (input$login_logout == 1L) {
    isolate({
      txt_logout <- schema$db_main$disconnect()
      login_rv$src <- NULL
      schema$db_main <- NULL
      output$login_msg <- renderText(isolate(txt_logout))
      output$db_name <- renderText("")
    })
  }
})
