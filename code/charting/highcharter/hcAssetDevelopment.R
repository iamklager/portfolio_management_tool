#### hcAssetDevelopment
#


hcAssetDevelopment <- function(df, type) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Asset development: 0 rows", type="warning")}
  
  df <- df[df$Type == type, ]
  df$CumulativeGain <- 100 * df$PriceRel
  
  df |>
    hchart(
      type = "line",
      hcaes(x=Date, y=CumulativeGain, group=DisplayName)
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