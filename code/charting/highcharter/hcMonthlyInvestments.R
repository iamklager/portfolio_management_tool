#### hcMonthlyInvestments
# Bar plot of the invested amounts by month.


hcMonthlyInvestments <- function(df, currency='USD') {
  df |>
    hchart(
      type="column",
      hcaes(x=Date, y=InvestedAmount),
      name="Invested Amount", color = "#aaaaaa"
    ) |>
    hc_plotOptions(
      column = list(
        borderWidth = 0,
        grouping = FALSE,
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = paste0(" ", currency)
        )
      )
    ) |>
    hc_xAxis(
      type = "datetime", 
      title = list(text = ""),
      labels = list(
        formatter = JS(
          "
          function() {
            let label;
            return Highcharts.dateFormat('%b. %Y', this.value);
          }
          "
        )
      )
    ) |>
    hc_yAxis(
      labels = list(format = paste0("{value} ", currency)), 
      title = list(text = "")
    ) |>
    hc_add_theme(hc_theme_pmt)
}

