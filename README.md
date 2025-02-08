# Portfolio Management Tool

An R-Shiny dashboard/web application to track and monitor your portfolio through various graphs and statistical measures.


## Use Case \& Background

After wanting to add additional content to my (now deprecated) [Personal Finance Dashboard](https://github.com/iamklager/personal_finance_dashboard), I quickly realized that it would become too crowded. Therefore, I split it into two parts.


## How to Run

After downloading the project folder, you can start the application by running the *main.R* script. Doing this will automatically load all necessary functions before starting the application. To install all necessary dependencies automatically, you can simply set *install\_dependencies* in the *CheckDependencies()* function to *TRUE* (default).
```r
CheckDependencies(
  dependencies = c(
    "DBI", "RSQLite", "readxl", "quantmod", "uncorbets", 
    "highcharter", "shiny", "bslib", "DT"
  ),
  install_dependencies = TRUE
)
```

Alternatively, you can install all the necessary dependencies manually by running the following code:
```r
install.packages(c(
  "DBI", "RSQLite", "readxl", "quantmod", "uncorbets",
  "highcharter", "shiny", "DT", "bslib"
))
```


## Technologies Used

- R: + Shiny, bslib, higcharter, (echarts4r), and quantmod
- SQLite
- HTML
- CSS


## Components

### Tabs

| **Tab**     | **Description**                                                                                              |
|-------------|--------------------------------------------------------------------------------------------------------------|
| Summary     | Summarizes the portfolio's most important aspects at one glance.                                             |
| Performance | Displays the performance of the entire portfolio, individual assets, as well as their transaction histories. |
| Risk        | Displays the asset allocation, as well as various risk measures related to it.                               |
| Tracking    | Displays all past transactions and allows the tracking of new ones.                                          |

### Measures

| **Measure**                  | **Description**                                                                                                                      |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Sharpe Ratio                 | The geometric Sharpe ratio of the entire portfolio (The user can set the risk-free-rate himself).                                    |
| Portfolio Performance        | Performance of the portfolio (Single value, either total in the user's selected currency or as percentage).                          |
| Assets Under Management      | The daily value of all assets held.                                                                                                  |
| Monthly Investments          | Total monthly invested amounts (Sales are not included here).                                                                        |
| Portfolio Performance        | Daily portfolio performance as percentage.                                                                                           |
| Asset Performance            | Performance of each asset as percentage.                                                                                             |
| Cumulative Asset Development | Daily relative asset prices weighted by invested amounts (i.e., true/net cumulative asset performance as percentage).                |
| Transaction History          | Past transactions for an asset in comparison to its daily closing prices.                                                            |
| Asset Allocation             | Asset allocation at the current evaluation and at acquisition value.                                                                 |
| Correlation                  | Correlation matrix for all assets.                                                                                                   |
| Risk Decomposition           | Portfolio standard deviation and its Euler decomposition (Weighted using the current allocation).                                    |
| Effective Bets               | The effective number of independent bets following Meucci (Weighted using the current allocation and computed using the PCA method). |


## Implementation Details

### Data Import \& Storage

To store all the necessary data, a SQLite database has been implemented.

Asset transactions can be tracked in the *Tracking* tab, either via entering each transaction manually or by uploading a csv or xlsx file which can be appended to the existing transactions or be used to overwrite them. Note that that transactions consist of multiple values which must also be the column names of the uploaded files. See the provided demo file (*demo\_data/transactions.csv*) for reference. These values are:

| **Value**           | **Type** | **Description**                                                                                        |
|---------------------|----------|--------------------------------------------------------------------------------------------------------|
| Date                | Date     | The date of the transaction.                                                                           |
| DisplayName         | Text     | The name under which the asset should be displayed.                                                    |
| Quantity            | Number   | The quantity bought or sold.                                                                           |
| PriceTotal          | Number   | The total price paid or received (after taxes and fees).                                               |
| TickerSymbol        | Text     | The ticker under which the asset can be found on Yahoo-Finance (e.g., 'MSFT' for the Microsoft stock). |
| Type                | Text     | The asset type (either 'Stock' or 'Alternative').                                                      |
| Group               | Text     | The group you want the asset to be categorized under (e.g., 'Stocks', 'ETFs', 'Metals', 'Crypto').     |
| TransactionType     | Text     | Either 'Buy' or 'Sell'.                                                                                |
| TransactionCurrency | Text     | The currency code of the currency used for the transactions (e.g., 'EUR').                             |
| SourceCurrency      | Text     | The currency code of the currency under which the asset is listed (e.g., 'USD').                       |

Price and exchange rate data is being queried from Yahoo-Finance via the quantmod package. This happens each time a transaction has been tracked, upon starting the tool and every 24h after that (i.e., daily price updates). Daily returns of prices are being computed before they are being stored in the database. Exchange rates for days without data (i.e., weekends and holidays) are also being forward-filled before the exchange rates are being stored in the database.

Additional information, such as the currently selected currency and the selected time-frame used for the risk measurements are also being stored in the database and updated once they are changed by the user.

To keep disk-memory usage to a minimum, everything else is being computed on the fly and in memory.

### Data Processing

Each computation involving price or transaction data makes use of views that convert each price into the currency selected by the user. This is done by first converting each price into USD if it is not already notating in USD and by then converting it into the selected currency. This is one of the reasons to why the selected currency is already stored in the database.

As many of the necessary selections and aggregations as possible are being done using SQLite. The remaining computations happen in R and are structured in a way that aims at reducing the amount of duplicated operations and (intermediate) datasets. Therefore, only a few datasets are being generated and are then being used by multiple parts of the application with minimal to no additional processing taking place.

### Visualization

To visualize everything, a combination of highcharter plots,  table-, and simple text outputs are displayed in the dashboard's various tabs.

All of these components, as well as the dashboard itself, have been customized using the mechanism provided by R, as well as elements of HTML and CSS.

Last, pop up messages indicate whether a user's action succeeded or if they tried to do something that cannot be done, as well as intermediate state information.

(Note that floating tiles in the correlation matrix are a result of the CRAN-version of the highcharter library using an older version of HighchartsJS. See [this post on stackoverflow](https://stackoverflow.com/questions/74855868/highcharts-heatmap-tiles-float-after-resizing).

### Additional Design Choices

While the option to switch between dark and light mode, to change the colors for positive and negative values, to change the date format, as well as various tool tips were part of the [Personal Finance Dashboard](https://github.com/iamklager/personal_finance_dashboard), I did not implement these parts since realistically nobody else but myself is going to use this tool.

Originally, I planned on using echarts4r instead of highcharter for charting due its license being more friendly. However, I quickly realized that I simply prefer highcharter. I left in the code using echarts4r for anyone who wants to switch back to it. However, I assume that it won't work or yield the same results without some serious debugging. 


## Demo Screenshots

<p align = "center">
  <img src = "https://github.com/iamklager/portfolio_management_tool/raw/main/.github/screenshot_1.png" width = "400" />
  <img src = "https://github.com/iamklager/portfolio_management_tool/raw/main/.github/screenshot_2.png" width = "400" />
  <br>
  <img src = "https://github.com/iamklager/portfolio_management_tool/raw/main/.github/screenshot_3.png" width = "400" />
  <img src = "https://github.com/iamklager/portfolio_management_tool/raw/main/.github/screenshot_4.png" width = "400" />
</p>


