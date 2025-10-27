# Replication files for Conrad, C., Schoelkopf, J., Tushteva, N. (2025) "Long-Term Volatility Shapes the Stock Market’s Sensitivity to News", Journal of Econometrics




Please cite as:

> Conrad, Christian and Schoelkopf, Julius Theodor and Tushteva, Nikoleta, Long-Term Volatility Shapes the Stock Market's Sensitivity to News (2025, first version 2023). Available at SSRN: http://dx.doi.org/10.2139/ssrn.4632733.


## Data sets needed

While the high-frequency return data (purchased from TickData) and the announcements data (purchased from Bloomberg Forecasts) used in our paper are proprietary and redistribution is not permitted, we cannot include the data in this repository. All data must be placed in the folder "raw data" using the correct file names. Please make sure to use the corresponding vintages, when available. 

The different datasets needed can be found here:
* Bloomberg Forecasts: Bloomberg Terminal (Median Forecast, Actual Release, Release Date) 
* High-frequency Return Data from Tick Data for S&P500 E-mini futures, S&P500 and the EuroStoxx 50. 


#### Control Variables (for Table 5 and A.3, A.5, A.6, A.13 and Figure A.3)  
* FOMC sentiment index ([Gardner et al. (2022)](https://www.sciencedirect.com/science/article/pii/S0304407621002530)): obtained from the authors (sentiment_dec2020.xlsx)
* [CBO Real Output Gap, retrieved from FRED](https://fred.stlouisfed.org/graph/?g=f1cZ) 
* From the [Philadelphia FED Survey of Professional Forecasters](https://www.philadelphiafed.org/surveys-and-data/real-time-data-research/survey-of-professional-forecasters): Tbill3M.xlsx
* [Husted et al. (2025) Monetary Policy Uncertainty](https://sites.google.com/site/lucasfhusted/data)
* [Macroeconomic Uncertainty (Jurado et al., 2015)](https://www.sydneyludvigson.com/macro-and-financial-uncertainty-indexes) 
* [Chicago Board Options Exchange, CBOE Volatility Index (VIX), retrieved from FRED](https://fred.stlouisfed.org/series/VIXCLS) 
* GJR-GARCH
* [Bauer et al. (2023). Risk Appetite and the Risk-Taking Channel of Monetary Policy](https://www.michaeldbauer.com/files/risk_index.xlsx) 
* CBOE/CBOT 10-year U.S. Treasury Note Volatility (TYVIXSM), retrieved from Bloomberg Terminal 
* MOVE Index, retrieved from Bloomberg Terminal 
* Credit Spread (Spread between moodys corporate bond A index yield and the us gov 10 year yield), retrieved from Bloomberg Terminal 
* [10-year Treasury yields minus 3-month Treasury bill rates, retrieved from FRED](https://fred.stlouisfed.org/series/T10Y3M) 
* CPIAUCSL.xlsx (?)
* USAGDPDEFQISMEI.xlsx (?) GDP Deflator?
* 

After running _2025_10_23_1_Import_Dataset.do_ in Stata, you can run the main analysis using _2025_10_23_Empirical Analysis.do_. The latter file produces all the tables and figures from the paper. 


## Contact 
Please address any questions about the code to:

* Christian Conrad, Heidelberg University, Department of Economics. Email: christian.conrad [at] awi.uni-heidelberg.de
* Julius Schoelkopf, Heidelberg University, Department of Economics. Email: julius.schoelkopf [at] awi.uni-heidelberg.de

We do not assume any responsibilities for results produced with the available code. Please let us know, if you have suggestions for further versions. 

## Software 
The codes have been written in Matlab (R2021b - R2025b, 64-bit macOS) and StataMP (version 16.0 - 18.0 for Apple Silicon) on macOS Sequoia (15.5, M2). 
