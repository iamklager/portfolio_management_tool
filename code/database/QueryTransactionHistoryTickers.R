#### QueryTransactionHistoryTickers
# Queries display names and tickers for the transaction history.

QueryTransactionHistoryTickers <- function(conn, from, to) {
  res <- dbGetQuery(
    conn,
    "
    WITH Tickers AS (
      SELECT DISTINCT TickerSymbol
      FROM prices
      WHERE Date BETWEEN ? AND ?
    )
    SELECT DISTINCT t.TickerSymbol, a.DisplayName
    FROM Tickers t
    INNER JOIN transactions a
      ON t.TickerSymbol = a.TickerSymbol
    ORDER BY a.DisplayName ASC;
    ", 
    params=c(from, to)
  )
  
  res <- NamedTickers(res)
  
  return(res)
}

