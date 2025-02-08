#### UpdateXRates
#

UpdateXRates <- function(conn) {
  currencies <- dbGetQuery(conn, "SELECT Currency FROM currencies;")[, 1]
  for (currency in currencies) {
    YahooXRate2DB(conn, currency)
  }
  
  return(0)
}