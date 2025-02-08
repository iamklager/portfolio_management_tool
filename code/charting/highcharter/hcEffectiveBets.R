#### hcEffectiveBets
#


hcEffectiveBets <- function(l) {
  
  # No data check
  if (is.null(l)) {
    return(validate(need(F, "No or not enought data available.")))
  }
  
  df <- l$eff_bets
  df$p <- 100 * df$p
  total <- round(l$total, 3)
  
  df |>
    hchart(
      type="pie",
      hcaes(x = DisplayName, y=p, color=Group),
      name = "Diversification Probability Distribution"
    ) |>
    hc_plotOptions(
      pie = list(
        borderColor = "#0d1821",
        dataLabels = list(enabled = F),
        showInLegend = T,
        innerSize = "65%",
        center = list("50%", "50%"),
        tooltip = list(
          pointFormat = "{point.Type}/{point.Group}: {point.p:.2f} %"
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
      text = paste0(
        "<span style='font-size: 20px'>
        <b> <br>Total:</b>
        </span>
        <br><br>
        <span style='font-size: 16px'>", 
        total,
        "</span>"
      ), 
      x = -120, #y = 150
      verticalAlign = "middle"
    ) |>
    hc_add_theme(hc_theme_pmt)
}