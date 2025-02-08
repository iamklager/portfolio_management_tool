#### YahooXTS2DF
# Converts an xts object queried from Yahoo-Finance via quantmod to a dataframe.

YahooXTS2DF <- function(xts) {
  df <- data.frame(
    Date = format(zoo::index(xts), "%Y-%m-%d"),
    zoo::coredata(xts)
  )
  colnames(df) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Adjusted")
  
  return(df)
}

