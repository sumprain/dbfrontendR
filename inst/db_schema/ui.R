make_login <- function() {

  tagList(
    tags$h1("Login ..."),
    textInput("login_name", "Login name"),
    passwordInput("login_pass", "Password"),
    textInput("login_db", "Database name"),
    helpText("(Enter full path of database, if it is SQLite)"),
    textInput("login_loc", "Location", "localhost"),
    selectInput("login_dbtype", "Type of database",
                       choices = c("postgres", "sqlite"), selected = "postgres",
                       selectize = FALSE),
    hr(),
    actionButton("login_auth", "Authenticate"),
    actionButton("login_logout", "Log out"),
    textOutput("login_msg"),
    textOutput("db_name")
  )
}

shinyUI(fluidPage(
  tabsetPanel(id = "tb_panel",
    tabPanel("Login", value = "login",
            column(4, make_login(), offset = 4)),
    tabPanel("Select tables", value = "sel_tbl",
             column(8, uiOutput("chks"), offset = 2)),
    tabPanel("Modify schema", value = "mod_schema")
)))
