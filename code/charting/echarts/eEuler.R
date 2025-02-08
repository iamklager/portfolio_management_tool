#### eEuler
# 


eEuler <- function(l) {
  
  # No data check
  if (is.null(l)) {
    return(validate(need(F, "No or not enought data available.")))
  }
  
  df <- l$PCR
  sigma <- round(l$sigma_p, 3)
  
  df |>
    e_charts(DisplayName) |>
    e_pie(
      serie = PCR,
      name = "Percentage risk contribution",
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
      text = paste0("Portfolio:\n", sigma) , 
      top = "center", left = "center", 
      textStyle = list(
        fontSize = 20,
        textBorderColor = "#000000",
        textBorderWidth = 2
      )
    ) |> 
    e_theme("pmtTheme")
}