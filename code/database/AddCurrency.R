#### AddCurrency
#


AddCurrency <- function(conn, currency) {
  if (currency == 'USD') {
    return(0)
  }
  res <- dbSendQuery(
    conn,
    "
    INSERT OR IGNORE INTO currencies (Currency) 
    VALUES (?);
    ",
    params=currency
  )
  dbClearResult(res)
  
  return(0)
}