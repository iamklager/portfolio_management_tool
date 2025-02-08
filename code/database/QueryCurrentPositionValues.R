#### QueryCurrentPositionValues
# Queries the positions' values at the current date.

QueryCurrentPositionValues <- function(conn, positions, to) {
  if (nrow(positions) == 0) {
    return(positions)
  }
  
  positions$CurrentValue <- 0
  for (i in 1:nrow(positions)) {
    if (positions$Quantity[i] == 0) {
      next
    }
    current_price <- dbGetQuery(
      conn,
      "
      SELECT Adjusted
      FROM vPrices
      WHERE Date <= ?
        AND TickerSymbol = ?
      ORDER BY Date DESC
      LIMIT 1;
      ",
      params=c(to, positions$TickerSymbol[i])
    )[1, 1]
    positions$CurrentValue[i] <- current_price * positions$Quantity[i]
  }
  
  return(positions)
}
