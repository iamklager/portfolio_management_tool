#### ComputeAssetPerformance
#


ComputeAssetPerformance <- function(asset_ret) {
  
  if (is.null(asset_ret) || (nrow(asset_ret) == 0)) {
    return(NULL)
  }
  
  performance <- split(asset_ret, asset_ret$DisplayName)
  performance <- lapply(performance, function(x) {
    x <- x[x$Date == max(x$Date), c("DisplayName", "Type", "Group", "PriceRel")]
    return(x)
  })
  performance <- do.call("rbind", performance)
  row.names(performance) <- NULL
  colnames(performance)[4] <- "Performance"
  
  return(performance)
}



