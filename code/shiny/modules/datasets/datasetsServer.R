datasetsSever <- function(id, conn, today, from, to, currency, tracking, rfr) {
  moduleServer(id, function(input, output, session) {
    
    ## Initial values
    ret_vals <- reactiveValues(
        # Transactions and positions
        current_positions = QueryCurrentPositions(conn, format(Sys.Date(), "%Y-%m-%d")),
        transactions_from_to = NULL,
        transactions_to = QueryTransactionsTo(conn, format(Sys.Date(), "%Y-%m-%d")),
        # Price data
        all_prices = NULL,
        aggr_prices = NULL,
        aum = NULL,
        total_profits = NULL,
        monthly_investments = NULL,
        weighted_returns = NULL,
        asset_performance = NULL,
        portfolio_returns = NULL,
        sharpe_ratio = NULL
    )
    
    ## Daily data update
    observeEvent(today(), {
      
      # Price & XRate update
      UpdateXRates(conn)
      UpdatePrices(conn, ret_vals$current_positions)
    })
    
    ## Date From
    observeEvent(from(), {
      
      # Transactions and positions
      ret_vals$current_positions <- QueryCurrentPositions(conn, to())
      ret_vals$current_positions <- QueryCurrentPositionValues(conn, ret_vals$current_positions, to())
      ret_vals$transactions_from_to <- QueryTransactionsFromTo(conn, from(), to())
      
      # Price data
      ret_vals$all_prices <- QueryAllPrices(conn, from(), to(), ret_vals$current_positions)
      ret_vals$monthly_investments <- QueryMonthlyInvestments(conn, from(), to())
      ret_vals$weighted_returns <- ComputeWeightedReturns(
        ret_vals$transactions_to, ret_vals$current_positions, 
        ret_vals$all_prices, from(), to()
      )
      ret_vals$asset_performance <- ComputeAssetPerformance(ret_vals$weighted_returns)
      ret_vals$portfolio_returns <- ComputePortfolioReturns(ret_vals$weighted_returns)
      ret_vals$total_profits <- ComputeTotalProfit(
        ret_vals$all_prices, ret_vals$transactions_to,
        ret_vals$current_positions, from(), to(), currency()
      )
      ret_vals$sharpe_ratio <- ComputeSharpeRatio(ret_vals$portfolio_returns, rfr())
    })
    
    ## Date To
    observeEvent(to(), {
      
      # Transactions and positions
      ret_vals$current_positions <- QueryCurrentPositions(conn, to())
      ret_vals$current_positions <- QueryCurrentPositionValues(conn, ret_vals$current_positions, to())
      ret_vals$transactions_to <- QueryTransactionsTo(conn, to())
      
      # Price data
      ret_vals$all_prices <- QueryAllPrices(conn, from(), to(), ret_vals$current_positions)
      ret_vals$monthly_investments <- QueryMonthlyInvestments(conn, from(), to())
      ret_vals$weighted_returns <- ComputeWeightedReturns(
        ret_vals$transactions_to, ret_vals$current_positions, 
        ret_vals$all_prices, from(), to()
      )
      ret_vals$asset_performance <- ComputeAssetPerformance(ret_vals$weighted_returns)
      ret_vals$portfolio_returns <- ComputePortfolioReturns(ret_vals$weighted_returns)
      ret_vals$total_profits <- ComputeTotalProfit(
        ret_vals$all_prices, ret_vals$transactions_to,
        ret_vals$current_positions, from(), to(), currency()
      )
      ret_vals$sharpe_ratio <- ComputeSharpeRatio(ret_vals$portfolio_returns, rfr())
    })
    
    ## Risk free rate
    observeEvent(rfr(), {
      ret_vals$sharpe_ratio <- ComputeSharpeRatio(ret_vals$portfolio_returns, rfr())
    })
    
    ## Currency
    observeEvent(currency(), {
      
      # Storing main currency
      res <- dbSendQuery(
        conn,
        "
        UPDATE settings
        SET Currency = ?;
        ",
        params=currency()
      )
      dbClearResult(res)
      
      # Transactions and positions
      ret_vals$current_positions <- QueryCurrentPositions(conn, to())
      ret_vals$current_positions <- QueryCurrentPositionValues(conn, ret_vals$current_positions, to())
      ret_vals$transactions_from_to <- QueryTransactionsFromTo(conn, from(), to())
      ret_vals$transactions_to <- QueryTransactionsTo(conn, to())
      
      # Price data
      ret_vals$all_prices <- QueryAllPrices(conn, from(), to(), ret_vals$current_positions)
      ret_vals$monthly_investments <- QueryMonthlyInvestments(conn, from(), to())
      ret_vals$weighted_returns <- ComputeWeightedReturns(
        ret_vals$transactions_to, ret_vals$current_positions, 
        ret_vals$all_prices, from(), to()
      )
      ret_vals$asset_performance <- ComputeAssetPerformance(ret_vals$weighted_returns)
      ret_vals$portfolio_returns <- ComputePortfolioReturns(ret_vals$weighted_returns)
      ret_vals$total_profits <- ComputeTotalProfit(
        ret_vals$all_prices, ret_vals$transactions_to, 
        ret_vals$current_positions, from(), to(), currency()
      )
      ret_vals$sharpe_ratio <- ComputeSharpeRatio(ret_vals$portfolio_returns, rfr())
    })
    
    # Tracking
    observeEvent(tracking(), {
      
      # Transactions and positions
      ret_vals$current_positions <- QueryCurrentPositions(conn, to())
      UpdateXRates(conn)
      UpdatePrices(conn, ret_vals$current_positions)
      ret_vals$current_positions <- QueryCurrentPositionValues(conn, ret_vals$current_positions, to())
      ret_vals$transactions_from_to <- QueryTransactionsFromTo(conn, from(), to())
      ret_vals$transactions_to <- QueryTransactionsTo(conn, to())
      
      # Price data
      ret_vals$all_prices <- QueryAllPrices(conn, from(), to(), ret_vals$current_positions)
      ret_vals$monthly_investments <- QueryMonthlyInvestments(conn, from(), to())
      ret_vals$weighted_returns <- ComputeWeightedReturns(
        ret_vals$transactions_to, ret_vals$current_positions, 
        ret_vals$all_prices, from(), to()
      )
      ret_vals$asset_performance <- ComputeAssetPerformance(ret_vals$weighted_returns)
      ret_vals$portfolio_returns <- ComputePortfolioReturns(ret_vals$weighted_returns)
      ret_vals$total_profits <- ComputeTotalProfit(
        ret_vals$all_prices, ret_vals$transactions_to,
        ret_vals$current_positions, from(), to(), currency()
      )
      ret_vals$sharpe_ratio <- ComputeSharpeRatio(ret_vals$portfolio_returns, rfr())
    })
    
    return(ret_vals)
  })
}