#### eAssetDevelopment
#


eAssetDevelopment <- function(df, type) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Asset development: 0 rows", type="warning")}
  
  df[df$Type == type, ] |>
    group_by(DisplayName) |>
    e_charts(x=Date) |>
    e_line(serie=CumulativeGain, symbol="none") |>
    e_y_axis(
      min="dataMin",
      type="value",
      formatter = e_axis_formatter(
        style="percent"
      )
    ) |>
    e_tooltip(trigger="axis") |>
    e_theme("pmtTheme")
}