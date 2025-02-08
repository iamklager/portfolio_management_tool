#### ecAssetAllocation
# Returns a donut plot showing asset allocation.

ecAssetAllocation <- function(df, value_name, currency) {
  
  # No data check
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  }
  
  df <- df[df$Quantity != 0, ]
  
  col_name <- paste0(value_name, "Value")
  
  pos_sum <- round(sum(df[, col_name]), 2)
  
  df |>
    e_charts(DisplayName) |>
    e_pie_(
      serie = col_name,
      name = paste0(value_name, " Value"),
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
      text = paste0("Total:\n", pos_sum, " ", currency) , 
      top = "center", left = "center", 
      textStyle = list(
        fontSize = 30,
        textBorderColor = "#000000",
        textBorderWidth = 2
      )
    ) |> 
    e_theme("pmtTheme")
}

