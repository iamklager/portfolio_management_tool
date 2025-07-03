#### AddTransaction
# Adds a transaction to the transacions table.

AddTransaction <- function(
    conn, date, display_name, quantity, price_total, ticker_symbol, 
    type, group, transaction_type, transaction_currency, source_currency
) {
  
  transactions <- dbGetQuery(
    conn,
    "
    SELECT DisplayName, Type, [Group], SourceCurrency
    FROM transactions
    WHERE TickerSymbol = ?
    LIMIT 1;
    ",
    params=ticker_symbol
  )
  if (nrow(transactions) > 0) {
    if (
      (display_name != transactions$DisplayName) || 
      (type != transactions$Type) ||
      (group != transactions$Group) || 
      (source_currency != transactions$SourceCurrency)
    ) {
      return(paste0(
        "Error: DisplayName, Type, Group or SourceCurrency for '",
        ticker_symbol,
        "' does not match existing entries!"
      ))
    }
  }
  
  AddCurrency(conn, source_currency)
  
  res <- dbSendQuery(
    conn,
    "
    INSERT INTO transactions
    (
      Date,
      DisplayName,
      Quantity,
      PriceTotal,
      TickerSymbol,
      Type,
      [Group],
      TransactionType,
      TransactionCurrency,
      SourceCurrency
    )
    VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    ",
    params=c(
      format(as.Date(date), "%Y-%m-%d"), display_name, quantity, price_total, ticker_symbol, 
      type, group, transaction_type, transaction_currency, source_currency
    )
  )
  dbClearResult(res)
  
  return(0)
}