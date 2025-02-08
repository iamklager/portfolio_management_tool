#### NamedTickers
# Returns a unique vector of named ticker symbols from a data frame.


NamedTickers <- function(df) {
  df <- df[df$TickerSymbol %in% unique(df$TickerSymbol), ]
  df <- df[order(df$DisplayName), ]
  tickers <- df$TickerSymbol
  names(tickers) <- df$DisplayName
  
  return(tickers)
}