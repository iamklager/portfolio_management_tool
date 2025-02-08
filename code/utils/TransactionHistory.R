#### TransactionHistory
#


TransactionHistory <- function(from, prices, transactions, ticker) {
  
  if (is.null(ticker)) {
    return(NULL)
  }
  
  prices <- prices[prices$Date >= from & (prices$TickerSymbol == ticker), c("Date", "Adjusted")]
  
  transactions$Buy <- ifelse(transactions$TransactionType == "Buy", transactions$PriceTotal / transactions$Quantity, NA)
  transactions$Sell <- ifelse(transactions$TransactionType == "Sell", transactions$PriceTotal / transactions$Quantity, NA)
  transactions <- transactions[
    (transactions$Date >= from) & (transactions$TickerSymbol == ticker), 
    c("Date", "Quantity", "PriceTotal", "Buy", "Sell")
  ]
  
  history <- merge(prices, transactions, by="Date", all.x=T, all.y=T)
  
  history$Date <- as.Date(history$Date)
  
  return(history)
}

