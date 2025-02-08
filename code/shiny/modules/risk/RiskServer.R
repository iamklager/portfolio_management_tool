RiskServer <- function(id, conn, from, to, currency, correlation_method, time_frame, positions, prices) {
  moduleServer(id, function(input, output, session) {
    
    ## Risk returns
    risk_returns <- reactive({
      PreFilterRiskReturns(
        TransformRiskReturns(prices(), positions()),
        from(), to(), time_frame()
      )
    })
    
    
    ## Asset Allocation
    output$out_AllocationCurrent <- renderHighchart({
      hcAssetAllocation(positions(), "Current", currency())
    })
    output$out_AllocationAcquisition <- renderHighchart({
      hcAssetAllocation(positions(), "Acquisition", currency())
    })
    
    
    ## Correlation
    correlation_matrix <- reactive({
      ComputeCorrelationMatrix(positions(), risk_returns(), correlation_method())
    })
    output$out_CorrelationMatrix <- renderHighchart({
      hcCorrelationMatrix(correlation_matrix())
    })
    
    
    ## Risk Decomposition
    # Euler
    euler <- reactive({
      ComputeRiskDecompEuler(positions(), risk_returns())
    })
    output$out_Euler <- renderHighchart({
      hcEuler(euler())
    })
    
    # Effective Number of Independent Bets
    eff_bets <- reactive({
      ComputeEffectiveBets(positions(), risk_returns())
    })
    output$out_EffectiveBets <- renderHighchart({
      hcEffectiveBets(eff_bets())
    })
    
    ## ?Calmer Ratio?
    
    
  })
}

