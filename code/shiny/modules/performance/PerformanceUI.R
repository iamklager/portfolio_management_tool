PerformanceUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    layout_columns(
      col_widths = c(6, 6),
      
      navset_card_underline(
        title="Portfolio Performance",
        nav_panel(
          title=NULL, 
          highchartOutput(ns("out_PortfolioPerformance"))
        )
      ),
      
      navset_card_underline(
        title="Asset Performance",
        nav_panel(
          title="Stocks",
          highchartOutput(ns("out_StockPerformance"))
        ),
        nav_panel(
          title="Alternatives",
          highchartOutput(ns("out_AltPerformance"))
        )
      )
    ),
    
    layout_columns(
      col_widths = c(6, 6),
      
      navset_card_underline(
        title="Cumulative Price Development",
        nav_panel(
          title="Stocks",
          highchartOutput(ns("out_StockDevelopment"))
        ),
        nav_panel(
          title="Alternatives",
          highchartOutput(ns("out_AltDevelopment"))
        )
      ),
      
      navset_card_underline(
        title="Transactions",
        nav_panel(
          title=NULL,
          div(
            style = "display: flex; gap: 20px;",
            selectizeInput(
              inputId=ns("in_TransHistoryTicker"),
              label="Asset",
              choices=QueryTransactionHistoryTickers(
                conn, format(Sys.Date(), "%Y-01-01"), format(Sys.Date(), "%Y-%m-%d")
              )
            )
          ),
          highchartOutput(ns("out_TransactionHistory"))
        )
      )
    )
  )
}