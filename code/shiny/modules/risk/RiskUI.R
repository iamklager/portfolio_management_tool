RiskUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    layout_columns(
      col_widths = c(6, 6),
      
      navset_card_underline(
        title="Asset Allocation",
        nav_panel(
          title="Current Value", 
          highchartOutput(ns("out_AllocationCurrent"))
        ),
        nav_panel(
          title="Acquisition Value", 
          highchartOutput(ns("out_AllocationAcquisition"))
        )
      ),
      
      navset_card_underline(
        title="Correlation",
        nav_panel(
          title=NULL,
          highchartOutput(ns("out_CorrelationMatrix"))
        )
      )
    ),
    
    layout_columns(
      col_widths = c(6, 6),
      
      navset_card_underline(
        title="Risk Decomposition",
        nav_panel(
          title="Following Euler",
          highchartOutput(ns("out_Euler"))
        )
      ),
      navset_card_underline(
        title="Effective Number of Bets",
        nav_panel(
          title="Following Meucci",
          highchartOutput(ns("out_EffectiveBets"))
        )
      )
      
      # navset_card_underline(
      #   title="?Calmer Ratio?", # Not sure what to put here
      #   nav_panel(title=NULL)
      # )
    )
  )
  
}