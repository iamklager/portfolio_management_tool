SummaryUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    layout_columns(
      col_widths = c(6, 6),

      navset_card_underline(
        title="Sharpe Ratio",
        nav_panel(
          title=NULL,
          uiOutput(ns("out_Sharpe"))
        )
      ),

      navset_card_underline(
        title="Profit",
        nav_panel(
          title="Total",
          uiOutput(ns("out_TotalProfit"))
        ),
        nav_panel(
          title="%",
          uiOutput(ns("out_TotalProfitPercentage"))
        )
      )

    ),
    
    layout_columns(
      col_widths = c(6, 6),
      
      navset_card_underline(
        title="Assets Under Management",
        nav_panel(
          title=NULL,
          highchartOutput(ns("out_AUM"))
        )
      ),
      
      navset_card_underline(
        title="Monthly Investments",
        nav_panel(
          title=NULL,
          highchartOutput(ns("out_MonthlyInvestments"))
        )
      )
      
    )
  )
  
}