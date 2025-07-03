TrackingServer <- function(id, conn, from, to) {
  moduleServer(id, function(input, output, session) {
    
    ## Return value
    transaction_event <- reactiveVal(1)
    
    ## Single transaction
    observeEvent(input$in_TrackTransaction, {
      validity_check <- CheckTransactionValiditySingle(
        conn, input$in_DateAsset, input$in_AssetDisplayName,
        input$in_AssetQuantity, input$in_AssetPriceTotal,
        input$in_AssetTickerSymbol, input$in_AssetType,
        input$in_AssetGroup, input$in_AssetTransType,
        input$in_AssetTransCur, input$in_AssetSourceCur
      )
      if (validity_check != 0) {
        showNotification(validity_check, type="error")
        return()
      }
      failed_transaction <- AddTransaction(
        conn, input$in_DateAsset, input$in_AssetDisplayName,
        input$in_AssetQuantity, input$in_AssetPriceTotal,
        input$in_AssetTickerSymbol, input$in_AssetType,
        input$in_AssetGroup, input$in_AssetTransType,
        input$in_AssetTransCur, input$in_AssetSourceCur
      )
      if (failed_transaction != 0) {
        showNotification(failed_transaction, type="error")
        return()
      }
      UpdateXRates(conn)
      new_event <- transaction_event() * (-1)
      transaction_event(new_event)
      showNotification("Successfully added transaction!", type="message")
    })
    
    ## Append transactions file
    observeEvent(input$in_AppendFileTransactions, {
      validity_check <- CheckTransactionValidityMultiple(
        conn, input$in_FileAssets
      )
      if (!is.data.frame(validity_check)) {
        showNotification(validity_check, type="error")
        return()
      }
      failed_transactions <- AddTransactionsFromFile(conn, validity_check)
      if (length(failed_transactions) != 0) {
        for (failed_transaction in failed_transactions) {
          showNotification(failed_transaction, type="error")
        }
      }
      if (nrow(validity_check) > length(failed_transactions)) {
        UpdateXRates(conn)
        new_event <- transaction_event() * (-1)
        transaction_event(new_event)
        showNotification("Successfully appended transactions!", type="message")
      }
    })
    
    ## Overwrite with transactions file
    observeEvent(input$in_OverwriteFileTransactions, {
      WipeDB(conn)
      validity_check <- CheckTransactionValidityMultiple(
        conn, input$in_FileAssets
      )
      if (!is.data.frame(validity_check)) {
        showNotification(validity_check, type="error")
        return()
      }
      failed_transactions <- AddTransactionsFromFile(conn, validity_check)
      if (length(failed_transactions) != 0) {
        for (failed_transaction in failed_transactions) {
          showNotification(failed_transaction, type="error")
        }
      }
      if (nrow(validity_check) > length(failed_transactions)) {
        UpdateXRates(conn)
        new_event <- transaction_event() * (-1)
        transaction_event(new_event)
        showNotification("Successfully overwrote transactions!", type="message")
      }
    })
    
    ## Transaction table
    transactions <- reactive({
      input$in_TrackTransaction
      input$in_AppendFileTransactions
      input$in_OverwriteFileTransactions
      QueryTransactionsFromTo(conn, from(), to())
    })
    output$out_TransactionList <- renderDT({
      t <- transactions()
      t$PriceTotal <- round(t$PriceTotal, 2)
      DT::datatable(
        data=t, 
        options=list(paging =TRUE, pageLength=5)
      )
    })
    
    return(transaction_event)
  })
}
