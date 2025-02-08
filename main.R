### Functions ----
invisible(lapply(
  list.files("code", pattern = ".R", full.names = T, recursive = T), 
  function(file) {
    source(file)
  }
))


### Libraries ----
CheckDependencies(
  dependencies = c(
    "DBI", "RSQLite", "readxl", "quantmod", "uncorbets", 
    "highcharter", "shiny", "bslib", "DT"
  ),
  install_dependencies = TRUE
)


### Database setup ----
CreateDB()
conn <- dbConnect(SQLite(), "user.db")


### Highcharter theme ----
hc_theme_pmt <- hc_theme_pmt() # To avoid redundant function calls


### Running the app ----
shinyApp(ui=UI(), server=Server)

