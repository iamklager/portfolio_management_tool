#### ComputeEffectiveBets
# Computes the effective number of independent bets.

ComputeEffectiveBets <- function(positions, returns) {
  
  if (is.null(returns)) {
    return(NULL)
  }
  
  # Effective number of independent bets
  positions <- positions[positions$Quantity != 0, ]
  positions <- positions[order(positions$DisplayName), ]
  returns <- returns[, positions$TickerSymbol]
  
  vc <- cov(returns)
  t <- uncorbets::torsion(sigma=vc, model="pca")
  
  eff_bets <- uncorbets::effective_bets(
    b = positions$CurrentValue, 
    sigma = vc, 
    t = t
  )
  
  res <- list(
    total = eff_bets$enb,
    eff_bets = data.frame(
      DisplayName = positions$DisplayName,
      Type = positions$Type,
      Group = positions$Group,
      p = eff_bets$p
    )
  )
  
  return(res)
}


