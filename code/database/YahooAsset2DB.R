#### YahooAsset2DB
#  Queries prices from Yahoo-Finance and writes them to the database. Missing values ARE NOT being filled.

YahooAsset2DB <- function(conn, ticker, currency, quantity, last_transaction) {
  
  if (!curl::has_internet()) {
    return(1)
  }
  
  last_date <- dbGetQuery(
    conn,
    "
    SELECT MAX(Date)
    FROM prices
    WHERE TickerSymbol = ?;
    ",
    params=ticker
  )[1, 1]
  
  today <- format(Sys.Date(), "%Y-%m-%d")
  
  date_to <- ifelse(
    quantity == 0,
    format(as.Date(last_transaction)+1, "%Y-%m-%d"),
    today
  )
  
  if (is.na(last_date)) {
    prices <- tryCatch(
      {
        quantmod::getSymbols(
          Symbols=ticker, env=NULL,
          verbose=F, warnings=F,
          to=date_to
        )
      }, error=function(cond) {
        NULL
      }
    )
    prices <- YahooXTS2DF(prices)
    prices <- prices[prices$Date != today, ] # This is retarded but Bitcoin has daily data...
    prices <- na.omit(prices) # Not sure if we want this
    prices <- ComputeReturns(prices)
    
  } else if (last_date == date_to) {
    return(0)
    
  } else {
    prices <- tryCatch(
      {
        quantmod::getSymbols(
          Symbols=ticker, env=NULL,
          verbose=F, warnings=F,
          from=format(as.Date(last_date)-5, "%Y-%m-%d"),
          to=date_to
        )
      }, error=function(cond) {
        NULL
      }
    )
    if (is.null(prices)) {
      return(1)
    }
    prices <- YahooXTS2DF(prices)
    prices <- prices[prices$Date != today, ] # This is retarded but Bitcoin has daily data...
    prices <- na.omit(prices) # Not sure if we want this
    prices <- ComputeReturns(prices)
    prices <- prices[prices$Date > last_date, ]
  }
  
  if (is.null(prices)) {
    return(1)
  }
  
  if (nrow(prices) == 0) {
    return(0)
  }
  
  # Storing prices in the database
  prices$TickerSymbol <- ticker
  prices$Currency <- currency
  dbWriteTable(conn, "prices", prices, append=T)
  
  return(0)
  
}

