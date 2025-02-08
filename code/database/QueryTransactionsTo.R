#### QueryTransactionsTo
# Queries all transactions up to a date.

QueryTransactionsTo <- function(conn, to) {
  transactions <- dbGetQuery(
    conn,
    "
    SELECT *
    FROM vTransactions
    WHERE Date <= ?;
    ",
    params=to
  )
  
  return(transactions)
}
