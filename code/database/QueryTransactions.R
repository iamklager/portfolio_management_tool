#### QueryTransactions
# Queries all transactions within a time frame in the selected currency.

QueryTransactions <- function(conn, from, to) {
  transactions <- dbGetQuery(
    conn,
    "
    SELECT *
    FROM vTransactions
    WHERE Date BETWEEN ? AND ?;
    ",
    params=c(from, to)
  )
  print("QueryTransactions() was used.")
  return(transactions)
}