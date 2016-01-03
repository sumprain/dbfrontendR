# These inputs are made from copying the text, numeric, checkbox and select inputs from
# shiny package which aim to include an option for them being disabled at the outset

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

formatNoSci <- function(x) {
  if (is.null(x)) return(NULL)
  format(x, scientific = FALSE, digits = 15)
}

d_textInput <- function(inputId, label, value = "", width = NULL,
                        placeholder = NULL, disabled = FALSE) {
  if (!disabled) {
    div(class = "form-group shiny-input-container",
        style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
        label %AND% tags$label(label, `for` = inputId),
        tags$input(id = inputId, type="text", class="form-control", value=value,
                   placeholder = placeholder))
  } else {
    div(class = "form-group shiny-input-container",
        style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
        label %AND% tags$label(label, `for` = inputId),
        tags$input(id = inputId, type="text", class="form-control", value=value,
                   placeholder = placeholder, disabled = ""))
  }

}

d_numericInput <- function(inputId, label, value, min = NA, max = NA, step = NA,
                           width = NULL, disabled = FALSE) {

  # build input tag
  inputTag <- tags$input(id = inputId, type = "number", class="form-control",
                         value = formatNoSci(value))
  if (!is.na(min))
    inputTag$attribs$min = min
  if (!is.na(max))
    inputTag$attribs$max = max
  if (!is.na(step))
    inputTag$attribs$step = step
  if (disabled)
    inputTag$attribs$disabled = ""

  div(class = "form-group shiny-input-container",
      style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
      label %AND% tags$label(label, `for` = inputId),
      inputTag
  )
}

d_checkboxInput <- function(inputId, label, value = FALSE, width = NULL, disabled = FALSE) {

  inputTag <- tags$input(id = inputId, type="checkbox")
  if (!is.null(value) && value)
    inputTag$attribs$checked <- "checked"
  if (disabled)
    inputTag$attribs$disabled <- ""
  div(class = "form-group shiny-input-container",
      style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
      div(class = "checkbox",
          tags$label(inputTag, tags$span(label))
      )
  )
}

