
colSel <- function(col, tbl_name) {
  if (!(is.null(tbl_name) || is.na(tbl_name))) {
    cols <- col$get_parentTable()$get_parentDB()$get_tables()[[tbl_name]]$get_nameColumns()
    as.list(cols)
  } else {
    list()
  }

}

onecol <- function(col) {

  getx <- function(name) {
    f <- paste0("get_", name)
    match.fun(col[[f]])
  }

  inputcol <- function(name, label = id, inputType, ...) {

    id <- id_gen(id_int, name)

    isLocked <- bindingIsLocked(name, col$.__enclos_env__$private)

    if (deparse(substitute(inputType)) == "selectInput") {
      inputType(inputId = id, label = label, selected = getx(name)(), ...)
    } else {
      inputType(inputId = id, label = label, value = getx(name)(), disabled = isLocked, ...)
    }

  }

  tblSel <- function() {
    tbl_names <- col$get_parentTable()$get_parentDB()$get_nameTables()
    as.list(tbl_names)
  }

  id_int <- id_gen(col$get_nameTable(), col$get_name())
  #browser()
  tabPanel(title = col$get_name(),
    inputcol("name", "Column name", d_textInput),
    inputcol("label", "Column label", d_textInput),
    inputcol("isFK", "Is column foreign key", d_checkboxInput),
    conditionalPanel(condition = paste0("input.", id_gen(id_int, "isFK"), " == true"),
      inputcol("refTable", "Reference table for FK", d_textInput),
      inputcol("refCol", "Reference column for FK", d_textInput),
      inputcol("textColFK", "Reference text column for FK", selectInput, choices = colSel(col, col$get_refTable()))),
    inputcol("typeData", "Data type of column", d_textInput),
    inputcol("defaultVal", "Default value from database", d_textInput),
    inputcol("defaultValUserDefined", "Default value as defined by user", d_textInput),
    helpText("one sided formula interface to be used, like ~ Sys.Date(), ~ 'xxx', ~ 2L"),
    inputcol("isRequired", "Is the column required", d_checkboxInput),
    inputcol("validationStatements", "User defined validation statements", d_textInput),
    helpText("semi colon separated one sided formula interface to be used, like ~ .. < Sys.Date(); ~ .. > Sys.Date()"),
    inputcol("isSelect", "Is Select Widget to be used?", d_checkboxInput),
    conditionalPanel(condition = paste0("input.", id_gen(id_int, "isSelect"), " == true"),
      selectInput(id_gen(id_int, "valSource"), "Source of value", choices = list("From database" = "db", "User defined list" = "udl")),
      conditionalPanel(condition = paste0("input.", id_gen(id_int, "valSource"), " == 'db'"),
        selectInput(id_gen(id_int, "selectTblName"), "Select table", choices = tblSel()),
        selectInput(id_gen(id_int, "selectValColName"), "Select column for value", choices = list()),
        selectInput(id_gen(id_int, "selectTextColName"), "Select column for text", choices = list())),
      conditionalPanel(condition = paste0("input.", id_gen(id_int, "valSource"), " == 'udl'"),
        inputcol("selectValCol", "Enter semicolon delimited list of values", d_textInput),
        inputcol("selectTextCol", "Enter semicolon delimited list of texts", d_textInput)),
        helpText("Enter values like 'male'; 'female' or 1;2;3")),
    inputcol("tabIndex", "Enter tab index (order of widget placement)", d_numericInput)
  )

}

onetbl <- function(tbl) {

  masterTable <- function() {
    mt <- tbl$get_dfForeignKey()[["foreign_table_name"]]
    if (is.na(mt)) {
      list()
    } else {
      as.list(mt)
    }
  }

  t1 <- selectInput(id_gen(tbl$get_name(), "masterTable"), "Select master table", choices = masterTable())

  ll <- compact(lapply(tbl$get_columns(), function(x) {
    if (!x$get_isPK()) {
      onecol(x)
    } else NULL
  }))
  #browser()
  tabPanel(tbl$get_name(), t1, do.call(tabsetPanel, c(unname(ll), id = tbl$get_name())))
}

onedb <- function(db) {

  tbls <- db$get_tables()

  do.call(tabsetPanel, c(unname(lapply(tbls, function(x) {
    onetbl(x)
  })), id = "tabTbls"))
}

observe({
  if (input$tb_panel == "mod_schema") {
    isolate({
      output$sch <- renderUI(isolate(onedb(schema$db_schema)))
    })
  }
})

observe({
  if (input$tb_panel == "mod_schema") {
    db <- schema$db_schema
    for (tbl in input[["tabTbls"]]) {
      for (col in input[[tbl]]) {
        cl <- db$get_tables()[[tbl]]$get_columns()[[col]]
        id_tbl <- id_gen(tbl, col, "selectTblName")
        id_val <- id_gen(tbl, col, "selectValColName")
        id_text <- id_gen(tbl, col, "selectTextColName")
        updateSelectInput(session, id_val, choices = colSel(cl, input[[id_tbl]]))
        updateSelectInput(session, id_text, choices = colSel(cl, input[[id_tbl]]))
      }
    }
  }
})
