# Replication files for the paper Conrad, C., Schoelkopf, J., Tushteva, N. (2025) "Long-Term Volatility Shapes the Stock Market’s Sensitivity to News", Journal of Econometrics




Please cite as:

Conrad, Christian and Schoelkopf, Julius Theodor and Tushteva, Nikoleta, Long-Term Volatility Shapes the Stock Market's Sensitivity to News (2025, first version 2023). Available at SSRN: http://dx.doi.org/10.2139/ssrn.4632733.


## Data sets needed

As the financial data and Bloomberg Forecasts are proprietary, we cannot include the data in this repository. 

The different datasets needed can be found here:
* Bloomberg Forecasts: Bloomberg Terminal
* High-frequency Return Data: TickData e_miniESfront_07_15_2022_07_03.csv and e_miniESfront_08_45_2022_07_04.csv
* EURO_8_45_XX.csv and EURO_7_15_XX.csv

#### Macroeconomic Control Variables 
* FOMC sentiment index ([Gardner et al. (2022)](https://www.sciencedirect.com/science/article/pii/S0304407621002530)): obtained from the authors (sentiment_dec2020.xlsx)
* CBO Gap https://fred.stlouisfed.org/graph/?g=f1cZ $user/raw data/CBOGap.xls"
* From the [Philadelphia FED Survey of Professional Forecasters](https://www.philadelphiafed.org/surveys-and-data/real-time-data-research/survey-of-professional-forecasters): Tbill3M.xlsx
* [Husted et al. (2025) Monetary Policy Uncertainty](https://sites.google.com/site/lucasfhusted/data)
* Macroeconomic Uncertainty (Jurado et al. ): MacroUncertaintyToCirculate.xlsx
* Chicago Board Options Exchange, CBOE Volatility Index: VIX [VIXCLS] retrieved from FRED, 
* Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/VIXCLS, VIXCLS.xls
* GJR-GARCH


## Contact 
Please address any questions about the code to:

* Christian Conrad, Heidelberg University, Department of Economics. Email: christian.conrad [at] awi.uni-heidelberg.de
* Julius Schoelkopf, Heidelberg University, Department of Economics. Email: julius.schoelkopf [at] awi.uni-heidelberg.de

We do not assume any responsibilities for results produced with the available code. Please let us know, if you have suggestions for further versions. 

## Software 
The codes have been written in Matlab (R2023b, 64-bit macOS) and StataMP (version 18.0 for Apple Silicon) on macOS Sequoia (15.5, M2). 
