#### ecCorrelationMatrix
# Returns a correlation matrix plot.

hcCorrelationMatrix <- function(cor_mat) {
  
  # No data check
  if (is.null(cor_mat)) {
    return(validate(need(F, "No or not enought data available.")))
  } else if (nrow(cor_mat) == 0) { showNotification("Correlation matrix: 0 rows", type="warning")}
  
  # cor_mat[lower.tri(cor_mat, F)] <- NA
  hc <- cor_mat |>
    hchart() |>
    hc_plotOptions(
      heatmap = list(
        dataLabels = list(enabled = TRUE, format = "{point.value:.2f}"),
        tooltip = list(pointFormat = "{point.value:.2f}")
      )
    ) |>
    hc_yAxis(reversed = T)
  hc$x$hc_opts$colorAxis$stops <- NULL
  hc |>
    hc_colorAxis(
      min = -1, max = 1,
      stops = color_stops(
        n = 10, 
        colors = c("#27727b", "#ffffff", "#c1232b")
      ),
      reversed = F
    ) |>
    hc_legend(
      layout = "vertical",
      align = "right",
      verticalAlign = "middle"
    ) |>
    hc_add_theme(hc_theme_pmt)
}