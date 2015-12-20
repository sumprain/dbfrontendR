#' Open Database Schema page for designing front end
#'
#' This will open your default browser and run db_schema locally on you computer.
#'
#' @export
db_schema <- function() {
  shiny::runApp(system.file("db_schema", package = "dbfrontendR"))
}
