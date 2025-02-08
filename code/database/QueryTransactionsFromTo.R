#### QueryTransactionsFromTo
# Queries all transactions within a time frame.

QueryTransactionsFromTo <- function(conn, from, to) {
  transactions <- dbGetQuery(
    conn,
    "
    SELECT *
    FROM vTransactions
    WHERE Date BETWEEN ? AND ?;
    ",
    params=c(from, to)
  )
  
  return(transactions)
}
