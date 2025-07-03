#### QueryCurrencySymbols
# Queries all currency symbols from the database.


QueryCurrencySymbols <- function(conn) {
  res <- dbGetQuery(conn, "SELECT Currency FROM currencies;")[, 1]
  return(res)
}
