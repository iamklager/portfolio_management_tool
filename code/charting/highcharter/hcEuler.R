#### hcEuler
# 


hcEuler <- function(l) {
  
  # No data check
  if (is.null(l)) {
    return(validate(need(F, "No or not enought data available.")))
  }
  
  df <- l$PCR
  df$PCR <- 100 * df$PCR
  sigma <- round(l$sigma_p, 3)
  
  df |>
    hchart(
      type="pie",
      hcaes(x = DisplayName, y=PCR, color=Group),
      name = "Percentage Risk Contribution"
    ) |>
    hc_plotOptions(
      pie = list(
        borderColor = "#0d1821",
        dataLabels = list(enabled = F),
        showInLegend = T,
        innerSize = "65%",
        center = list("50%", "50%"),
        tooltip = list(
          pointFormat = "{point.Type}/{point.Group}: {point.PCR:.2f} %"
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
        <b> <br>Portfolio:</b>
        </span>
        <br><br>
        <span style='font-size: 16px'>", 
        sigma,
        "</span>"
        ), 
      x = -120, #y = 150
      verticalAlign = "middle"
    ) |>
    hc_add_theme(hc_theme_pmt)
}