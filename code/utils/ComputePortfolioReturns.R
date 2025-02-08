#### ComputePortfolioReturns
#


ComputePortfolioReturns <- function(weighted_returns) {
  if (is.null(weighted_returns)) {
    return(NULL)
  }
  
  weighted_returns$PriceRel <- weighted_returns$PriceRel * weighted_returns$Adjusted
  port_returns <- aggregate(
    x = cbind(PriceRel, Adjusted) ~ Date, 
    data = weighted_returns,
    FUN = sum
  )
  port_returns$ReturnRelCum <- port_returns$PriceRel / port_returns$Adjusted
  
  port_returns$Date <- as.Date(port_returns$Date)
  port_returns <- port_returns[, c("Date", "ReturnRelCum", "Adjusted")]
  
  return(port_returns)
}

