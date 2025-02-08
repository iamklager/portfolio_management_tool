#### ePortfolioPerformance
#


ePortfolioPerformance <- function(df) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Portfolio performance: 0 rows", type="warning")}
  
  df |>
    e_charts(x=Date) |>
    e_line(serie=ReturnRelCum, name="Portfolio Performance", color="#aaaaaa") |>
    e_tooltip(trigger="axis") |>
    e_legend(show=F) |>
    e_y_axis(
      min="dataMin",
      type="value",
      formatter = e_axis_formatter(
        style="percent"
      )
    ) |>
    e_theme("pmtTheme")
}
