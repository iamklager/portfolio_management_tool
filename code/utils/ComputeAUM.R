#### ComputeAUM
# Computes the portfolio's assets under management total value over time.

ComputeAUM <- function(prices, transactions_to, from, to) {
  if (nrow(transactions_to) == 0 || nrow(prices) == 0) {
    return(NULL)
  }
  
  aum <- lapply(1:nrow(transactions_to), function(i) {
    p <- prices[prices$TickerSymbol == transactions_to$TickerSymbol[i], c("Date", "Adjusted")]
    
    p <- p[p$Date >= format(as.Date(from)-5, "%Y-%m-%d"), ]
    if (nrow(p) == 0) {
      return(NULL)
    }
    all_dates <- data.frame(
      Date = format(seq.Date(as.Date(p$Date[1]), as.Date(to), "day"), "%Y-%m-%d")
    )
    p <- merge(x=p, y=all_dates, by="Date", all=T)
    p <- ForwardFillAdjusted(p)
    
    p <- p[p$Date >= from, ]
    
    if (transactions_to$Date[i] >= p$Date[1]) {
      p <- p[p$Date >= transactions_to$Date[i], ]
    }
    
    p$Adjusted <- p$Adjusted * transactions_to$Quantity[i] * ifelse(transactions_to$TransactionType[i] == "Buy", 1, -1)
    
    return(p)
  })
  aum <- do.call("rbind", aum)
  
  aum <- aggregate.data.frame(aum[, "Adjusted"], list(aum$Date), sum)
  colnames(aum) <- c("Date", "AssetsUnderManagament")
  
  aum$Date <- as.Date(aum$Date)
  row.names(aum) <- NULL
  
  return(aum)
}


