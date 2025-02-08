#### hcAUM
# Plots the assets under management over time.


hcAUM <- function(df, currency="USD") {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  }
  if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  }
  
  df |>
    hchart(
      type="line", 
      hcaes(x=Date, y=Adjusted), 
      name="Total Value", color="#aaaaaa"
    ) |>
    hc_plotOptions(
      line = list(
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = paste0(" ", currency)
        )
      )
    ) |>
    hc_xAxis(title = list(text = "")) |>
    hc_yAxis(
      labels = list(format = paste0("{value} ", currency)),
      title = list(text = "")
    ) |>
    hc_add_theme(hc_theme_pmt)
}
