CreateDB <- function() {
  
  # Base case (database exists already)
  if(file.exists("user.db")) {
    return(0)
  }
  
  # Creating the connection
  conn <- dbConnect(SQLite(), "user.db")
  
  # Raw tables
  res <- dbSendQuery(conn, "
  CREATE TABLE IF NOT EXISTS currencies
  (
    Currency TEXT UNIQUE NOT NULL
  );
  ")
  res <- dbSendQuery(conn, "
  INSERT INTO currencies (Currency)
  VALUES ('USD'), ('EUR');
  ")
  res <- dbSendQuery(conn, "
  CREATE TABLE IF NOT EXISTS settings
  (
    DateFrom TEXT NOT NULL,
    Currency TEXT NOT NULL,
    RiskTimeFrame TEXT NOT NULL,
    RiskFreeRate REAL NOT NULL
  );
  ")
  res <- dbSendQuery(conn, "
  INSERT INTO settings (DateFrom, Currency, RiskTimeFrame, RiskFreeRate)
  VALUES (?, 'USD', 'Selection', 0);
  ", 
  params=format(Sys.Date(), "%Y-01-01")
  )
  res <- dbSendQuery(conn, "
  CREATE TABLE IF NOT EXISTS transactions
  (
    Date TEXT NOT NULL,
    DisplayName TEXT NOT NULL,
    Quantity REAL NOT NULL,
    PriceTotal REAL NOT NULL,
    TickerSymbol TEXT NOT NULL,
    Type TEXT NOT NULL,
    [Group] TEXT NOT NULL,
    TransactionType TEXT NOT NULL,
    TransactionCurrency TEXT NOT NULL,
    SourceCurrency TEXT NOT NULL
  );
  ")
  res <- dbSendQuery(conn, "
  CREATE TABLE IF NOT EXISTS xrates
  (
    Date TEXT NOT NULL,
    Open REAL,
    High REAL,
    Low REAL,
    Close REAL,
    Volume REAL,
    Adjusted REAL,
    Currency TEXT NOT NULL,
    PRIMARY KEY (Date, Currency)
  );
  ")
  dbSendQuery(conn, "
  CREATE TABLE IF NOT EXISTS prices
  (
    Date TEXT NOT NULL,
    Open REAL,
    High REAL,
    Low REAL,
    Close REAL,
    Volume REAL,
    Adjusted REAL,
    Return REAL,
    ReturnPercentage REAL,
    ReturnLog REAL,
    TickerSymbol TEXT NOT NULL,
    Currency TEXT NOT NULL,
    PRIMARY KEY (Date, TickerSymbol)
  );
  ")
  
  # Views
  res <- dbSendQuery(conn, "
  CREATE VIEW IF NOT EXISTS vTransactions AS
  WITH TransactionUSD AS (
  	SELECT
  		t.Date,
  		t.DisplayName,
  		t.Quantity,
  		t.PriceTotal / CASE
  			WHEN t.TransactionCurrency = 'USD' THEN 1
  			ELSE x.Adjusted
  		END AS PriceTotal,
  		t.TickerSymbol,
  		t.Type,
  		t.[Group],
  		t.TransactionType,
  		t.SourceCurrency
  	FROM transactions t
  	LEFT JOIN xrates x
  		ON t.TransactionCurrency = x.Currency
  			AND t.Date = x.Date
  )
  SELECT
  	t.Date,
  	t.DisplayName,
  	t.Quantity,
  	t.PriceTotal * CASE
  		WHEN (SELECT Currency FROM settings) = 'USD' THEN 1
  		ELSE x.Adjusted
  	END AS PriceTotal,
  	t.TickerSymbol,
  	t.Type,
  	t.[Group],
  	t.transactionType,
		t.SourceCurrency
  FROM TransactionUSD t
  LEFT JOIN xrates x
  	ON Currency = x.Currency
  		AND t.Date = x.Date;
  ")
  res <- dbSendQuery(conn, "
  CREATE VIEW IF NOT EXISTS vPrices AS
  WITH PricesUSD AS (
  	SELECT
      p.Date,
      p.Adjusted / CASE
        WHEN p.Currency = 'USD' THEN 1
        ELSE x.Adjusted
      END AS Adjusted,
      p.Return / CASE
        WHEN p.Currency = 'USD' THEN 1
        ELSE x.Adjusted
      END AS Return,
      p.TickerSymbol,
      p.ReturnPercentage / CASE
        WHEN p.Currency = 'USD' THEN 1
        ELSE x.Adjusted
      END AS ReturnPercentage,
      p.ReturnLog / CASE
        WHEN p.Currency = 'USD' THEN 1
        ELSE x.Adjusted
      END AS ReturnLog,
      p.TickerSymbol
    FROM prices p
    LEFT JOIN xrates x
      ON p.Currency = x.Currency
        AND p.Date = x.Date
  )
  SELECT
  	p.Date,
    p.Adjusted * CASE
  		WHEN (SELECT Currency FROM settings) = 'USD' THEN 1
  		ELSE x.Adjusted
  	END AS Adjusted,
    p.Return * CASE
  		WHEN (SELECT Currency FROM settings) = 'USD' THEN 1
  		ELSE x.Adjusted
  	END AS Return,
    p.ReturnPercentage * CASE
  		WHEN (SELECT Currency FROM settings) = 'USD' THEN 1
  		ELSE x.Adjusted
  	END AS ReturnPercentage,
    p.ReturnLog * CASE
  		WHEN (SELECT Currency FROM settings) = 'USD' THEN 1
  		ELSE x.Adjusted
  	END AS ReturnLog,
  	p.TickerSymbol
  FROM PricesUSD p
  LEFT JOIN xrates x
  	ON Currency = x.Currency
  		AND p.Date = x.Date;
  ")

  # Closing the connection
  dbClearResult(res)
  dbDisconnect(conn)
  
  return(0)
}