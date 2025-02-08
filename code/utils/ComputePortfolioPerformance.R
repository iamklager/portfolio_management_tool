#### ComputePortfolioPerformance
# Computes the portfolio' development (i.e., percentage performance over time).


ComputePortfolioPerformance <- function(aggr_prices) {
  
  if (is.null(aggr_prices) || nrow(aggr_prices) == 0) {
    return(NULL)
  }
  
  port_perf <- aggregate.data.frame(
    x   = aggr_prices[, c("TotalReturn", "InvestedSum")],
    by  = list(aggr_prices$Date),
    FUN = sum
  )
  colnames(port_perf)[1] <- "Date"
  port_perf$Performance <- cumsum(port_perf$TotalReturn) / port_perf$InvestedSum
  
  port_perf <- port_perf[, c("Date", "Performance")]
  port_perf$Date <- as.Date(port_perf$Date)
  
  return(port_perf)
}

