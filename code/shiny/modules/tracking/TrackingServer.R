TrackingServer <- function(id, conn, from, to) {
  moduleServer(id, function(input, output, session) {
    
    ## Return value
    transaction_event <- reactiveVal(1)
    
    ## Single transaction
    observeEvent(input$in_TrackTransaction, {
      query_state <- AddTransaction(
        conn, input$in_DateAsset, input$in_AssetDisplayName,
        input$in_AssetQuantity, input$in_AssetPriceTotal,
        input$in_AssetTickerSymbol, input$in_AssetType,
        input$in_AssetGroup, input$in_AssetTransType,
        input$in_AssetTransCur, input$in_AssetSourceCur
      )
      
      if (query_state == 0) {
        new_event <- transaction_event() * (-1)
        transaction_event(new_event)
        updateDateInput(inputId="in_DateAsset", value=Sys.Date())
        updateTextInput(inputId="in_AssetDisplayName", value="")
        updateNumericInput(inputId="in_AssetQuantity", value=0)
        updateNumericInput(inputId="in_AssetPriceTotal", value=0)
        updateTextInput(inputId="in_AssetTickerSymbol", value="")
        updateTextInput(inputId="in_AssetTickerGroup", value="")
        showNotification("Tracked transaction.", type="message")
      } else if (query_state == 1) {
        showNotification(
          "Could not track transaction.\nPlease check if the ticker exists on Yahoo-Finance or if no fields are empty.",
          type="error"
        )
      } else if (query_state == 2) {
        showNotification(
          paste0(
            "At least one of DisplayName, Type, Group or SourceCurrency does not match existing values for '",
            input$in_AssetTickerSymbol, "'.\nPlease use identical values."
          ),
          type="error"
        )
      }
    })
    
    ## Append transactions file
    observeEvent(input$in_AppendFileTransactions, {
      query_state <- AddTransactionsFromFile(conn, input$in_FileAssets)
      if (query_state == 0) {
        new_event <- transaction_event() * (-1)
        transaction_event(new_event)
        showNotification("Appending transactions.", type="message")
      } else if (query_state == 1) {
        showNotification("No file selected.", type="error")
      } else if (query_state == 2) {
        showNotification("Invalid file extension.\n Must be either '.csc' or '.xlsx'.", type="error")
      } else if (query_state == 3) {
        showNotification("File columns do not match.", type="error")
      } else if (query_state == 4) {
        showNotification("File is empty.", type="error")
      } else if (query_state == 5) {
        new_event <- transaction_event() * (-1)
        transaction_event(new_event)
        showNotification("At least one transaction could not be tracked.\nPlease check your transactions.", type="warning")
      }
    })
    
    ## Overwrite with transactions file
    observeEvent(input$in_OverwriteFileTransactions, {
      WipeDB(conn)
      new_event <- transaction_event() * (-1)
      transaction_event(new_event)
      showNotification("Emptying database.", type="message")
      query_state <- AddTransactionsFromFile(conn, input$in_FileAssets)
      if (query_state == 0) {
        showNotification("Appending transactions.", type="message")
      } else if (query_state == 1) {
        showNotification("No file selected.", type="error")
      } else if (query_state == 2) {
        showNotification("Invalid file extension.\n Must be either '.csc' or '.xlsx'.", type="error")
      } else if (query_state == 3) {
        showNotification("File columns do not match.", type="error")
      } else if (query_state == 4) {
        showNotification("File is empty.", type="error")
      } else if (query_state == 5) {
        showNotification("At least one transaction could not be tracked.\nPlease check your transactions.", type="warning")
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
