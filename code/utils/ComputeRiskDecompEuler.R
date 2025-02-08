#### ComputeRiskDecompEuler
# Computes the standard deviation decomposition following Euler.

ComputeRiskDecompEuler <- function(positions, returns) {
  
  if (is.null(returns)) {
    return(NULL)
  }
  
  # Euler's risk decomposition
  positions <- positions[positions$Quantity != 0, ]
  positions <- positions[order(positions$DisplayName), ]
  returns <- returns[, positions$TickerSymbol]
  
  omega <- positions$CurrentValue
  vc <- cov(returns)
  sigma_p <- sqrt(omega %*% vc %*% omega)[1, 1]
  
  MCR <- (vc %*% omega) / sigma_p
  CR  <- omega * MCR
  
  PCR <- data.frame(
    DisplayName = positions$DisplayName,
    Type = positions$Type,
    Group = positions$Group,
    PCR = CR / sigma_p
  )
  
  res <- list(
    sigma_p = sigma_p,
    PCR = PCR
  )
  
  return(res)
}