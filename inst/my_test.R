# we will use navbarpage with tabpanel to visualise the schema page.
# there will be three tabpanels (login, table_list and schema)
# within the third tabpanel, there will be uiOutput which will hold a tabsetPanel with tabpanels for each table. Each tabpanel of a table will contain tabsetpanel containing tabpanels for each column.

ui1 <- shinyUI(navbarPage("Suman", tabPanel("Tables",
                                            tabsetPanel(tabPanel("table1",
                                                                 tabsetPanel(tabPanel("col11"), tabPanel("col12"))), tabPanel("Table2", tabsetPanel(tabPanel("col21"), tabPanel("col22"))))),
                          tabPanel("xxx",
                                   tabsetPanel(tabPanel("xxx1"), tabPanel("xxx2")))))

server1 <- shinyServer(function(input, output, server){})

shiny::shinyApp(ui1, server1)

ui <- shinyUI(navbarPage("Suman", tabPanel("login"), tabPanel("table list"), tabPanel("schema", uiOutput("out1"))))

server <- shinyServer(function(input, output, session) {
  output$out1 <- renderUI({
    #navbarMenu("suman", tabPanel("tab1"), tabPanel("tab2"))
    #browser()
    col_tbl1 <- c("col11", "col12")
    col_tbl2 <- c("col21", "col22")
    tab1 <- do.call(tabsetPanel, lapply(col_tbl1, tabPanel))
    tab2 <- do.call(tabsetPanel, lapply(col_tbl2, tabPanel))
    myTabs <- mapply(tabPanel, paste0("table", 1:2), list(tab1, tab2), SIMPLIFY = FALSE)
    do.call(tabsetPanel, myTabs)
  })
})

shiny::shinyApp(ui, server)

# check if conditional panel works in renderUI



ui <- shinyUI(fluidPage(uiOutput("out1"), textOutput("ooo")))

server <- shinyServer(function(input, output, session) {

  output$out1 <- renderUI({
    mytextInput("xxx", "xxxx", value = "suman", disabled = TRUE)
  })

  output$ooo <- renderText(input$xxx)
})

shiny::shinyApp(ui, server)

