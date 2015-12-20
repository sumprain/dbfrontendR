make_login <- function() {

  shiny::tagList(
    shiny::tags$h1("Login ..."),
    shiny::textInput("login_name", "Login name"),
    shiny::passwordInput("login_pass", "Password"),
    shiny::textInput("login_db", "Database name"),
    shiny::helpText("(Enter full path of database, if it is SQLite)"),
    shiny::textInput("login_loc", "Location", "localhost"),
    shiny::selectInput("login_dbtype", "Type of database",
                       choices = c("postgres", "sqlite"), selected = "postgres",
                       selectize = FALSE),
    shiny::hr(),
    shiny::actionButton("login_auth", "Authenticate ..."),
    shiny::actionButton("login_logout", "Log out ..."),
    shiny::textOutput("login_msg"),
    shiny::textOutput("db_name")
  )
}

shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Login ...", value = "login",
            column(4, make_login(), offset = 4)),
    tabPanel("Select tables", value = "sel_tbl"),
    tabPanel("Modify schema", value = "mod_schema")
  )
))
