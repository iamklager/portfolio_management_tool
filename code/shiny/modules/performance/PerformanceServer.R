PerformanceServer <- function(
    id, conn, tracking, from, to, currency, prices, aggr_prices, 
    transactions_to, weighted_returns, asset_performance, portfolio_returns
) {
  moduleServer(id, function(input, output, session) {
    
    ## Portfolio development
    port_perf <- reactive({
      ComputePortfolioPerformance(aggr_prices())
    })
    output$out_PortfolioPerformance <- renderHighchart({
      hcPortfolioPerformance(portfolio_returns())
    })

    ## Asset development
    output$out_StockDevelopment <- renderHighchart({
      hcAssetDevelopment(weighted_returns(), "Stock")
    })
    output$out_AltDevelopment <- renderHighchart({
      hcAssetDevelopment(weighted_returns(), "Alternative")
    })
    
    ## Asset performance
    output$out_StockPerformance <- renderHighchart({
      hcAssetPerformance(asset_performance(), "Stock")
    })
    output$out_AltPerformance <- renderHighchart({
      hcAssetPerformance(asset_performance(), "Alternative")
    })
    
    ## Transactions
    observeEvent(from(), {
      updateSelectizeInput(
        inputId="in_TransHistoryTicker",
        choices=QueryTransactionHistoryTickers(conn, from(), to())
      )
    })
    observeEvent(to(), {
      updateSelectizeInput(
        inputId="in_TransHistoryTicker",
        choices=QueryTransactionHistoryTickers(conn, from(), to())
      )
    })
    observeEvent(tracking(), {
      updateSelectizeInput(
        inputId="in_TransHistoryTicker",
        choices=QueryTransactionHistoryTickers(conn, from(), to())
      )
    })
    transaction_history <- reactive({
      TransactionHistory(from(), prices(), transactions_to(), input$in_TransHistoryTicker)
    })
    output$out_TransactionHistory <- renderHighchart({
      hcTransactionHistory(transaction_history(), currency())
    })
    
  })
}

