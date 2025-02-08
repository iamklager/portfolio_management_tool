SummaryServer <- function(id, conn, currency, aum, total_profits, monthly_investments, portfolio_returns, sharpe_ratio) {
  moduleServer(id, function(input, output, session) {
    
    output$out_Sharpe <- renderUI({
      sharpe_ratio()
    })
    
    
    output$out_TotalProfit <- renderUI({
      tags$span(
        style = paste0(
          "color: ", total_profits()$color, ";
          margin: auto; text-align: center;
          font-size: 96px;
          "
        ),
        total_profits()$total
      )
    })
    
    
    output$out_TotalProfitPercentage <- renderUI({
      tags$span(
        style = paste0(
          "color: ", total_profits()$color, ";
          margin: auto; text-align: center;
          font-size: 96px;
          "
        ),
        total_profits()$percent
      )
    })
    
    
    output$out_AUM <- renderHighchart({
      hcAUM(portfolio_returns(), currency())
    })
    
    
    output$out_MonthlyInvestments <- renderHighchart({
      hcMonthlyInvestments(monthly_investments(), currency())
    })
    
  })
}

