####CheckTransactionValidityMultiple
# Checks the validity of a multiple transactions (i.e., a .csv or .xlsx file).


CheckTransactionValidityMultiple <- function(conn, file_input) {
  # Empty input check
  if (length(file_input) == 0) {
    return("Error: No file selected!")
  }
  
  # Wrong fieltype check
  ext <- tools::file_ext(file_input$name)
  if (!(ext %in% c("csv", "xlsx"))) {
    return("Error: Transaction file must be a .csv or .xlsx file!")
  }
  df <- switch(
    EXPR=ext,
    csv=read.csv(file_input$datapath),
    xlsx=readxl::read_xlsx(file_input$datapath)
  )
  
  # Column check
  if (!all(colnames(df) == c(
    "Date", "DisplayName", "Quantity", "PriceTotal", "TickerSymbol", "Type",	
    "Group", "TransactionType", "TransactionCurrency", "SourceCurrency"
  ))) {
    return("Error: Column names must match input-field names!")
  }
  
  # Empty file check
  if (nrow(df) == 0) {
    return("Error: File is empty!")
  }
  
  # Missing values check
  df[, -c(3, 4)] <- sapply(df[, -c(3, 4)], trimws)
  if (any(is.na(df)) || any(df[, -c(3, 4)] == '')) {
    return("Error: There must not be any missing values!")
  }
  
  # Wrong date format check
  df$Date <- format(as.Date(df$Date, tryFormats=c("%Y-%m-%d", "%Y/%m/%d", "%d.%m.%Y")), "%Y-%m-%d")
  if (any(is.na(df$Date))) {
    return("Error: Date format must be one of 'yyyy-mm-dd', 'yyyy/mm/dd' or 'dd.mm.yyyy'!")
  }
  
  # This is so fucking fishy.
  # Quantity is numeric check
  df$Quantity <- gsub(',', '', df$Quantity)
  quantity_is_numeric <- tryCatch(
    {
      !any(is.na(as.numeric(df$Quantity)))
    }, 
    error = function(e) {
      T
    }
  )
  if (!quantity_is_numeric) {
    return("Error: Quantity must be a number (English format)!")
  }
  df$Quantity <- as.numeric(df$Quantity)
  
  # Quantity is not 0 check
  if (any(df$Quantity == 0)) {
    return("Error: Quantity must not be 0!")
  }
  
  # PriceTotal is numeric check
  df$PriceTotal <- gsub(',', '', df$PriceTotal)
  price_total_is_numeric <- tryCatch(
    {
      !any(is.na(as.numeric(df$PriceTotal)))
    }, 
    error = function(e) {
      T
    }
  )
  if (!price_total_is_numeric) {
    return("Error: PriceTotal must be a number (English format)!")
  }
  df$PriceTotal <- as.numeric(df$PriceTotal)
  
  # TransactionType check
  if (!all(df$TransactionType %in% c("Buy", "Sell"))) {
    return("Error: TransactionType must be either 'Buy' or 'Sell'!")
  }
  
  # TransactionCurrency check
  wrong_trans_curr <- c()
  for (currency in unique(df$TransactionCurrency)) {
    if (currency != "USD") {
      if (!(currency %in% QueryCurrencySymbols(conn))) {
        symbol_exists <- tryCatch(
          {
            getSymbols(Symbols=paste0(currency, "=X"), env=NULL, warnings=F)
            TRUE
          }, error = function(e) {
            F
          }
        )
        if (!symbol_exists) {
          wrong_trans_curr <- c(wrong_trans_curr, currency)
        }
      }
    }
  }
  if (length(wrong_trans_curr) != 0) {
    return(paste0(
      "Error: Some TransactionCurrency tickers do not exist on Yahoo-Finance!/n'Pease check: '", 
      paste(wrong_trans_curr, sep="", collapse="', '"), "'"
    ))
  }
  
  # SourceCurrency check
  wrong_src_curr <- c()
  for (currency in unique(df$SourceCurrency)) {
    if (currency != "USD") {
      if (!(currency %in% QueryCurrencySymbols(conn))) {
        symbol_exists <- tryCatch(
          {
            getSymbols(Symbols=paste0(currency, "=X"), env=NULL, warnings=F)
            TRUE
          }, error = function(e) {
            F
          }
        )
        if (!symbol_exists) {
          wrong_src_curr <- c(wrong_src_curr, currency)
        }
      }
    }
  }
  if (length(wrong_src_curr) != 0) {
    return(paste0(
      "Error: Some SourceCurrency tickers do not exist on Yahoo-Finance!/n'Pease check: '", 
      paste(wrong_src_curr, sep="", collapse="', '"), "'"
    ))
  }
  
  # TickerSymbol check
  wrong_tickers <- c()
  for (ticker in unique(df$TickerSymbol)) {
    ticker_exists <- tryCatch(
      {
        getSymbols(Symbols=ticker, env=NULL, warnings=F)
        T
      },
      error = function(e) { F }
    )
    if (!ticker_exists) {
      wrong_tickers <- c(wrong_tickers, ticker)
    }
  }
  if (length(wrong_tickers) != 0) {
    return(paste0(
      "Error: Some TickerSymbol tickers do not exist on Yahoo-Finance!/n'Pease check: '", 
      paste(wrong_tickers, sep="", collapse="', '"), "'"
    ))
  }
  
  # Returning the functioning data frame
  return(df)
}