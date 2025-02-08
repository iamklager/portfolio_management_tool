#### ComputeReturns
# Computes normal, percentage and log returns for a given price data frame.

ComputeReturns <- function(df) {
  df$Return <- c(NA, diff(df$Adjusted))
  df$ReturnPercentage <- c(NA, df$Return[-1] / df$Adjusted[-nrow(df)])
  df$ReturnLog <- c(NA, diff(log(df$Adjusted)))
  
  return(df)
}