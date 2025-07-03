#### CheckTransactionValiditySingle
# Checks the validity of a single transaction.


CheckTransactionValiditySingle <- function(
    conn, date, display_name, quantity, price_total, ticker_symbol, 
    type, group, transaction_type, transaction_currency, source_currency
) {
  
  # Missing values check
  df[, -c(3, 4)] <- sapply(df[, -c(3, 4)], trimws)
  if (
    any(is.na(c(
      date, display_name, quantity, price_total, ticker_symbol, 
      type, group, transaction_type, transaction_currency, source_currency
    ))) || any(trimws(
      any(is.na(c(
        date, display_name, ticker_symbol, type, group, transaction_type, 
        transaction_currency, source_currency
      )))
    )) == ''
  ) {
    return("Error: There must not be any missing values!")
  }
  
  # Wrong date format check
  df$Date <- format(as.Date(date, tryFormats=c("%Y-%m-%d", "%Y/%m/%d", "%d.%m.%Y")), "%Y-%m-%d")
  if (any(date)) {
    return("Error: Date format must be one of 'yyyy-mm-dd', 'yyyy/mm/dd' or 'dd.mm.yyyy'!")
  }
  
  # This is so fucking fishy.
  # Quantity is numeric check
  quantity <- gsub(',', '', quantity)
  quantity_is_numeric <- tryCatch(
    {
      !is.na(as.numeric(quantity))
    }, 
    error = function(e) {
      T
    }
  )
  if (!quantity_is_numeric) {
    return("Error: Quantity must be a number (English format)!")
  }
  quantity <- as.numeric(quantity)
  
  # Quantity is not 0 check
  if (quantity == 0) {
    return("Error: Quantity must not be 0!")
  }
  
  # PriceTotal is numeric check
  price_total <- gsub(',', '', price_total)
  price_total_is_numeric <- tryCatch(
    {
      !is.na(as.numeric(price_total))
    }, 
    error = function(e) {
      T
    }
  )
  if (!price_total_is_numeric) {
    return("Error: PriceTotal must be a number (English format)!")
  }
  price_total <- as.numeric(price_total)
  
  # TransactionType check
  if (!transaction_type %in% c("Buy", "Sell")) {
    return("Error: TransactionType must be either 'Buy' or 'Sell'!")
  }
  
  # TransactionCurrency check
  if (transaction_currency != "USD") {
    if (!(transaction_currency %in% QueryCurrencySymbols(conn))) {
      symbol_exists <- tryCatch(
        {
          getSymbols(Symbols=paste0(transaction_currency, "=X"), env=NULL, warnings=F)
          TRUE
        }, error = function(e) {
          F
        }
      )
      if (!symbol_exists) {
        return("Error: TransactionCurrency does not exist on Yahoo-Finance!")
      }
    }
  }
  
  # SourceCurrency check
  if (source_currency != "USD") {
    if (!(source_currency %in% QueryCurrencySymbols(conn))) {
      symbol_exists <- tryCatch(
        {
          getSymbols(Symbols=paste0(source_currency, "=X"), env=NULL, warnings=F)
          TRUE
        }, error = function(e) {
          F
        }
      )
      if (!symbol_exists) {
        return("Error: SourceCurrency does not exist on Yahoo-Finance!")
      }
    }
  }
  
  # TickerSymbol check
  ticker_exists <- tryCatch(
    {
      getSymbols(Symbols=ticker, env=NULL, warnings=F)
      T
    },
    error = function(e) { F }
  )
  if (!ticker_exists) {
    return("Error: TickerSymbol does not exist on Yahoo-Finance!")
  }
  
  # Returning the functioning data frame
  return(0)
}