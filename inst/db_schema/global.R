# load required libraries ----
library(shiny)
library(dbMapR)

# global options -------
options(shiny.trace=TRUE)

# id generator
id_gen <- function(..., sep = "_") {
  l <- vapply(list(...), function(x) as.character(x), character(1L))
  paste0(l, collapse = sep)
}
