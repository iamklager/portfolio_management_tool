#### AddTransaction
# Adds a transaction to the transacions table.

AddTransaction <- function(
    conn, date, display_name, quantity, price_total, ticker_symbol, 
    type, group, transaction_type, transaction_currency, source_currency
) {
  if (
    (display_name == "") || is.na(display_name) ||
    (quantity == 0) || is.na(quantity) ||
    (ticker_symbol == "") || is.na(ticker_symbol) ||
    (group == "") || is.na(group) ||
    (transaction_currency == "") || is.na(transaction_currency) ||
    (source_currency == "") || is.na(source_currency)
  ) {
    return(1)
  }
  
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
      return(2)
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
      format(date, "%Y-%m-%d"), display_name, quantity, price_total, ticker_symbol, 
      type, group, transaction_type, transaction_currency, source_currency
    )
  )
  dbClearResult(res)
  
  return(0)
}