#### hcAssetAllocation
#


hcAssetAllocation <- function(df, value_name, currency) {
  if (is.null(df)) {
    return(validate(need(F, "No data available.")))
  } else if (nrow(df) == 0) {
    return(validate(need(F, "No data available.")))
  }
  
  df <- df[df$Quantity != 0, ]
  col_name <- paste0(value_name, "Value")
  colnames(df)[colnames(df) == col_name] <- "Share"
  pos_sum <- sum(df$Share)
  df$Percentage <- 100 * df$Share / pos_sum
  
  df |>
    hchart(
      type="pie",
      hcaes(x = DisplayName, y=Percentage, color=Group),
      name = paste0(col_name, " Value")
    ) |>
    hc_plotOptions(
      pie = list(
        borderColor = "#0d1821",
        dataLabels = list(enabled = F),
        showInLegend = T,
        innerSize = "65%",
        center = list("50%", "50%"),
        tooltip = list(
          pointFormat = paste0(
            "{point.Type}/{point.Group}: {point.Share:.2f} ", 
            currency, 
            " / {point.Percentage:.2f} %"
          )
        )
      )
    ) |>
    hc_legend(
      align = "right",
      verticalAlign = "middle",
      layout = "vertical",
      width=220
    ) |> 
    hc_subtitle(
      text = paste0("
        <span style='font-size: 20px'>
        <b> <br>Total:</b>
        </span>
        <br><br>
        <span style='font-size: 16px'>", 
        round(pos_sum, 2), " ", currency,
        "</span>
      "), 
      x = -120, #y = 150
      verticalAlign = "middle"
    ) |>
    hc_add_theme(hc_theme_pmt)
}
