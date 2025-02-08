#### PreFilterRiskReturns
# Filters the risk returns before the correlation matrix and risk decompositions are being calculated.


PreFilterRiskReturns <- function(returns, from, to, time_frame) {
  
  if (nrow(returns) < 30 || is.null(returns)) {
    return(NULL)
  }
  
  # Super unsexy
  if (time_frame == "Selection") {
    print("Selection")
    from=from
  } else if (time_frame == "1 Year") {
    from <- paste0(
      as.numeric(substr(to, 1, 4)) - 1,
      substr(to, 5, 10)
    )
  } else if (time_frame == "3 Years") {
    from <- paste0(
      as.numeric(substr(to, 1, 4)) - 3,
      substr(to, 5, 10)
    )
  } else if (time_frame == "5 Years") {
    from <- paste0(
      as.numeric(substr(to, 1, 4)) - 5,
      substr(to, 5, 10)
    )
  } else if (time_frame == "Entire History") {
    from <- "1900-01-01"
  }
  
  returns <- returns[(returns$Date >= from) & (returns$Date <= to), -1]
  
  if (nrow(returns) < 30) {
    return(NULL)
  }
  
  return(returns)
}