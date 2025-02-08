TrackingUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    div(
      style = "display: block;",
      DT::DTOutput(ns("out_TransactionList"))
    ),
    tags$hr(),
    tags$b("Track Transaction:"),
    div(
      style = "display: inline-flex; border-width: thick; gap: 1.50%; justify-content: center; align-items: center;",
      dateInput(
        inputId = ns("in_DateAsset"),
        label   = "Date",
        value   = Sys.Date(),
        max     = Sys.Date(),
        format  = "yyyy-mm-dd",
        width   = "8%"
      ),
      textInput(
        inputId     = ns("in_AssetDisplayName"),
        label       = "Name",
        value       = "",
        placeholder = "none",
        width       = "25%"
      ),
      numericInput(
        inputId = ns("in_AssetQuantity"),
        label   = "Quantity",
        value   = 0.00,
        min     = 0.00,
        step    = 1.00,
        width   = "12%"
      ),
      numericInput(
        inputId = ns("in_AssetPriceTotal"),
        label   = "Price (Total)",
        value   = 0.00,
        min     = 0.00,
        step    = 0.50,
        width   = "15%"
      ),
      textInput(
        inputId     = ns("in_AssetTickerSymbol"),
        label       = "Ticker Symbol",
        value       = "",
        placeholder = "none",
        width       = "12%"
      ),
      selectizeInput(
        inputId     = ns("in_AssetType"),
        label       = "Type",
        choices     = c("Stock", "Alternative"),
        selected    = "Stock",
        multiple    = "FALSE",
        width       = "12%"
      ),
      textInput(
        inputId     = ns("in_AssetGroup"),
        label       = "Group",
        value       = "",
        placeholder = "none",
        width       = "12%"
      )
    ),
    div(
      style = "display: inline-flex; border-width: thick; gap: 1.50%; justify-content: center; align-items: center;",
      selectizeInput(
        inputId     = ns("in_AssetTransType"),
        label       = "Transaction Type",
        choices     = c("Buy", "Sell"),
        selected    = "Buy",
        multiple    = "FALSE",
        width       = "18.16%"
      ),
      textInput(
        inputId     = ns("in_AssetTransCur"),
        label       = "Transaction Currency",
        value       = "USD",
        placeholder = "none",
        width       = "18.16%"
      ),
      textInput(
        inputId     = ns("in_AssetSourceCur"),
        label       = "Source Currency",
        value       = "USD",
        placeholder = "none",
        width       = "18.17%"
      ),
      input_task_button(
        id         = ns("in_TrackTransaction"),
        label      = "Track",
        label_busy = "Tracking asset",
        auto_reset = TRUE, state = "ready",
        style      = "width: 41%; height: 40px;"
      )
    ),
    tags$hr(),
    tags$b("File Upload:"),
    div(
      style = "display: inline-flex; border-width: thick; gap: 1.50%; justify-content: center; align-items: center;",
      fileInput(
        inputId = ns("in_FileAssets"),
        label   = "Assets file",
        accept  = c(".csv", ".xlsx"),
        placeholder = ".csv or .xlsx",
        width = "57.50%"
      ),
      input_task_button(
        id         = ns("in_AppendFileTransactions"),
        label      = "Append",
        label_busy = "Appending to assets...",
        auto_reset = TRUE, state = "ready",
        style      = "width: 19.75%; height: 40px;"
      ),
      input_task_button(
        id         = ns("in_OverwriteFileTransactions"),
        label      = "Overwrite",
        label_busy = "Overwriting asset...",
        auto_reset = TRUE, state = "ready",
        style      = "width: 19.75%; height: 40px;"
      )
    )
    
  )
  
}