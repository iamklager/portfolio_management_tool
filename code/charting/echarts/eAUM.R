#### eAUM
# Plots the assets under management over time.


eAUM <- function(df, currency="USD") {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  }
  if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  }
  
  df |>
    e_charts(x=Date) |>
    e_line(serie=Adjusted, name="Total Value", symbol="none", color="#aaaaaa", clip=F, connectNulls=T) |>
    e_tooltip(trigger="axis") |>
    e_y_axis(
      type="value",
      formatter = e_axis_formatter(
        style="currency",
        currency=currency
      ),
      min="dataMin"
    ) |>
    e_legend(show=F) |>
    e_theme("pmtTheme")
}