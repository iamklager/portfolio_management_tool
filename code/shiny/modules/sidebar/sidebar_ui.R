SidebarUI <- function(id) {
  ns <- NS(id)
  
  bslib::sidebar(
    tags$hr(),
    tags$b("Set Date Range:"),
    div(
      style = "display: flex; gap: 20px;",
      dateInput(
        inputId   = ns("in_DateFrom"),
        label     = "From",
        value     = format(Sys.Date(), "%Y-01-01"),
        min       = as.Date("1900-01-01", format="%Y-%m-%d"),
        format    = "yyyy-mm-dd",
        startview = "year"
      ),
      dateInput(
        inputId   = ns("in_DateTo"),
        label     = "To",
        value     = Sys.Date(),
        min       = as.Date("1900-01-01", format="%Y-%m-%d"),
        max       = Sys.Date(),
        format    = "yyyy-mm-dd",
        startview = "year"
      )
    ),
    div(
      style = "display: flex; gap: 20px;",
      actionButton(
        inputId = ns("in_DateAll"),
        label   = "All Time",
        width   = "50%"
      ),
      actionButton(
        inputId = ns("in_DateYTD"),
        label   = "YTD",
        width   = "50%"
      )
    ),
    div(
      style = "display: flex; gap: 20px;",
      actionButton(
        inputId = ns("in_Date1Y"),
        label   = "1 Year",
        width   = "50%"
      ),
      actionButton(
        inputId = ns("in_DateMonth"),
        label   = "Month",
        width   = "50%"
      )
    ),
    tags$hr(),
    div(
      style = "display: flex; gap: 20px;",
      selectizeInput(
        inputId  = ns("in_Currency"),
        label    = "Currency",
        choices  = dbGetQuery(conn, "SELECT Currency FROM currencies ORDER BY Currency ASC;")[, 1],
        selected = dbGetQuery(conn, "SELECT Currency FROM settings;")[1, 1]
      )
    ),
    tags$hr(),
    
    # Summary inputs
    conditionalPanel(
      condition = "input.pageid == 'Summary'",
      div(
        style = "display: flex; gap: 20px;",
        numericInput(
          inputId = ns("in_SummaryRiskFreeRate"),
          label = "Risk-Free-Rate (in %)",
          value = dbGetQuery(conn, "SELECT RiskFreeRate FROM settings;")[1, 1],
          step = 0.5
        )
      ),
      tags$hr()
    ),
    
    # Risk inputs
    conditionalPanel(
      condition = "input.pageid == 'Risk'",
      div(
        style = "gap: 20px;",
        radioButtons(
          inputId  = ns("in_RiskCorrelationMethod"),
          label    = "Correlation Method",
          choices  = c("pearson", "kendall", "spearman"),
          selected = "pearson"
        ),
        radioButtons(
          inputId  = ns("in_RiskTimeFrame"),
          label    = "Time-Frame",
          choices  = c("Selection", "1 Year", "3 Years", "5 Years", "Entire History"),
          selected = dbGetQuery(conn, "SELECT RiskTimeFrame FROM settings;")[1, 1]
        )
      ),
      tags$hr()
    ),
    
    # Transactions: Download button
    conditionalPanel(
      condition = "input.pageid == 'Tracking'",
      downloadButton(
        outputId = "out_TransactionsDownload",
        label = "Download Transactions"
      )
    )
    
    # # Hidden dark mode switch
    # conditionalPanel(
    #   condition="false",
    #   input_dark_mode(
    #     id="in_DarkMode",
    #     mode="light"
    #   )
    # )
  )
  
}