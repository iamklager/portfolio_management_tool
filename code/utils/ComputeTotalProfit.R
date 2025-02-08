#### ComputeTotalProfit
#

ComputeTotalProfit <- function(prices, transactions_to, positions, from, to, currency="USD") {
  
  if ((nrow(transactions_to) == 0) || (nrow(prices) == 0)) {
    return(NULL)
  }
  
  positions <- positions[!((positions$Quantity == 0) & (positions$LastTransaction <= from)), ]
  positions <- positions[positions$LastTransaction <= to, ]
  if(nrow(positions) == 0) {
    return(NULL)
  }
  
  end_capital <- start_capital <- 0
  
  for (i in 1:nrow(transactions_to)) {
    
    if (!(transactions_to$DisplayName[i] %in% positions$DisplayName)) {
      next
    }
    
    t_sign <- ifelse(transactions_to$TransactionType[i] == "Buy", 1, -1)
    p <- prices[prices$TickerSymbol == transactions_to$TickerSymbol[i], ]
    p <- p[p$Date <= to, ]
    
    if (transactions_to$Date[i] >= from) {
      start_capital <- start_capital + t_sign * transactions_to$PriceTotal[i]
    } else {
      first_ind <- which(p$Date >= from)[1]-1
      start_capital <- start_capital + t_sign * transactions_to$Quantity[i] * p[first_ind, "Adjusted"]
    }
    
    end_capital <- end_capital + t_sign * transactions_to$Quantity[i] * p[nrow(p), "Adjusted"]
  }
  
  profit_tot <- end_capital - start_capital
  profit_tot <- paste0(round(profit_tot, 2), " ", currency)
  profit_perc <- 100 * (end_capital / start_capital - 1)
  profit_perc <- paste0(round(profit_perc, 2), " %")

  text_color <- ifelse(end_capital >= start_capital, "#77B300", "#CC0000")
  
  list(
    total = profit_tot,
    percent = profit_perc,
    color = text_color
  )
}
