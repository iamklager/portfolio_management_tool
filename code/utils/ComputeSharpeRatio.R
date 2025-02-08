#### ComputeSharpeRatio
#


ComputeSharpeRatio <- function(df, rfr) {
  if (is.null(df)) {
    return(NULL)
  }
  
  n <- nrow(df)
  
  mu    <- prod(df$ReturnRel + 1)^(1/n) - 1
  sigma <- sd(df$ReturnRel)
  
  SR <- round((mu - 0.01 * rfr) / sigma, 3)
  
  text_color <- ifelse(SR >= 0, "#7eb00a", "#c1232b")
  
  tags$span(
    style = paste0(
      "color: ", text_color, ";
      margin: auto; text-align: center;
      font-size: 96px;
      "
    ),
    SR
  )
}

