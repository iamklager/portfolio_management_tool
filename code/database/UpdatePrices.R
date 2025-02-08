#### UpdatePrices
# Queries the newest (and only relevant) prices from Yahoo-Finance, computes returns and stores them in the database for all assets in the database.

UpdatePrices <- function(conn, positions) {
  if (nrow(positions) == 0) {
    return(0)
  }
  
  for (i in 1:nrow(positions)) {
    YahooAsset2DB(
      conn, 
      positions$TickerSymbol[i], positions$SourceCurrency[i],
      positions$Quantity[i], positions$LastTransaction[i]
    )
  }
  
  return(0)
}

