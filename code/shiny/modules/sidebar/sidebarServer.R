SidebarServer <- function(id, conn, today) {
  moduleServer(id, function(input, output, session) {
    
    # Daily update
    observeEvent(today(), {
      updateDateInput(
        inputId="in_DateTo",
        value=format(today(), "%Y-%m-%d")
      )
      updateDateInput(
        inputId="in_DateFrom",
        value=format(today(), "%Y-01-01")
      )
    })
    
    # YTD
    observeEvent(input$in_DateYTD, {
      updateDateInput(
        inputId="in_DateTo",
        value=format(today(), "%Y-%m-%d")
      )
      updateDateInput(
        inputId="in_DateFrom",
        value=format(today(), "%Y-01-01")
      )
    })
    
    # All time
    observeEvent(input$in_DateAll, {
      updateDateInput(
        inputId="in_DateTo",
        value=format(today(), "%Y-%m-%d")
      )
      updateDateInput(
        inputId="in_DateFrom",
        value=min(
          format(today(), "%Y-%m-%d"), 
          dbGetQuery(conn, "SELECT MIN(Date) FROM transactions;")[1, 1],
          na.rm=T
        )
      )
    })
    
    # 1 Year
    observeEvent(input$in_Date1Y, {
      updateDateInput(
        inputId="in_DateTo",
        value=format(today(), "%Y-%m-%d")
      )
      updateDateInput(
        inputId="in_DateFrom",
        value=paste0(as.numeric(format(today(), "%Y")) - 1, format(today(), "-%m-%d"))
      )
    })
    
    # 1 Year
    observeEvent(input$in_DateMonth, {
      updateDateInput(
        inputId="in_DateTo",
        value=format(today(), "%Y-%m-%d")
      )
      updateDateInput(
        inputId="in_DateFrom",
        value=format(today(), "%Y-%m-01")
      )
    })
    
    # Return values
    ret_vals <- reactive({
      list(
        date_from = reactive(format(input$in_DateFrom, "%Y-%m-%d")),
        date_to   = reactive(format(input$in_DateTo, "%Y-%m-%d")),
        currency  = reactive(input$in_Currency),
        risk_correlation_method = reactive(input$in_RiskCorrelationMethod),
        risk_time_frame = reactive(input$in_RiskTimeFrame),
        rfr = reactive(input$in_SummaryRiskFreeRate)
      )
    })
    
    # Risk time frame
    observeEvent(input$in_RiskTimeFrame, {
      res <- dbSendQuery(
        conn,
        "
        UPDATE settings
        SET RiskTimeFrame = ?;
        ",
        params=input$in_RiskTimeFrame
      )
      dbClearResult(res)
    })
    
    # Transactions: Downloads
    output$out_TransactionsDownload <- downloadHandler(
      filename = function() {
        paste0(
          format(input$in_DateFrom, "%Y-%m-%d_"),
          format(input$in_DateTo, "%Y-%m-%d"), 
          "_transactions.csv")
      },
      content = function(file) {
        trans <- dbGetQuery(
          conn,
          "
          SELECT *
          FROM transactions
          WHERE Date BETWEEN ? AND ?;
          ",
          params = c(
            format(input$in_DateFrom, "%Y-%m-%d"),
            format(input$in_DateTo, "%Y-%m-%d")
          )
        )
        write.csv(trans, file)
      }
    )
    
    return(ret_vals)
    
  })
}