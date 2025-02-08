#### QueryAllPrices
# Queries prices between the minimum of the earliest common date and the first selected date, and the last selected date.
# Used to compute all of the data for the summary, performance and risk tabs.


QueryAllPrices <- function(conn, from, to, positions) {
  
  
  # Smallest date in the selection
  if (nrow(positions) == 0) {
    first_date <- from
    
  } else {
    correlation_tickers <- positions[positions$Quantity != 0, "TickerSymbol"]
    
    if (length(correlation_tickers) == 0) {
      first_date <- from
      
    } else {
      correlation_tickers <- paste(correlation_tickers, collapse="', '")
      
      common_date <- dbGetQuery(
        conn,
        paste0(
          "
          WITH MinDates AS (
            SELECT MIN(Date) AS Date
            FROM prices
            WHERE TickerSymbol IN ('", correlation_tickers, "')
            GROUP BY TickerSymbol
          )
          SELECT MAX(Date)
          FROM MinDates;
          "
        )
      )[1, 1]
      
      first_date <- min(from, common_date)
    }
    
  }
  
  # Prices
  prices <- dbGetQuery(
    conn,
    "
    SELECT *
    FROM vPrices
    WHERE Date BETWEEN ? AND ?;
    ",
    params=c(first_date, to)
  )
  
  return(prices)
}

