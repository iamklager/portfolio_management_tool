#### ComputeCorrelationMatrix
# Computes the correlation matrix from a return matrix and the time frame. Allows 3 correlation methods ('pearson', 'kendall' and 'spearman').

ComputeCorrelationMatrix <- function(positions, returns, method) {
  
  if (is.null(returns)) {
    return(NULL)
  }
  
  cor_mat <- cor(returns, method=method)
  for (i in 1:nrow(cor_mat)) {
    colnames(cor_mat)[i] <- rownames(cor_mat)[i] <- positions[positions$TickerSymbol == rownames(cor_mat)[i], "DisplayName"]
  }
  
  return(cor_mat)
}