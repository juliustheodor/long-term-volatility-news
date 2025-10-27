# Replication files for Conrad, C., Schoelkopf, J., Tushteva, N. (2025) "Long-Term Volatility Shapes the Stock Market’s Sensitivity to News", Journal of Econometrics




Please cite as:

> Conrad, Christian and Schoelkopf, Julius Theodor and Tushteva, Nikoleta, Long-Term Volatility Shapes the Stock Market's Sensitivity to News (2025, first version 2023). Available at SSRN: http://dx.doi.org/10.2139/ssrn.4632733.


## Data sets needed

While the high-frequency return data (purchased from TickData) and the announcements data (purchased from Bloomberg Forecasts) used in our paper are proprietary and redistribution is not permitted, we cannot include the data in this repository. 

The different datasets needed can be found here:
* Bloomberg Forecasts: Bloomberg Terminal
* High-frequency Return Data: TickData e_miniESfront_07_15_2022_07_03.csv and e_miniESfront_08_45_2022_07_04.csv
* EURO_8_45_XX.csv and EURO_7_15_XX.csv

#### Control Variables (for Table 5 and A.3, A.5, A.6, A.13 and Figure A.3)  
* FOMC sentiment index ([Gardner et al. (2022)](https://www.sciencedirect.com/science/article/pii/S0304407621002530)): obtained from the authors (sentiment_dec2020.xlsx)
* [CBO Real Output Gap, retrieved from FRED](https://fred.stlouisfed.org/graph/?g=f1cZ) 
* From the [Philadelphia FED Survey of Professional Forecasters](https://www.philadelphiafed.org/surveys-and-data/real-time-data-research/survey-of-professional-forecasters): Tbill3M.xlsx
* [Husted et al. (2025) Monetary Policy Uncertainty](https://sites.google.com/site/lucasfhusted/data)
* [Macroeconomic Uncertainty (Jurado et al., 2015)](https://www.sydneyludvigson.com/macro-and-financial-uncertainty-indexes) 
* [Chicago Board Options Exchange, CBOE Volatility Index (VIX), retrieved from FRED](https://fred.stlouisfed.org/series/VIXCLS) 
* GJR-GARCH
* Bauer: Michael D. Bauer, Ben S. Bernanke, Eric Milstein (2023). Risk Appetite and the Risk-Taking Channel of Monetary Policy. Journal of Economic Perspectives.
* The CBOE/CBOT 10-year U.S. Treasury Note Volatility IndexSM (ticker symbol TYVIXSM) measures the expected volatility of the price of 10-year Treasury Note futures. Bloomberg
* MOVE Index
* Credit Spread (Spread between moodys corporate bond A index yield and the us gov 10 year yield), retrieved from Bloomberg Terminal 
* [10-year Treasury yields minus 3-month Treasury bill rates, retrieved from FRED](https://fred.stlouisfed.org/series/T10Y3M) 
* CPIAUCSL.xlsx (?)
* USAGDPDEFQISMEI.xlsx (?) GDP Deflator?
* 


## Contact 
Please address any questions about the code to:

* Christian Conrad, Heidelberg University, Department of Economics. Email: christian.conrad [at] awi.uni-heidelberg.de
* Julius Schoelkopf, Heidelberg University, Department of Economics. Email: julius.schoelkopf [at] awi.uni-heidelberg.de

We do not assume any responsibilities for results produced with the available code. Please let us know, if you have suggestions for further versions. 

## Software 
The codes have been written in Matlab (R2021b - R2025b, 64-bit macOS) and StataMP (version 16.0 - 18.0 for Apple Silicon) on macOS Sequoia (15.5, M2). 
