#### AddTransactionsFromFile
#


AddTransactionsFromFile <- function(conn, df) {
  failed_transactions <- c()
  for (i in 1:nrow(df)) {
    crrnt_trns <- AddTransaction(
      conn, df$Date[i], df$DisplayName[i], df$Quantity[i], df$PriceTotal[i], df$TickerSymbol[i],
      df$Type[i], df$Group[i], df$TransactionType[i], df$TransactionCurrency[i], df$SourceCurrency[i]
    )
    if (crrnt_trns != 0) {
      failed_transactions <- c(failed_transactions, crrnt_trns)
    }
  }
  return(failed_transactions)
}



