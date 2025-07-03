#### ComputeWeightedReturns
#


ComputeWeightedReturns <- function(transactions_to, positions, prices, from, to) {
  
  if ((nrow(transactions_to) == 0) || (nrow(prices) == 0)) {
    return(NULL)
  }
  
  weighted_returns <- list()
  
  for (i in 1:nrow(transactions_to)) {
    
    pos <- positions[positions$TickerSymbol == transactions_to$TickerSymbol[i], ]
    
    # Case: Never held a position in the time frame
    if ((pos$Quantity == 0) && (pos$LastTransaction < from)) {
      weighted_returns[[i]] <- NULL
      next
    }
    
    # All prices of the asset
    p <- prices[prices$TickerSymbol == transactions_to$TickerSymbol[i], c("Date", "Adjusted")]
    
    # Transaction variables
    t_date  <- transactions_to$Date[i]
    t_quant <- transactions_to$Quantity[i]
    t_ptot  <- transactions_to$PriceTotal[i]
    t_price <- t_ptot / t_quant
    t_sign  <- ifelse(transactions_to$TransactionType[i] == "Buy", 1, -1)
    
    # This is kinda dumb but necessary if Yahoo Finance data runs out while you still hold the asset???
    # Random crazy returns should be a result of tickers changing?
    if (max(p$Date) < t_date) {
      p_temp <- data.frame(
        Date = format(seq.Date(as.Date(max(p$Date)) + 1, Sys.Date()), "%Y-%m-%d"),
        Adjusted = p[p$Date == max(p$Date), "Adjusted"]
      )
      p <- rbind(p, p_temp)
    }
    
    # Case: Transaction date is in the time frame
    if (t_date >= from) {
      p <- p[p$Date >= t_date, ]
      p$PriceRel <- p$Adjusted / t_price
      p$PriceRel[1] <- 1
      
    # Case: Transaction date is not in the time frame
    } else { # I can definitely write this less ugly
      ind_from <- which(p$Date >= from)[1]
      if (ind_from != 1) {
        prev_date <- p$Date[ind_from -1]
        if (t_date > prev_date) {
          p$PriceRel <- p$Adjusted / t_price
          p <- p[p$Date >= from, ]
        } else {
          p <- p[p$Date >= from, ]
          p$PriceRel <- p$Adjusted / p$Adjusted[1]
        }
      } else {
        p <- p[p$Date >= from, ]
        p$PriceRel <- p$Adjusted / p$Adjusted[1]
      }
    }
    
    # Total returns
    p$Quantity <- t_sign * t_quant
    if (t_sign == -1) {
      p$Quantity[1] <- 0
    }
    p$Adjusted <- p$Adjusted * p$Quantity
    p$PriceRel <- p$PriceRel * p$Quantity
    
    # Forward filling missing days
    p$Date <- as.Date(p$Date)
    all_dates <- data.frame(
      Date = seq.Date(
        from = p$Date[1], 
        to = as.Date(ifelse(pos$Quantity == 0, pos$LastTransaction, to)), 
        by="days"
      )
    )
    p <- merge(x=p, y=all_dates, by="Date", all=T)
    ind_na <- setdiff(which(is.na(p$Adjusted)), 1)
    if (length(ind_na) != 0) {
      for (j in ind_na) {
        p$Adjusted[j] <- p$Adjusted[j-1]
        p$PriceRel[j] <- p$PriceRel[j-1]
        p$Quantity[j] <- p$Quantity[j-1]
      }
    }
    
    # Some fuckery to avoid spikes in the AUM due to missing days at the beginning of the time frame
    # min_date <- min(transactions_to[transactions_to$DisplayName == transactions_to$DisplayName[i], "Date"])
    if ((from != p$Date[1]) && (t_date < from)) {
      p2 <- prices[prices$TickerSymbol == transactions_to$TickerSymbol[i], c("Date", "Adjusted")]
      p2 <- p2[p2$Date == p2$Date[(which(p2$Date >= from))[1]-1], ]
      first_dates <- data.frame(
        Date = format(seq.Date(
          from = as.Date(p2$Date[1]),
          to = as.Date(from),
          by = "day"
        ), "%Y-%m-%d")
      )
      p2 <- merge(x=p2, y=first_dates, by="Date", all=T)
      p2$Date <- as.Date(p2$Date)
      p2$Adjusted <- p2[!is.na(p2$Adjusted), "Adjusted"][1] * p$Quantity[1]
      p2 <- p2[p2$Date >= from, ]
      p2$Quantity <- p$Quantity[1]
      p2$PriceRel <- p$Quantity[1]
      p <- rbind(p2, p)
    }
    
    # Appending to list
    p$DisplayName <- transactions_to$DisplayName[i]
    p$Type        <- transactions_to$Type[i]
    p$Group       <- transactions_to$Group[i]
    weighted_returns[[i]] <- p
  }
  weighted_returns <- do.call("rbind", weighted_returns)
  
  if (is.null(weighted_returns) || nrow(weighted_returns) == 0) {
    return(NULL)
  }
  
  # Aggregating by date and asset
  weighted_returns <- aggregate(
    x = cbind(Adjusted, PriceRel, Quantity) ~ Date + DisplayName + Type + Group, 
    data = weighted_returns, 
    FUN = sum
  )
  weighted_returns$PriceRel <- (weighted_returns$PriceRel / weighted_returns$Quantity) - 1
  
  weighted_returns$Date <- as.Date(weighted_returns$Date)
  weighted_returns <- weighted_returns[weighted_returns$Date != Sys.Date(), ] # I could probably just not forward fill it but yeah... Here we are
  
  return(weighted_returns)
}

