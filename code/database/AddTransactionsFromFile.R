#### AddTransactionsFromFile
#


AddTransactionsFromFile <- function(conn, file) {
  # No file selected
  if (length(file) == 0) {
    return(1)
  }
  
  # Wrong extension
  ext <- tools::file_ext(file$name)
  if (!(ext %in% c("csv", "xlsx"))) {
    return(2)
  }
  
  # Reading the file
  df <- switch(
    EXPR=ext,
    csv=read.csv(file$datapath),
    xlsx=readxl::read_xlsx(file$datapath)
  )

  # Checking if column names match.
  if (!all(colnames(df) == c(
    "Date", "DisplayName", "Quantity", "PriceTotal", "TickerSymbol", "Type",	
    "Group", "TransactionType", "TransactionCurrency", "SourceCurrency"
  ))) {
    return(3)
  }

  # Checking if file has enough columns
  if (nrow(df) == 0) {
    return(4)
  }

  # Appending table
  df$Date <- as.Date(df$Date)
  query_state <- 0
  for (i in 1:nrow(df)) {
    query_state <- query_state + AddTransaction(
      conn, df$Date[i], df$DisplayName[i], df$Quantity[i], df$PriceTotal[i], df$TickerSymbol[i],
      df$Type[i], df$Group[i], df$TransactionType[i], df$TransactionCurrency[i], df$SourceCurrency[i]
    )
  }

  # Checking if something went wrong
  if (query_state == 0) {
    return(0)
  } else {
    return(5)
  }
}



