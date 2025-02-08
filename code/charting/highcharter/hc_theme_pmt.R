#### hc_theme_pmt
# A custom highcharter theme to fit this dashboard's dark mode.


hc_theme_pmt <- function() {
  theme <- highcharter::hc_theme(
    chart = list(
      backgroundColor = "#0d1821"
    ),
    title = list(
      style = list(
        color = "#eeeeee"
      )
    ),
    subtitle = list(
      style = list(
        color = "#eeeeee"
      )
    ),
    legend = list(
      itemStyle = list(
        color = "#aaaaaa"
      ),
      itemHiddenStyle = list(
        color = "#aaaaaa"
      ),
      itemHoverStyle = list(
        color = "#eeeeee"
      ),
      navigation = list(
        style = list(
          activeColor = "#eeeeee",
          inactiveColor = "#aaaaaa"
        )
      ),
      title = list(
        style = list(
          color = "#eeeeee"
        )
      )
    ),
    xAxis = list(
      gridLineColor = "#444444",
      tickColor = "#aaaaaa",
      lineColor = "#aaaaaa",
      labels = list(
        style = list(
          color = "#eeeeee"
        )
      ),
      title = list(
        style = list(
          color = "#eeeeee"
        )
      )
    ),
    yAxis = list(
      gridLineColor = "#444444",
      tickColor = "#aaaaaa",
      lineColor = "#aaaaaa",
      labels = list(
        style = list(
          color = "#eeeeee"
        )
      ),
      title = list(
        style = list(
          color = "#eeeeee"
        )
      )
    ),
    caption = list(
      style = list(
        color = "#aaaaaa"
      )
    ),
    credits = list(
      style = list(
        color = "#aaaaaa"
      )
    )
  )
  theme$colors <- c(
    "#c1232b", "#27727b", "#fcce10", "#e87c25", "#b5c334",
    "#fe8463", "#9bca63", "#fad860", "#f3a43b", "#60c0dd",
    "#d7504b", "#c6e579", "#f4e001", "#f0805a", "#26c0c0"
  )
  
  return(theme)
}