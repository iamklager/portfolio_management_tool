#### ForwardFillAdjusted
# Forward fills missing adjusted closing prices with yesterday's adjusted close.

ForwardFillAdjusted <- function(df) {
  indices <- which(is.na(df$Adjusted))
  indices <- setdiff(indices, 1)
  
  if (length(indices) == 0) {
    return(df)
  }
  
  for (i in indices) {
    df[i, "Adjusted"] <- df[i-1, "Adjusted"]
  }
  
  return(df)
}