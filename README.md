# Replication files for Conrad, C., Schoelkopf, J., Tushteva, N. (2025) "Long-Term Volatility Shapes the Stock Market’s Sensitivity to News", Journal of Econometrics

Please cite as:

> Conrad, Christian and Schoelkopf, Julius Theodor and Tushteva, Nikoleta, Long-Term Volatility Shapes the Stock Market's Sensitivity to News (2025, first version 2023). Available at SSRN: http://dx.doi.org/10.2139/ssrn.4632733.




## Replication Files

The replication files are provided in a chronological order

1) MF2GARCH_estimation.m (MATLALB) generates MF2-GARCH volatility estimates (conditional volatility, long-term volatility, short-term volatility) used in the analysis 
2) (Stata) Imports data sets and transforms them for the analysis in a stata format and some variable transformations. 
3) (Stata) Generates tables and figures  

The scripts puts the figures of the paper into the folder 'Figures' and the tables into the folder 'Tables'.

## Data sets needed

While the high-frequency return data (purchased from TickData) and the announcements data (purchased from Bloomberg Forecasts) used in our paper are proprietary and redistribution is not permitted, we cannot include the data in this repository. All data must be placed in the folder "raw data" using the correct file names. Please make sure to use the corresponding vintages, when available. The different datasets needed can be found here:

The different datasets needed can be found here:
* Bloomberg Forecasts for macroeconomic announcements: Bloomberg Terminal (Median Forecast, Actual Release, Release Date) 
* High-frequency Return Data from Tick Data for S&P500 E-mini futures, S&P500 and the EuroStoxx 50 (obtained using TickWrite 7 Data Management Software) 
    * e_miniESfront_07_15_2022_07_03.csv to be saved as SPmini830.dta
    * e_miniESfront_08_45_2022_07_04.csv to be saved as SPmini10.dta
    * SP500_index_1983_2021.csv to be saved as SP.dta
    * EURO_7_15_XX.csv to be saved as Eurostoxx830.dta
    * EURO_8_45_XX.csv to be saved as Eurostoxx10.dta
* Daily Returns  from Tick Data for S&P500 for the MF2-GARCH estimation to be saved as SPdailyneu.csv in mf2garch estimation. 

#### Control Variables (for Table 5 and A.3, A.5, A.6, A.13 and Figure A.3)  
* FOMC sentiment index ([Gardner et al. (2022)](https://www.sciencedirect.com/science/article/pii/S0304407621002530)): obtained from the authors 
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
* 3-Month Treasury Bill Deflated by Same-Quarter CPI Inflation (RR1_TBILL_CPI)  Source: https://www.philadelphiafed.org/surveys-and-data/rr1_tbill_cpi 


Volatility / risk
VIXCLS.xls (FRED, sheet “FRED Graph”, range A11:B8621) → ⇒ VIX.dta
TYVIX.xlsx (sheet “TYVIX”) → ⇒ TYVIX.dta
bauer_risk_index.xlsx (sheet “Data”) → ⇒ RiskAppetite.dta
Bloomberg_additional_indicators.xlsx (sheet “MOVE”, A6:B6447) → ⇒ MOVE.dta
Futures-based volatility forecasts
Bloomberg_futures.xlsx (sheet “2Y Treasury future”) → ⇒ TreasuryFut2yVolaForecasts6.dta
Bloomberg_futures.xlsx (sheet “5Y Treasury future”) → ⇒ TreasuryFut5yVolaForecasts6.dta
Bloomberg_futures.xlsx (sheet “10Y Treasury future”) → ⇒ TreasuryFut10YVolaForecasts6.dta (merges in boersenfeiertage.dta)
Bloomberg_futures.xlsx (sheet “3M EURODOLLAR”) → ⇒ EurodollarForecasts6.dta (merges in boersenfeiertage.dta)
Rates / term structure / spreads
T10Y3M.xls (FRED, sheet “FRED Graph”, A11:B11208) → ⇒ YieldCurveSlope.dta
Credit spread.xlsx (sheet “BASPCAAA Index”) → ⇒ SpreadMoodys.dta
Tbill3M.xlsx (sheet “Daily”) → ⇒ TBill3M.dta
Macroeconomic series
USAGDPDEFQISMEI.xlsx (sheet “Quarterly”) → ⇒ GDPDeflator.dta
MacroUncertaintyToCirculate.xlsx (sheet “Macro Uncertainty”) → ⇒ Ludvigson_MacroUncert.dta
CBOGap.xls (FRED, sheet “FRED Graph”, A11:B311) → ⇒ GapBEA.dta
Policy / sentiment / events
sentiment_dec2020.xlsx (sheet “Data”) → ⇒ sentiment.dta
FOMCMeetings.xlsx (sheet “Tabelle1”) → ⇒ FOMC.dta
mpu.csv → ⇒ MPUBauer2.dta
HRS_MPU_monthly-4.xlsx (sheet “Sheet1”) → ⇒ HRSMPU2.dta
ECBPress.xlsx → ⇒ ECBPress.dta
Model inputs
GJR_EW.xlsx (sheet “Sheet1”) → ⇒ GJREW.dta
MF2optimalBICChoiceEWMatrix20240326Deltatau.xlsx (sheet “Sheet1”) → ⇒ MF2optimalBICinmean.dta

After running _2025_10_23_1_Import_Dataset.do_ in Stata, you can run the main analysis using _2025_10_23_Empirical Analysis.do_. The latter file produces all the tables and figures from the paper. 


## Contact 
Please address any questions about the code to:

* Christian Conrad, Heidelberg University, Department of Economics. Email: christian.conrad [at] awi.uni-heidelberg.de
* Julius Schoelkopf, Heidelberg University, Department of Economics. Email: julius.schoelkopf [at] awi.uni-heidelberg.de

We do not assume any responsibilities for results produced with the available code. 

## Software 
The codes have been written in Matlab (R2021b - R2025b, 64-bit macOS) and StataMP (version 16.0 - 18.0 for Apple Silicon) on macOS Sequoia (15.5, M2). 
