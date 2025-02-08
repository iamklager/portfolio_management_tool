#### eEffectiveBets
#


eEffectiveBets <- function(l) {
  
  # No data check
  if (is.null(l)) {
    return(validate(need(F, "No or not enought data available.")))
  }
  
  df <- l$eff_bets
  total <- l$total
  
  df |>
    e_charts(DisplayName) |>
    e_pie(
      serie = p,
      name = "Diversification Probability Distribution",
      radius = c("45%", "70%"),
      label = list(
        show = F
      ),
      stillShowZeroSum = F
    ) |>
    e_tooltip(
      show = T,
      valueFormatter = htmlwidgets::JS("(value) => value.toFixed(2)")
    ) |>
    e_legend(
      show = T, 
      top = "90%", left = "center",
      textStyle = list(
        textBorderColor = "#000000",
        textBorderWidth = 2
      )
    ) |>
    e_title(
      text = paste0("Total:\n", round(total, 3)) , 
      top = "center", left = "center", 
      textStyle = list(
        fontSize = 30,
        textBorderColor = "#000000",
        textBorderWidth = 2
      )
    ) |> 
    e_theme("pmtTheme")
}