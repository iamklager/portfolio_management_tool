#### WipeDB
# Wipes the entire database.


WipeDB <- function(conn) {
  res <- dbSendQuery(conn, "DELETE FROM transactions;")
  res <- dbSendQuery(conn, "DELETE FROM prices;")
  res <- dbSendQuery(conn, "DELETE FROM xrates WHERE Adjusted NOT IN ('USD', 'EUR');")
  res <- dbSendQuery(conn, "DELETE FROM currencies WHERE Currency NOT IN  ('USD', 'EUR');")
  
  dbClearResult(res)
  
  return(0)
}

