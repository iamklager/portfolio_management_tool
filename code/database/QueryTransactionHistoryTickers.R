#### QueryTransactionHistoryTickers
# Queries display names and tickers for the transaction history.

QueryTransactionHistoryTickers <- function(conn, from, to) {
  res <- dbGetQuery(
    conn,
    "
    WITH trans_tickers AS (
      SELECT TickerSymbol, DisplayName
      FROM transactions
      WHERE Date <= ?
    ),
    trans_prices AS (
      SELECT Distinct TickerSymbol
      FROM prices
      WHERE Date > ?
    )
    SELECT t.TickerSymbol, t.DisplayName
    FROM trans_tickers t
    INNER JOIN trans_prices p
      ON p.TickerSymbol = t.TickerSymbol;
    ",
    params=c(to, from)
  )
  
  res <- NamedTickers(res)
  
  return(res)
}

