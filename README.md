# Replication files for Conrad, C., Schoelkopf, J., Tushteva, N. (2025) "Long-Term Volatility Shapes the Stock Market’s Sensitivity to News", Journal of Econometrics

Please cite as:

> Conrad, Christian and Schoelkopf, Julius Theodor and Tushteva, Nikoleta, Long-Term Volatility Shapes the Stock Market's Sensitivity to News (2025, first version 2023). Available at SSRN: http://dx.doi.org/10.2139/ssrn.4632733.

## Replication Files

The replication files are provided in a chronological order

1) `mf2garch estimation/MF2GARCH_estimation.m` (MATLAB) generates MF2-GARCH volatility estimates (conditional volatility, long-term volatility, short-term volatility) used in the analysis. 
2) `code/2_Import_Dataset.do` (Stata) imports raw datasets, harmonizes variables, and outputs analysis-ready Stata (.dta) files.
3) `code/3_Empirical Analysis.do` (Stata) merges the previously generated analysis files, estimates the regression models, and exports publication-ready tables and figures. The do-file puts the figures of the paper into the folder 'figures' and the tables into the folder 'tables'.


## Data sets needed

While the high-frequency return data (purchased from TickData) and the announcements data (purchased from Bloomberg Forecasts) used in our paper are proprietary and redistribution is not permitted, we cannot include the data in this repository. All data must be placed in the folder "raw data" using the correct file names. Please make sure to use the corresponding vintages, when available. The different datasets needed can be found here:

#### Return Data 
* Bloomberg Forecasts for macroeconomic announcements: Bloomberg Terminal (Median Forecast, Actual Release, Release Date) 
* High-frequency Return Data from Tick Data for S&P500 E-mini futures, S&P500 and the EuroStoxx 50 (obtained using TickWrite 7 Data Management Software with Chicago Time setting) from 2001 onwards:  
    * S&P500 E-mini futures prices for 8:30 am EST: e_miniESfront_07_15_2022_07_03.csv to be saved as SPmini830.dta
    * S&P500 E-mini futures prices for 10:00 am EST: e_miniESfront_08_45_2022_07_04.csv to be saved as SPmini10.dta
    * S&P500 prices for 10:00 am EST: SP500_index_1983_2021.csv to be saved as SP.dta
    * Euro Stoxx 50 prices for 8:30 am EST: EURO_7_15_XX.csv to be saved as Eurostoxx830.dta
    * Euro Stoxx 50 prices for 10:00 am EST: EURO_8_45_XX.csv to be saved as Eurostoxx10.dta
* Daily Returns from Tick Data for S&P500 for the MF2-GARCH estimation to be saved as SPdailyneu.csv in mf2garch estimation from August 15, 1969 onwards. 

#### Control Variables (for Table 5 and A.3, A.5, A.6, A.13 and Figure A.3)  
* FOMC sentiment index ([Gardner et al. (2022)](https://www.sciencedirect.com/science/article/pii/S0304407621002530)): obtained from the authors (sentiment_dec2020.xlsx) 
* [CBO Real Output Gap, retrieved from FRED](https://fred.stlouisfed.org/graph/?g=f1cZ) to be saved as CBOGap.xls 
* From the [Philadelphia FED Survey of Professional Forecasters](https://www.philadelphiafed.org/surveys-and-data/real-time-data-research/survey-of-professional-forecasters): Tbill3M.xlsx
* [Husted et al. (2025) Monetary Policy Uncertainty](https://sites.google.com/site/lucasfhusted/data)
* [Macroeconomic Uncertainty (Jurado et al., 2015)](https://www.sydneyludvigson.com/macro-and-financial-uncertainty-indexes) MacroUncertaintyToCirculate.xlsx (Vintage from February 2023) 
* [Chicago Board Options Exchange, CBOE Volatility Index (VIX), retrieved from FRED](https://fred.stlouisfed.org/series/VIXCLS) 
* Expanding window GJR-GARCH GJR_EW.xlsx, forecasts are obtained by running `mf2garch estimation/GJR_estimation` using the same data set of daily returns from Tick Data for S&P500 as for the MF2-GARCH estimation from August 15, 1969 onwards. 
* [CBOE Volatility Index (VIX) from FRED](https://fred.stlouisfed.org/series/VIXCLS) VIXCLS.xls  
* [Bauer et al. (2023). Risk Appetite and the Risk-Taking Channel of Monetary Policy](https://www.michaeldbauer.com/files/risk_index.xlsx) bauer_risk_index.xlsx
* CBOE/CBOT 10-year U.S. Treasury Note Volatility (TYVIXSM), retrieved from Bloomberg Terminal 
* MOVE Index, retrieved from Bloomberg Terminal to be saved as Bloomberg_additional_indicators.xlsx 
* Credit Spread (Spread between moodys corporate bond A index yield and the us gov 10 year yield), retrieved from Bloomberg Terminal  Credit spread.xlsx (sheet “BASPCAAA Index”)
* [10-year Treasury yields minus 3-month Treasury bill rates, retrieved from FRED](https://fred.stlouisfed.org/series/T10Y3M) TYVIX.xlsx
* CPIAUCSL.xlsx (?)
* Bloomberg_futures.xlsx (sheet “2Y Treasury future”) → ⇒ TreasuryFut2yVolaForecasts6.dta
* Bloomberg_futures.xlsx (sheet “5Y Treasury future”) → ⇒ TreasuryFut5yVolaForecasts6.dta
* Bloomberg_futures.xlsx (sheet “10Y Treasury future”) → ⇒ TreasuryFut10YVolaForecasts6.dta 
* Bloomberg_futures.xlsx (sheet “3M EURODOLLAR”) → ⇒ EurodollarForecasts6.dta
* T10Y3M.xls (FRED, sheet “FRED Graph”, A11:B11208) → ⇒ YieldCurveSlope.dta
* USAGDPDEFQISMEI.xlsx (sheet “Quarterly”) → ⇒ GDPDeflator.dta
* USAGDPDEFQISMEI.xlsx (?) GDP Deflator?
* 3-Month Treasury Bill Deflated by Same-Quarter CPI Inflation (RR1_TBILL_CPI)  Source: https://www.philadelphiafed.org/surveys-and-data/rr1_tbill_cpi Tbill3M.xlsx 
* FOMCMeetings.xlsx (sheet “Tabelle1”) → ⇒ FOMC.dta
* ECBPress.xlsx → ⇒ ECBPress.dta 

After running _2025_10_23_1_Import_Dataset.do_ in Stata, you can run the main analysis using _2025_10_23_Empirical Analysis.do_. The latter file produces all the tables and figures from the paper. 

## Contact 
Please address any questions about the code to:

* Christian Conrad, Heidelberg University, Department of Economics. Email: christian.conrad [at] awi.uni-heidelberg.de
* Julius Schoelkopf, Heidelberg University, Department of Economics. Email: julius.schoelkopf [at] awi.uni-heidelberg.de

We do not assume any responsibilities for results produced with the available code. 

## Software 
The codes have been written in Matlab (R2021b - R2025b, 64-bit macOS) and StataMP (version 16.0 - 18.0 for Apple Silicon) on macOS Sequoia (15.5, M2). 
