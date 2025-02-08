#### eAssetPerformance
#


eAssetPerformance <- function(df) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) { showNotification("Asset performance: 0 rows", type="warning")}
  
  df |>
    group_by(Group) |>
    e_charts(x=DisplayName) |>
    e_bar(serie=Performance) |>
    e_x_axis(type="category") |>
    e_y_axis(
      type="value",
      formatter = e_axis_formatter(
        style="percent"
      )
    ) |> 
    e_tooltip(trigger="item") |>
    e_legend(show=T) |>
    e_theme("pmtTheme")
}