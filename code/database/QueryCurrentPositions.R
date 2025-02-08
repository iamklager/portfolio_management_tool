#### QueryCurrentPositions
# 

QueryCurrentPositions <- function(conn, to) {
  
  # Current positions in quantities
  current_positions <- dbGetQuery(
    conn, "
        SELECT
        	DisplayName,
        	SUM(
        		Quantity * CASE
        			WHEN TransactionType = 'Buy' THEN 1
        			ELSE -1
        		END
        	) AS Quantity,
        		SUM(
        		PriceTotal * CASE
        			WHEN TransactionType = 'Buy' THEN 1
        			ELSE -1
        		END
        	) AS AcquisitionValue,
        	TickerSymbol,
        	Type,
        	[Group],
        	SourceCurrency,
        	MAX(Date) AS LastTransaction
        FROM vTransactions
        WHERE Date <= ?
        Group BY DisplayName, TickerSymbol, Type, [Group], SourceCurrency;
        ",
    params=to
  )
  
  return(current_positions)
}