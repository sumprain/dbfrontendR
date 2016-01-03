# load required libraries ----
library(shiny)
library(shinyjs)
library(dbMapR)

# global options -------
options(shiny.trace=TRUE)
source("custom_inputs.R", local = TRUE)

# id generator
id_gen <- function(...) {
  l <- vapply(list(...), function(x) as.character(x), character(1L))
  paste(l, collapse = "__")
}

# remove NULL from list
compact <- function(x) {
  retx <- vapply(x, function(y) return(is.null(y)||is.na(y)), logical(1L))
  return(x[!retx])
}
