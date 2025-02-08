#### QueryMonthlyInvestments
# Queries the invested sum for each month from the database.


QueryMonthlyInvestments <- function(conn, from, to) {
  res <- dbGetQuery(
    conn,
    "
    WITH t AS (
      SELECT
      	SUBSTR(Date, 1, 8) || '01' AS Date,
      	PriceTotal
      FROM vTransactions
      WHERE Date BETWEEN ? AND ?
      	AND TransactionType = 'Buy'
    )
    SELECT
    	Date,
    	SUM(PriceTotal) AS InvestedAmount
    FROM t
    GROUP BY Date;
    ",
    params=c(from, to)
  )
  
  all_dates <- data.frame(
    Date = format(
      seq.Date(as.Date(from), as.Date(to), by="month"),
      "%Y-%m-01"
    )
  )
  res <- merge(res, all_dates, by="Date", all=T)
  res[is.na(res)] <- 0
  res$Date <- as.Date(res$Date)
  
  return(res)
}
