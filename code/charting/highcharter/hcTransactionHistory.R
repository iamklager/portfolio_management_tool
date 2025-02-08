#### hcTransactionHistory
#


hcTransactionHistory <- function(df, currency="USD") {
  
  # No data check
  if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  } else if (is.null(df)) { showNotification("Transaction history NULL", type="warning")}
  
  highchart() |>
    hc_add_series(
      data = df, type = "line", hcaes(x = Date, y = Adjusted), 
      name = "Price", color = "#aaaaaa", showInLegend = F
    ) |> 
    hc_add_series(
      data = df, type = "scatter", hcaes(x = Date, y = Buy),
      name = "Buy", color = "#77B300", showInLegend = T
    ) |> 
    hc_add_series(
      data = df, type = "scatter", hcaes(x = Date, y = Sell),
      name = "Sell", color = "#CC0000", showInLegend = T
    ) |>
    hc_plotOptions(
      line = list(
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = paste0(" ", currency)
        )
      ),
      scatter = list(
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = paste0(" ", currency)
        )
      )
    )  |>
    hc_xAxis(type = "datetime", title = list(text = "")) |>
    hc_yAxis(
      labels = list(format = paste0("{value} ", currency)),
      title = list(text = "")
    ) |>
    hc_add_theme(hc_theme_pmt)
}



