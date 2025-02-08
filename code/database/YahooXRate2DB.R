#### YahooXRate2DB
# Queries xrates from Yahoo-Finance and writes them to the database. Missing adjusted closing prices are being filled with the previous day's value.

YahooXRate2DB <- function(conn, currency) {
  
  if (currency == "USD") {
    return(0)
  }
  
  if (!curl::has_internet()) {
    return(1)
  }
  
  # We always query the USD/Currency ratio
  ticker <- paste0(currency, "=X") 
  last_date <- dbGetQuery(
    conn,
    "
    SELECT MAX(Date)
    FROM xrates
    WHERE Currency = ?;
    ",
    params=currency
  )[1, 1]
  
  # A few conditions later..
  if (is.na(last_date)) { # Case: Currency has never been queried from Yahoo.
    prices <- tryCatch(
      {
        quantmod::getSymbols(
          Symbols=ticker, env=NULL,
          verbose=F, warnings=F,
          to=format(Sys.Date()-1, "%Y-%m-%d")
        )
      }, error=function(cond) {
        shiny::showNotification(
          paste0("Cannot query '", ticker, "'.\nPlease make sure you entered a proper Yahoo-Finance ticker!"),
          type="error"
        )
        NULL
      }
    )
    if (is.null(prices)) {
      return(0)
    }
    prices <- YahooXTS2DF(prices)
    date_range <- data.frame(
      Date=format(
        seq.Date(
          from=as.Date(prices$Date[1]), 
          to=Sys.Date()-1, 
          by="days"
        ),
        "%Y-%m-%d"
      )
    )
    prices <- merge(x=prices, y=date_range, by="Date", all=T)
    prices <- ForwardFillAdjusted(prices)
    
  } else if (last_date == format(Sys.Date()-1)) { # Case: Xrates are already updated (i.e., yesterday is the most recent entry)
    return(0)
    
  } else { # Case: We have xrates but not the most recent one.
    last_price <- dbGetQuery(
      conn,
      "
      SELECT Date, Open, High, Low, Close, Volume, Adjusted
      FROM xrates
      WHERE Currency = ?
        AND Date = ?;
      ",
      params=c(currency, last_date)
    )
    date_range <- data.frame(
      Date=format(
        seq.Date(
          from=as.Date(last_date), 
          to=Sys.Date()-1, 
          by="days"
        ),
        "%Y-%m-%d"
      )
    )
    prices <- tryCatch(
      {
        quantmod::getSymbols(
          Symbols=ticker, env=NULL,
          verbose=F, warnings=F,
          from=format(as.Date(last_date)+1, "%Y-%m-%d"),
          to=format(Sys.Date()-1, "%Y-%m-%d")
        )
      }, error=function(cond) {
        NULL
      }
    )
    if (!is.null(prices)) {
      prices <- YahooXTS2DF(prices)
    }
    prices <- rbind(last_price, prices)
    prices <- merge(x=prices, y=date_range, by="Date", all=T)
    prices <- ForwardFillAdjusted(prices)
    prices <- prices[prices$Date != last_date, ]
  }
  
  # Storing prices in the database
  prices$Currency <- currency
  dbWriteTable(conn, "xrates", prices, append=T)
  
  # Storing new currency symbols in the database.
  res <- dbSendQuery(
    conn, 
    "
    INSERT OR IGNORE INTO currencies(Currency)
    VALUES(?);
    ",
    params=currency
  )
  dbClearResult(res)
  
  return(0)
}