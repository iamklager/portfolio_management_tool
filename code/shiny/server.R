Server <- function(input, output, session) {
  
  # Daily update
  today <- reactive({
    invalidateLater(24 * 60 * 60 * 1000)
    Sys.Date()
  })
  
  # Sidebar
  vals_sidebar <- SidebarServer(
    id="sidebar", conn=conn, 
    today=reactive(today())
  )
  
  # Tracking
  vals_tracking <- TrackingServer(
    id="tracking", conn=conn,
    from=vals_sidebar()$date_from,
    to=vals_sidebar()$date_to
  )
  
  # Data sets
  vals_datasets <- datasetsSever(
    id="datasets", conn=conn,
    today=reactive(today()),
    from=vals_sidebar()$date_from,
    to=vals_sidebar()$date_to,
    currency=vals_sidebar()$currency,
    tracking=reactive(vals_tracking()),
    rfr=vals_sidebar()$rfr
  )

  # Summary
  SummaryServer(
    id="summary", conn=conn,
    currency=vals_sidebar()$currency,
    aum=reactive(vals_datasets$aum),
    total_profits=reactive(vals_datasets$total_profits),
    monthly_investments=reactive(vals_datasets$monthly_investments),

    portfolio_returns=reactive(vals_datasets$portfolio_returns),
    sharpe_ratio=reactive(vals_datasets$sharpe_ratio)
  )

  # Performance
  PerformanceServer(
    id="performance", conn=conn,
    tracking=reactive(vals_tracking()),
    from=vals_sidebar()$date_from,
    to=vals_sidebar()$date_to,
    currency=vals_sidebar()$currency,
    prices=reactive(vals_datasets$all_prices),
    aggr_prices=reactive(vals_datasets$aggr_prices),
    transactions_to=reactive(vals_datasets$transactions_to),

    weighted_returns=reactive(vals_datasets$weighted_returns),
    asset_performance=reactive(vals_datasets$asset_performance),
    portfolio_returns=reactive(vals_datasets$portfolio_returns)
  )

  # Risk
  RiskServer(
    id="risk", conn=conn,
    from=vals_sidebar()$date_from,
    to=vals_sidebar()$date_to,
    currency=vals_sidebar()$currency,
    correlation_method=vals_sidebar()$risk_correlation_method,
    time_frame=vals_sidebar()$risk_time_frame,
    positions=reactive(vals_datasets$current_positions),
    prices=reactive(vals_datasets$all_prices)
  )
  
  # Disconnect the database upon closing the app
  onStop(function() {
    dbDisconnect(conn)
  })
  
}