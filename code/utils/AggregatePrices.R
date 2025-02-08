#### AggregateReturns
# Aggregates the returns of each asset by transaction.


AggregatePrices <- function(transactions_to, prices, from, to) {
  
  if ((nrow(transactions_to) == 0) || (nrow(prices) == 0)) {
    return(NULL)
  }
  
  prices <- prices[prices$Date >= format(as.Date(from)-5, "%Y-%m-%d"), ]
  prices <- prices[prices$Date <= to, ]
  
  if (nrow(prices) == 0) {
    return(NULL)
  }
  
  all_dates <- sort(unique(prices$Date)) # Not sure about this but I think it's necessary.
  
  aggr_prices <- lapply(1:nrow(transactions_to), function(i) {
    # Prices of this transaction within the selected time frame
    p <- prices[
      prices$TickerSymbol == transactions_to$TickerSymbol[i], 
      c("Date", "Adjusted", "Return")
    ]
    
    if (nrow(p) == 0) {
      return(NULL)
    }
    
    # Transaction info
    trans_date <- transactions_to$Date[i]
    trans_sign <- ifelse(transactions_to$TransactionType[i] == "Buy", 1, -1)
    trans_val  <- transactions_to$PriceTotal[i]
    trans_quant <- transactions_to$Quantity[i]
    
    # Adjusting returns from buying or selling
    p$InvestedSum <- 0
    date_seq <- seq.Date(as.Date(from), as.Date(max(p$Date)), by="day")
    if (trans_date %in% format(date_seq, "%Y-%m-%d")) {
      p <- p[p$Date >= trans_date, ]
      p[1, "Return"] <- p[which(p$Date >= trans_date)[1], "Adjusted"] - (trans_val/trans_quant)
    } else {
      p <- p[(which(p$Date >= from)[1]-1):nrow(p), ]
      p[1, "Return"] <- 0
    }
    p[1, "InvestedSum"] <- trans_sign * trans_val
    p$TotalReturn <- trans_sign * p$Return * trans_quant
    
    # Extending to all dates
    ad <- data.frame(
      Date = all_dates[(all_dates >= p$Date[1]) & (all_dates <= max(p$Date))]
    )
    p <- merge(x=p[,c("Date", "TotalReturn", "InvestedSum")], y=ad, by="Date", all=T)
    #p <- ForwardFillAdjusted(p)
    
    # Columns for aggregation
    p$DisplayName <- transactions_to$DisplayName[i]
    p$Type <- transactions_to$Type[i]
    p$Group <- transactions_to$Group[i]
    
    # 0 Positions
    pos_ind <- which(positions$DisplayName == p$DisplayName[1])
    if (positions$Quantity[pos_ind] == 0) {
      p <- p[p$Date <= positions$LastTransaction[pos_ind], ]
      p[nrow(p), "InvestedSum"] <- 0
    }
    
    return(p)
  })
  aggr_prices <- do.call("rbind", aggr_prices)
  aggr_prices[is.na(aggr_prices)] <- 0 # Not sure about this but I think it's necessary.
  
  # Aggregating to daily returns by position
  aggr_prices <- aggregate.data.frame(
    aggr_prices[, c("TotalReturn", "InvestedSum")],
    list(aggr_prices$Date, aggr_prices$DisplayName, aggr_prices$Type, aggr_prices$Group), 
    sum
  )
  colnames(aggr_prices)[1:4] <- c("Date", "DisplayName", "Type", "Group")
  
  aggr_prices <- split(aggr_prices, aggr_prices$DisplayName)
  aggr_prices <- lapply(aggr_prices, function(x) {
    x$InvestedSum <- cumsum(x$InvestedSum)
    x$CumulativeGain <- cumsum(x$TotalReturn) / x$InvestedSum
    
    return(x)
  })
  aggr_prices <- do.call("rbind", aggr_prices)
  
  aggr_prices <- aggr_prices[aggr_prices$Date >= format(as.Date(from)-1, "%Y-%m-%d"), ]
  
  row.names(aggr_prices) <- NULL
  aggr_prices$Date <- as.Date(aggr_prices$Date)
  
  return(aggr_prices)
}

