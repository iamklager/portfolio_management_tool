#### TransformRiskReturns
# Transforms a long-format price data frame into a wide-format log-return data frame.
# Used for both the risk decompositions, as well as the correlation matrix.


TransformRiskReturns <- function(prices, positions) {
  
  tickers <- unique(positions[positions$Quantity != 0, "TickerSymbol"])
  
  if (length(tickers) < 2) {
    return(NULL)
  }
  
  prices <- prices[prices$TickerSymbol %in% tickers, ]
  
  if (nrow(prices) == 0) {
    return(NULL)
  }
  
  prices <- na.omit(prices)
  returns <- split(prices[, c("Date", "ReturnLog")], prices$TickerSymbol)
  
  return_names <- names(returns)
  returns <- Reduce(
    f=function(x, y) {
      suppressWarnings(
        merge(x=x, y=y, by="Date", all=F)
      )
    }, 
    x=returns
  )
  colnames(returns)[-1] <- return_names
  
  return(returns)
}

