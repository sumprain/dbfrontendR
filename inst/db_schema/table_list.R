table_df <- function(db) {
  tbl_name <- db$get_nameTables()
  do.call(rbind, lapply(tbl_name, function(x) {
    cbind(tbl_name = x, db$get_tables()[[x]]$get_dfForeignKey(), stringsAsFactors = FALSE)
  }))
}

label_text <- function(name, tbl_df) {
  lab1 <- name
  linked_tbls <- tbl_df[(tbl_df[['foreign_table_name']] == name) & !is.na(tbl_df[['foreign_table_name']]), 'tbl_name', drop = TRUE]
  if (length(linked_tbls) == 0L) {
    lab2 <- "No child table"
  } else {
    lab2 <- paste(linked_tbls, collapse = ", ")
    lab2 <- paste0("Child(ren) table(s) <", lab2, ">")
  }
  paste(lab1, lab2, sep = ": ")
}

l_tab_chkbox <- function(tbl_df) {
  names <- unique(tbl_df[["tbl_name"]])
  len <- length(names)
  labels <- character(len)

  for (i in 1:len) {
    labels[i] <- label_text(names[i], tbl_df)
  }
  setNames(as.list(names), labels)
}

observe({
  if (input$tb_panel == "sel_tbl") {
    isolate({
      schema$tbl_fk_df <- table_df(schema$db_main)
      output$chks <- renderUI({
        isolate({
          list(h1("Select tables ..."),
          checkboxGroupInput("chk_tables", label = "Check on tables to be included for scehma generation", choices = l_tab_chkbox(schema$tbl_fk_df), width = "100%"),
          helpText("It is advised that the children tables \nof a given table are to be included for schema generation"),
          actionButton("chk_ok", label = "Click to select tables"))
        })
      })
    })
  }
})

observe({
  if ((input$tb_panel == "sel_tbl") && (!is.null(input$chk_ok)) && (input$chk_ok > 0L)) {
    isolate({
      schema$tbl_schema <- input$chk_tables
      schema$db_schema <- schema$db_main$clone()$tbls_tobe_kept(schema$tbl_schema)
    })
  }
})
