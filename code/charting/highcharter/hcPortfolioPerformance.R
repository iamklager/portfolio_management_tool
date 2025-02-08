#### hcPortfolioPerformance
#


hcPortfolioPerformance <- function(df) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Portfolio performance: 0 rows", type="warning")}
  
  df$ReturnRelCum <- 100 * df$ReturnRelCum
  
  df |>
    hchart(
      type = "line",
      hcaes(x=Date, y=ReturnRelCum),
      name = "Portfolio Performance", color = "#aaaaaa"
    ) |>
    hc_plotOptions(
      line = list(
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = " %"
        )
      )
    ) |>
    hc_xAxis(title = list(text = "")) |>
    hc_yAxis(
      labels = list(format = "{value} %"),
      title = list(text = "")
    ) |>
    hc_add_theme(hc_theme_pmt)
}
