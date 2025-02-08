#### eCorrelationMatrix
# Returns a correlation matrix plot.

eCorrelationMatrix <- function(cor_mat) {
  
  # No data check
  if (is.null(cor_mat)) {
    return(validate(need(F, "No or not enought data available.")))
  } else if (nrow(cor_mat) == 0) { showNotification("Correlation matrix: 0 rows", type="warning")}
  
  cor_mat[lower.tri(cor_mat, F)] <- NA
  cor_mat |>
    round(3) |>
    e_charts() |>
    e_correlations(
      visual_map = FALSE
    ) |>
    e_visual_map(min=-1, max=1) |>
    e_theme("pmtTheme")
}