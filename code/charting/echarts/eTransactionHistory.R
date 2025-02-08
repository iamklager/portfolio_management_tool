#### eTransactionHistory
#


eTransactionHistory <- function(df, currency="USD") {
  
  # No data check
  if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  } else if (is.null(df)) { showNotification("Transaction history NULL", type="warning")}
  
  df |>
    e_charts(x=Date) |>
    e_line(serie=Adjusted, name="Price", symbol="none", color="#aaaaaa", clip=F, connectNulls=T, z=2) |>
    e_scatter(serie=Buy, name="Buy", symbol="diamond", symbol_size=15, color="#7eb00a", z=3) |>
    e_scatter(serie=Sell, name="Sell", symbol="diamond", symbol_size=15, color="#c1232b", z=4) |>
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



