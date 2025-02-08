#### hcAssetPerformance
#


hcAssetPerformance <- function(df, type = "Stock") {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Asset performance: 0 rows", type="warning")}
  
  df <- df[df$Type == type, ]
  if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  }
  
  df$Performance <- 100 * df$Performance
  
  df |>
    hchart(
      type = "column",
      hcaes(x=DisplayName, y=Performance, group=Group)
    ) |>
    hc_plotOptions(
      column = list(
        borderWidth = 0,
        grouping = FALSE,
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = " %"
        )
      )
    ) |>
    hc_xAxis(type = "category", title = list(text = "")) |>
    hc_yAxis(labels = list(format = "{value} %"), title = list(text = "")) |>
    hc_add_theme(hc_theme_pmt)
}