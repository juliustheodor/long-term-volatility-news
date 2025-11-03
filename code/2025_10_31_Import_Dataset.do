* Long-term volatility shapes the stock market's sensitivity to news 
* Replication Package for the Journal of Econometrics 
* October 31, 2025 
* Link to Read-Me File: https://github.com/juliustheodor/long-term-volatility-news

clear all
set more off

* Set directory 
if "`c(username)'" == "schoelkopf"{
global user "/Users/schoelkopf/Dropbox/PhD/Announcements/Replication Package JoE"
}
else{
					if "`c(username)'" == "bb451"{
						global user "/Users/bb451/Dropbox/PhD/Announcements/Replication Package JoE" 
				}
			}

*******************************************************************************
*        	   Import Announcement Data from Bloomberg 
*******************************************************************************

cd "$user/raw data"	

matrix E=J(18,10,.)
local i=1 //row index

import excel using Bloomberg2023.xlsx, describe
local n_sheets `r(N_worksheet)'
forvalues i=1/`n_sheets' {
	import excel using Bloomberg2023.xlsx, describe
	disp `i'
	local sheet`i' `r(worksheet_`i')'
} 	
* loop through all sheets
forvalues i=1/`n_sheets' {
	disp `i'
    import excel using Bloomberg2023.xlsx, sheet(`sheet`i'') firstrow clear
    global Indicator = B[3]
	display "$Indicator" 
	
	import excel using Bloomberg2023.xlsx, sheet(`sheet`i'') firstrow clear  cellrange(A6) 
	drop in 1 
	keep ECO_RELEASE_DT BN_SURVEY_MEDIAN ACTUAL_RELEASE
	rename ECO_RELEASE_DT ReleaseDate
	rename BN_SURVEY_MEDIAN MedianSurvey
	rename ACTUAL_RELEASE Actual


	tostring ReleaseDate, replace
	replace ReleaseDate="." if ReleaseDate =="#N/A N/A" 
	destring ReleaseDate, replace
	
	
	tostring MedianSurvey, replace
	tostring Actual, replace
	replace MedianSurvey="." if MedianSurvey=="--"
	replace Actual="." if Actual=="--"
	replace MedianSurvey="." if MedianSurvey =="#N/A N/A" 
	replace Actual="." if Actual =="#N/A N/A" 
	destring MedianSurvey, replace
	destring Actual, replace 
	drop if MedianSurvey ==. 
	drop if Actual ==. 
	drop if ReleaseDate ==. 
	 
	gen $Indicator = Actual - MedianSurvey
	

	gen zeroevent_$Indicator = 0
	replace zeroevent_$Indicator = 1 	if $Indicator == 0
	

	tostring ReleaseDate, replace
	replace ReleaseDate = subinstr(ReleaseDate, " ", "", .)
	
	gen day = substr(ReleaseDate, 7,2) 
	gen month = substr(ReleaseDate, 5,2)
	gen year = substr(ReleaseDate, 1,4) 
	
	replace month = subinstr(month, "/", "",.)
	replace day = subinstr(day, "/", "",.)
	
	destring day, replace
	destring year, replace
	destring month, replace 

	gen date = mdy(month, day, year)
	format date %td
	
	drop if year > 2023
	drop if year < 1997

	drop ReleaseDate 
	drop if $Indicator ==. 
	

	gen E_$Indicator = 1 

	
	
	rename Actual A_$Indicator
	rename MedianSurvey M_$Indicator


	save "$user/merged data/announcements/$Indicator.dta", replace 

	
}

**********************************************************************************
* Import Intra-Day S&P 500 E-Mini Data (from TickData)
**********************************************************************************

/*
Loads a CSV of E-mini S&P 500 front-month data, reshapes minute prices around 
8:30 am EST (7:30 am Chicago Time), and computes log returns 
over 1, 2, 5, 10, and 15-minute windows around 8:30 am .
*/

import delimited "$user/raw data/e_miniESfront_07_15_2022_07_03.csv", clear 
keep date time close 
gen day = substr(date, 4,2)  
gen month = substr(date, 1,2)
gen year = substr(date, -4,4) 
destring day, replace
destring year, replace
destring month, replace 
drop date
gen date = mdy(month, day, year)
format date %td
gen double wanted = clock(time, "hm") 
format wanted %tc_HH:MM


gen t_mini =. 
replace t_mini  = 15 if time == "07:15"
replace t_mini  = 16 if time == "07:16"
replace t_mini  = 17 if time == "07:17"
replace t_mini  = 18 if time == "07:18"
replace t_mini  = 19 if time == "07:19"
replace t_mini  = 20 if time == "07:20"
replace t_mini  = 21 if time == "07:21"
replace t_mini  = 22 if time == "07:22"
replace t_mini  = 23 if time == "07:23"
replace t_mini  = 24 if time == "07:24"
replace t_mini  = 25 if time == "07:25"
replace t_mini  = 26 if time == "07:26"
replace t_mini  = 27 if time == "07:27"
replace t_mini  = 28 if time == "07:28"
replace t_mini  = 29 if time == "07:29"
replace t_mini  = 30 if time == "07:30"

replace t_mini  = 45 if time == "07:45"
replace t_mini  = 44 if time == "07:44"
replace t_mini  = 43 if time == "07:43"
replace t_mini  = 42 if time == "07:42"
replace t_mini  = 41 if time == "07:41"
replace t_mini  = 40 if time == "07:40"
replace t_mini  = 39 if time == "07:39"
replace t_mini  = 38 if time == "07:38"
replace t_mini  = 37 if time == "07:37"
replace t_mini  = 36 if time == "07:36"
replace t_mini  = 35 if time == "07:35"
replace t_mini  = 34 if time == "07:34"
replace t_mini  = 33 if time == "07:33"
replace t_mini  = 32 if time == "07:32"
replace t_mini  = 31 if time == "07:31"

drop time wanted

rename close emini830_
reshape wide emini830_, i(date) j(t_mini)
quietly gen rm83emini=100*(ln(emini830_35)- ln(emini830_25))

quietly gen rm83emini10min=100*(ln(emini830_40)- ln(emini830_20))
quietly gen rm83emini15min=100*(ln(emini830_45)- ln(emini830_15))
quietly gen rm83emini1min=100*(ln(emini830_31)- ln(emini830_29))
quietly gen rm83emini2min=100*(ln(emini830_32)- ln(emini830_28))
save "$user/merged data/SPmini830.dta", replace 

**
/*
Loads a CSV of E-mini S&P 500 front-month data, reshapes minute prices around 
10:00 am EST (9:00 am Chicago Time), and computes log returns 
over 1, 2, 5, 10, and 15-minute windows around 10:00 am.
*/

import delimited "$user/raw data/e_miniESfront_08_45_2022_07_04.csv", clear 
keep date time close 
gen day = substr(date, 4,2)  
gen month = substr(date, 1,2)
gen year = substr(date, -4,4) 
destring day, replace
destring year, replace
destring month, replace 
drop date
gen date = mdy(month, day, year)
format date %td
gen double wanted = clock(time, "hm") 
format wanted %tc_HH:MM

gen t =. 
replace t  = 31 if time == "08:31"
replace t  = 45 if time == "08:45"
replace t  = 46 if time == "08:46"
replace t  = 47 if time == "08:47"
replace t  = 48 if time == "08:48"
replace t  = 49 if time == "08:49"
replace t  = 50 if time == "08:50"
replace t  = 51 if time == "08:51"
replace t  = 52 if time == "08:52"
replace t  = 53 if time == "08:53"
replace t  = 54 if time == "08:54"
replace t  = 55 if time == "08:55"
replace t  = 56 if time == "08:56"
replace t  = 57 if time == "08:57"
replace t  = 58 if time == "08:58"
replace t  = 59 if time == "08:59"
replace t  = 00 if time == "09:00"

replace t  = 1 if time == "09:01"
replace t  = 2 if time == "09:02"
replace t  = 3 if time == "09:03"
replace t  = 4 if time == "09:04"
replace t  = 5 if time == "09:05"
replace t  = 6 if time == "09:06"
replace t  = 7 if time == "09:07"
replace t  = 8 if time == "09:08"
replace t  = 9 if time == "09:09"
replace t  = 10 if time == "09:10"
replace t  = 11 if time == "09:11"
replace t  = 12 if time == "09:12"
replace t  = 13 if time == "09:13"
replace t  = 14 if time == "09:14"
replace t  = 15 if time == "09:15"
replace t  = 29 if time == "09:29"

drop if t==. 

drop time wanted

rename close emini10_
reshape wide emini10_ , i(date) j(t)

quietly gen rm10emini=100*(ln(emini10_5)- ln(emini10_55)) 

quietly gen rm10emini15min=100*(ln(emini10_15)- ln(emini10_45)) 
quietly gen rm10emini10min=100*(ln(emini10_10)- ln(emini10_50)) 
quietly gen rm10emini1min=100*(ln(emini10_1)- ln(emini10_59)) 
quietly gen rm10emini2min=100*(ln(emini10_2)- ln(emini10_58)) 

save "$user/merged data/SPmini10.dta", replace 


**********************************************************************************
* Import Intra-Day S&P 500 Data (from TickData) 
**********************************************************************************

import delimited "$user/raw data/SP500_index_1983_2021.csv", clear 
keep date time close
gen day = substr(date, 4,2)  
gen month = substr(date, 1,2)
gen year = substr(date, -4,4) 
destring day, replace
destring year, replace
destring month, replace 
drop date
gen date = mdy(month, day, year)
format date %td
gen double wanted = clock(time, "hm") 
format wanted %tc_HH:MM

drop if year < 1998

gen t =. 
replace t  = 31 if time == "08:31"
replace t  = 46 if time == "08:46"
replace t  = 47 if time == "08:47"
replace t  = 48 if time == "08:48"
replace t  = 49 if time == "08:49"
replace t  = 50 if time == "08:50"
replace t  = 51 if time == "08:51"
replace t  = 52 if time == "08:52"
replace t  = 53 if time == "08:53"
replace t  = 54 if time == "08:54"
replace t  = 55 if time == "08:55"
replace t  = 56 if time == "08:56"
replace t  = 57 if time == "08:57"
replace t  = 58 if time == "08:58"
replace t  = 59 if time == "08:59"
replace t  = 00 if time == "09:00"

replace t  = 1 if time == "09:01"
replace t  = 2 if time == "09:02"
replace t  = 3 if time == "09:03"
replace t  = 4 if time == "09:04"
replace t  = 5 if time == "09:05"
replace t  = 6 if time == "09:06"
replace t  = 7 if time == "09:07"
replace t  = 8 if time == "09:08"
replace t  = 9 if time == "09:09"
replace t  = 10 if time == "09:10"
replace t  = 11 if time == "09:11"
replace t  = 12 if time == "09:12"
replace t  = 13 if time == "09:13"
replace t  = 14 if time == "09:14"
replace t  = 15 if time == "09:15"
replace t  = 29 if time == "09:29"

drop if t==. 

drop time wanted

rename close close_SP 
reshape wide close_SP , i(date) j(t)


quietly gen rm1010min=100*(ln(close_SP10)- ln(close_SP50)) 
quietly gen rm105min=100*(ln(close_SP5)- ln(close_SP55)) 
quietly gen rm101min=100*(ln(close_SP1)- ln(close_SP59)) 

save "$user/merged data/SP.dta", replace
 
 
**********************************************************************************
* Import Intra-Day Euro Stoxx 50 Data (from TickData)
**********************************************************************************

cd "$user/raw data"	


**** 8:30 am 

import delimited "$user/raw data/EURO_7_15_XX.csv", clear 

keep date time close 
gen day = substr(date, 4,2)  
gen month = substr(date, 1,2)
gen year = substr(date, -4,4) 
destring day, replace
destring year, replace
destring month, replace 
drop date
gen date = mdy(month, day, year)
format date %td
gen double wanted = clock(time, "hm") 
format wanted %tc_HH:MM


gen t_stoxx =. 
replace t_stoxx  = 16 if time == "07:16"
replace t_stoxx  = 17 if time == "07:17"
replace t_stoxx  = 18 if time == "07:18"
replace t_stoxx  = 19 if time == "07:19"
replace t_stoxx  = 20 if time == "07:20"
replace t_stoxx  = 21 if time == "07:21"
replace t_stoxx  = 22 if time == "07:22"
replace t_stoxx  = 23 if time == "07:23"
replace t_stoxx  = 24 if time == "07:24"
replace t_stoxx  = 25 if time == "07:25"
replace t_stoxx  = 26 if time == "07:26"
replace t_stoxx  = 27 if time == "07:27"
replace t_stoxx  = 28 if time == "07:28"
replace t_stoxx  = 29 if time == "07:29"
replace t_stoxx  = 30 if time == "07:30"

replace t_stoxx  = 45 if time == "07:45"
replace t_stoxx  = 44 if time == "07:44"
replace t_stoxx  = 43 if time == "07:43"
replace t_stoxx  = 42 if time == "07:42"
replace t_stoxx  = 41 if time == "07:41"
replace t_stoxx  = 40 if time == "07:40"
replace t_stoxx  = 39 if time == "07:39"
replace t_stoxx  = 38 if time == "07:38"
replace t_stoxx  = 37 if time == "07:37"
replace t_stoxx  = 36 if time == "07:36"
replace t_stoxx  = 35 if time == "07:35"
replace t_stoxx  = 34 if time == "07:34"
replace t_stoxx  = 33 if time == "07:33"
replace t_stoxx  = 32 if time == "07:32"
replace t_stoxx  = 31 if time == "07:31"

drop time wanted

rename close eurostoxx830_
reshape wide eurostoxx830_, i(date) j(t_stoxx)

quietly gen rm83eurostoxx5min=100*(ln(eurostoxx830_35)- ln(eurostoxx830_25))
quietly gen rm83eurostoxx10min=100*(ln(eurostoxx830_40)- ln(eurostoxx830_20))
quietly gen rm83eurostoxx1min=100*(ln(eurostoxx830_31)- ln(eurostoxx830_29))


save "$user/merged data/Eurostoxx830.dta", replace 


****** 10:00 am 

import delimited "$user/raw data/EURO_8_45_XX.csv", clear 

keep date time close 
gen day = substr(date, 4,2)  
gen month = substr(date, 1,2)
gen year = substr(date, -4,4) 
destring day, replace
destring year, replace
destring month, replace 
drop date
gen date = mdy(month, day, year)
format date %td
gen double wanted = clock(time, "hm") 
format wanted %tc_HH:MM

gen t_stoxx =. 

gen t =. 
replace t  = 46 if time == "08:46"
replace t  = 47 if time == "08:47"
replace t  = 48 if time == "08:48"
replace t  = 49 if time == "08:49"
replace t  = 50 if time == "08:50"
replace t  = 51 if time == "08:51"
replace t  = 52 if time == "08:52"
replace t  = 53 if time == "08:53"
replace t  = 54 if time == "08:54"
replace t  = 55 if time == "08:55"
replace t  = 56 if time == "08:56"
replace t  = 57 if time == "08:57"
replace t  = 58 if time == "08:58"
replace t  = 59 if time == "08:59"
replace t  = 00 if time == "09:00"

replace t  = 1 if time == "09:01"
replace t  = 2 if time == "09:02"
replace t  = 3 if time == "09:03"
replace t  = 4 if time == "09:04"
replace t  = 5 if time == "09:05"
replace t  = 6 if time == "09:06"
replace t  = 7 if time == "09:07"
replace t  = 8 if time == "09:08"
replace t  = 9 if time == "09:09"
replace t  = 10 if time == "09:10"
replace t  = 11 if time == "09:11"
replace t  = 12 if time == "09:12"
replace t  = 13 if time == "09:13"
replace t  = 14 if time == "09:14"
replace t  = 15 if time == "09:15"
*replace t  = 29 if time == "09:29"


drop if t==. 

drop time wanted

rename close eurostoxx10_
reshape wide eurostoxx10_, i(date) j(t)

quietly gen rm10eurostoxx5min=100*(ln(eurostoxx10_5)- ln(eurostoxx10_55))
quietly gen rm10eurostoxx10min=100*(ln(eurostoxx10_10)- ln(eurostoxx10_50))
quietly gen rm10eurostoxx1min=100*(ln(eurostoxx10_1)- ln(eurostoxx10_59))

save "$user/merged data/Eurostoxx10.dta", replace 


**********************************************************************************
* Import VIX (from FRED) 
**********************************************************************************

* VIX measures market expectation of near term volatility conveyed by stock index option prices. Copyright, 2016, Chicago Board Options Exchange, Inc. Reprinted with permission.
* Chicago Board Options Exchange, CBOE Volatility Index: VIX [VIXCLS], retrieved from FRED, 
* Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/VIXCLS, February 23, 2023.

cd "$user/raw data"	

import excel "$user/raw data/VIXCLS.xls", sheet("FRED Graph") cellrange(A11:B8621) firstrow clear 
rename observation_date date
rename VIXCLS VIX

tsset date 
replace VIX = L.VIX if VIX == 0

gen L_VIX = L.VIX
replace L_VIX = L2.VIX if L_VIX == . 
replace L_VIX = L3.VIX if L_VIX == . 
replace L_VIX = L4.VIX if L_VIX == . 
replace L_VIX = L5.VIX if L_VIX == . 
replace L_VIX = L6.VIX if L_VIX == . 

gen year=year(date) 
drop if year < 1998
drop year 
save "$user/merged data/VIX.dta", replace 


**********************************************************************************
* Import FOMC Sentiment from Gardner et al. (2022)
**********************************************************************************

import excel "$user/raw data/sentiment_dec2020.xlsx", sheet("Data") firstrow clear
rename monetary sentiment_monetary 
rename inflation sentiment_inflation
rename labor sentiment_labor
rename output sentiment_output
rename financial  sentiment_financial
rename all sentiment
drop if date <= td(19dec2000)
save "$user/merged data/sentiment.dta", replace
 

**********************************************************************************
* Import GJR GARCH forecasts 
**********************************************************************************
 
import excel "$user/raw data/GJR_EW.xlsx", sheet("Sheet1") firstrow clear
rename Var1 year
rename Var2 month
rename Var3 day 
rename Matrix Sigma_GJR_EW

save "$user/merged data/GJREW.dta", replace


**********************************************************************************
* Import Macroeconomic Uncertainty from Jurado et al. (2015)
**********************************************************************************

import excel "$user/raw data/MacroUncertaintyToCirculate.xlsx", sheet("Macro Uncertainty") firstrow clear
gen year= year(Date)
gen month = month(Date)

rename h1 MacroUncertaintyh1 
rename h12 MacroUncertaintyh12 

gen L_MacroUncertaintyh1 =MacroUncertaintyh1[_n-1]
gen L_MacroUncertaintyh12 =MacroUncertaintyh12[_n-1] 


drop h3 

drop Date 
save "$user/merged data/Ludvigson_MacroUncert.dta", replace
 

 
**********************************************************************************
* Import CBO Output Gap from FRED
**********************************************************************************

import excel "$user/raw data/CBOGap.xls", sheet("FRED Graph") cellrange(A11:B311) firstrow clear	

sort observation_date
gen t=_n 
tsset t 
gen L_Gap_BEA  = L.GDPC1_GDPPOT

gen year = year(observation_date)
drop if year < 2001
drop if year > 2022
gen quarter = quarter(observation_date)
drop t  observation_date	 GDPC1_GDPPOT
gen yq =yq(year, quarter)
format yq %tq
save "$user/merged data/GapBEA.dta", replace
	
**********************************************************************************
* Imprt Risk Index from Bauer et al. (2023)
**********************************************************************************

import excel "$user/raw data/bauer_risk_index.xlsx", sheet("Data") firstrow clear

 gen year= year(date)
 gen day = day(date)
 gen month = month(date)

 
 tsset date 
 gen L_risk_index = L.index
 replace L_risk_index = L.L_risk_index  if L_risk_index==.
 replace L_risk_index = L2.L_risk_index  if L_risk_index==.
  replace L_risk_index = L3.L_risk_index  if L_risk_index==.
   replace L_risk_index = L4.L_risk_index  if L_risk_index==.
      replace L_risk_index = L5.L_risk_index  if L_risk_index==.
	  
	  
drop if year < 2000 
drop date 
	
save "$user/merged data/RiskAppetite.dta", replace

**********************************************************************************
* Import Altavilla Database for ECB monetary policy decision day 
**********************************************************************************

import excel "$user/raw data/ECBPress.xlsx", firstrow clear 
save "$user/merged data/ECBPress.dta", replace


/*
import excel "$user/raw data/MOVE.xlsx", sheet("Tabelle1") firstrow clear
drop Vol Change 

gen month = substr(Date, 1,3 )
gen day = substr(Date, 5,2 )
destring day, replace 
gen year = substr(Date, 9,4)
destring year, replace 

generate month_num = .
replace month_num = 1 if month == "Jan"
replace month_num = 2 if month == "Feb"
replace month_num = 3 if month == "Mar"
replace month_num = 4 if month == "Apr"
replace month_num = 5 if month == "May"
replace month_num = 6 if month == "Jun"
replace month_num = 7 if month == "Jul"
replace month_num = 8 if month == "Aug"
replace month_num = 9 if month == "Sep"
replace month_num = 10 if month == "Oct"
replace month_num = 11 if month == "Nov"
replace month_num = 12 if month == "Dec"

drop month High Low
rename month_num month 

destring Price, replace 
destring Open, replace 

drop Date 

rename Price MOVE_price 
rename Ope MOVE_open 


gen date = mdy(month, day, year)
format date %td

sort date
tsset date

gen MOVE_price_lag = l.MOVE_price 
gen MOVE_open_lag = l.MOVE_open


*******
drop if year > 2021
drop  if year < 2001
******

save "$user/merged data/MOVE2.dta", replace 
*/ 

**********************************************************************************
* Import 10-year Treasury yields minus 3-month Treasury bill rates from FRED
**********************************************************************************

import excel "$user/raw data/T10Y3M.xls", sheet("FRED Graph") cellrange(A11:B11208) firstrow clear

rename observation_date date
tsset date 

rename T10Y3M yield_curve_slope 
gen yield_curve_slope_lag = L.yield_curve_slope

gen year = year(date)
drop if year > 2021
drop  if year < 2001

drop year 

save "$user/merged data/YieldCurveSlope.dta", replace 


**********************************************************************************
* Import Credit spread from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Credit spread.xlsx", sheet("BASPCAAA Index") firstrow clear
drop descriptionUScorporateaaa710 D C
rename LetzterKurs CreditSpreadA10Y
label var CreditSpreadA10Y "Spread between moodys corporate bond A index yield and the us gov 10 year yield"
destring CreditSpreadA10Y, replace dpcomma 

rename Date date
gen year = year(date)
tsset date
gen lag_CreditSpreadA10Y  = L.CreditSpreadA10Y 
replace lag_CreditSpreadA10Y  = L2.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L3.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L4.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L5.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 

drop if year > 2021
drop  if year < 2001
drop year 

save "$user/merged data/SpreadMoodys.dta", replace 


**********************************************************************************
* Import GDP deflator from FRED
**********************************************************************************
import excel "$user/raw data/USAGDPDEFQISMEI.xlsx", sheet("Quarterly") firstrow clear

gen year = year(observation_date)
gen month = month(observation_date)
gen qdate = qofd(observation_date)
format qdate %tq
tsset qdate

* In Elenev et al. Inflation is log changes in the GDP deflator
gen inf_q_gdpdefl = 100 * (log(USAGDPDEFQISMEI) - log(L.USAGDPDEFQISMEI))
gen inf_yoy_gdpdefl = 100 * (log(USAGDPDEFQISMEI) - log(L4.USAGDPDEFQISMEI))

gen l_inf_q_gdpdefl = L.inf_q_gdpdefl
gen l_inf_yoy_gdpdefl = L.inf_yoy_gdpdefl

drop if year > 2021
drop  if year < 2001

gen quarter =.
replace quarter = 1 if month ==1 
replace quarter = 1 if month ==2 
replace quarter = 1 if month ==3 
replace quarter = 2 if month ==4 
replace quarter = 2 if month ==5 
replace quarter = 2 if month ==6 
replace quarter = 3 if month ==7 
replace quarter = 3 if month ==8 
replace quarter = 3 if month ==9 
replace quarter = 4 if month ==10 
replace quarter = 4 if month ==11
replace quarter = 4 if month ==12

save "$user/merged data/GDPDeflator.dta", replace 


**********************************************************************************
* Import MOVE Index from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Bloomberg_additional_indicators.xlsx", sheet("MOVE") cellrange(A6:B6447) firstrow clear

rename PX_LAST Move_Last 
rename Dates date

gen year = year(date)
drop if year > 2021
drop  if year < 2000

drop year 


save "$user/merged data/MOVE.dta", replace 

**********************************************************************************
* Import TYVIX (CBOE/CBOT 10-year U.S. Treasury Note Volatility (TYVIXSM),
* retrieved from Bloomberg Terminal (ticker symbol TYVIXSM)) 
**********************************************************************************

* The CBOE/CBOT 10-year U.S. Treasury Note Volatility Index provides a measure of 
* expected volatility specific to the fixed income market. The index is calculated 
* from BOT's options on 10-year Treasury futures using the same methodology as VIX. 
* Discontinued 18 May 2020.

import excel "$user/raw data/TYVIX.xlsx", sheet("TYVIX") firstrow clear
rename LetzterKurs TYVIX 
rename Date date 
label var TYVIX "10-year U.S. Treasury Note Volatility Index"

destring TYVIX, replace dpcomma 
gen year = year(date)
drop if year > 2021
drop  if year < 2001

drop year 
save "$user/merged data/TYVIX.dta", replace 


**********************************************************************************
* Import MF2-GARCH volatility forecasts 
**********************************************************************************

import excel "$user/mf2garch estimation/MF2optimalBICChoiceEWMatrix20240326Deltatau.xlsx", sheet("Sheet1") firstrow clear 
//MF2EW126.xlsx
rename Var1 year
rename Var2 month
rename Var3 day 
rename Matrix_1 htau_BIC
rename Matrix_2 tau_BIC
rename Matrix_3 h_BIC
rename Matrix_4 annualizedvola_BIC
rename Matrix_5 BIC 

gen date = mdy(month, day, year)
format date %td
	
save "$user/merged data/MF2optimalBICinmean.dta", replace


**********************************************************************************
* Import list of FOMC meetings 
**********************************************************************************

import excel "$user/raw data/FOMCMeetings.xlsx", sheet("Tabelle1") firstrow clear 
drop Date 
save "$user/merged data/FOMC.dta", replace



**********************************************************************************
* Import interest rate forecasts from the SPF 
**********************************************************************************

* 3-Month Treasury Bill Deflated by Same-Quarter CPI Inflation (RR1_TBILL_CPI) 
* Source: https://www.philadelphiafed.org/surveys-and-data/rr1_tbill_cpi 

import excel "$user/raw data/Mean_RR1_TBILL_CPI.xlsx", firstrow clear
rename YEAR year
rename QUARTER quarter
drop if year < 1997
destring RR1_TBILL_CPI_2, replace
destring RR1_TBILL_CPI_3, replace
destring RR1_TBILL_CPI_4, replace
destring RR1_TBILL_CPI_5, replace
destring RR1_TBILL_CPI_6, replace
rename RR1_TBILL_CPI_2 RR1_TBILL_CPI_2Mean 
rename RR1_TBILL_CPI_3 RR1_TBILL_CPI_3Mean 
rename RR1_TBILL_CPI_4 RR1_TBILL_CPI_4Mean 
rename RR1_TBILL_CPI_5 RR1_TBILL_CPI_5Mean 
rename RR1_TBILL_CPI_6 RR1_TBILL_CPI_6Mean  

gen t=_n
tsset t 
gen L_Tbill3Mean =L.RR1_TBILL_CPI_3 - L.RR1_TBILL_CPI_2
drop t

save "$user/merged data/interestforecastCPIM.dta", replace

**********************************************************************************
* Import Husted et al. (2025) Monetary Policy Uncertainty
**********************************************************************************

import excel "$user/raw data/HRS_MPU_monthly-4.xlsx", sheet("Sheet1") firstrow clear
rename Month date 
gen month = substr(date, 6,2)
gen year = substr(date, 1,4) 
destring year, replace
destring month, replace 
drop date

gen t=_n
tsset t 

gen HRSMPU = L.USMPU 
save "$user/merged data/HRSMPU2.dta", replace


**********************************************************************************
* Import 2Y Treasury Futures from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Bloomberg_futures.xlsx", sheet("2Y Treasury future") firstrow clear
rename px_last treasuryfut_2y 
tsset date 


gen year = year(date)
gen dow = dow(date)

tsset date

* dow == 0 = Sunday 

gen log_price = log(treasuryfut_2y)  - log(L.treasuryfut_2y) 
replace log_price = log(treasuryfut_2y)  - log(L3.treasuryfut_2y) if dow == 1 
replace log_price = log(treasuryfut_2y)  - log(L2.treasuryfut_2y) if log_price == 0  
replace log_price = log(treasuryfut_2y)  - log(L3.treasuryfut_2y) if log_price == 0 
replace log_price = log(treasuryfut_2y)  - log(L4.treasuryfut_2y) if log_price == 0 
replace log_price = log(treasuryfut_2y)  - log(L5.treasuryfut_2y) if log_price == 0 
gen ret = (100 * log_price)^2   

drop if dow == 6
drop if dow == 0

gen t = _n 
tsset t 

gen h = . 
drop in 1
drop in 1
replace h = 0 in 1 
replace h = 0.03 * L.ret  + 0.97* L.h if t > 3

rename h emwa_2ytf 

drop if year > 2021
drop  if year < 2001

drop year 


save "$user/merged data/TreasuryFut2yVolaForecasts6.dta", replace 


**********************************************************************************
* Import 10Y Treasury Futures from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Bloomberg_futures.xlsx", sheet("10Y Treasury future") firstrow clear
rename px_last treasuryfut_10y 
tsset date 


gen year = year(date)
gen dow = dow(date)

merge 1:1 date using "$user/raw data/boersenfeiertage.dta", nogen 
drop jahr 

tsset date
drop if year > 2022

drop month 
drop day 

gen public_holiday_lead = l.public_holiday
gen public_holiday_friday = .
replace public_holiday_friday  = l3.public_holiday if dow == 1

gen month = month(date)
gen day = day(date)

* dow == 0 = Sunday 
drop if dow == 6
drop if dow == 0

gen log_price = log(treasuryfut_10y)  - log(L.treasuryfut_10y) 
* Monday after Friday holiday → use L3
replace log_price = log(treasuryfut_10y)  - log(L3.treasuryfut_10y) if dow == 1 

replace log_price = log(treasuryfut_10y)  - log(L2.treasuryfut_10y) if public_holiday_lead == 1 & dow != 1 & dow !=2 
* Tuesday after Monday holiday → use L4
replace log_price = log(treasuryfut_10y)  - log(L4.treasuryfut_10y) if public_holiday_lead == 1 & dow == 2 

* Monday after Friday holiday → use L4
replace log_price = log(treasuryfut_10y)  - log(L4.treasuryfut_10y) if public_holiday_friday == 1 & dow == 1 

replace log_price = log(treasuryfut_10y)  - log(L3.treasuryfut_10y) if month == 12 & day == 27 & dow != 1 & dow !=2  
replace log_price = log(treasuryfut_10y)  - log(L5.treasuryfut_10y) if log_price == . 

gen ret = (100 * log_price)^2   


drop if dow == 6
drop if dow == 0

gen t = _n 
tsset t 

gen h = . 
drop in 1
drop in 1
replace h = 0 in 1 
replace h = 0.03 * L.ret  + 0.97* L.h if t > 3
*replace h = 0.06 * L.ret  + 0.94* L.h if t > 3

gen emwa_10ytf = sqrt(h)

drop if year > 2021
drop  if year < 2001

drop year 


save "$user/merged data/TreasuryFut10YVolaForecasts6.dta", replace 



**********************************************************************************
* Import 5Y Treasury Futures from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Bloomberg_futures.xlsx", sheet("5Y Treasury future") firstrow clear
rename px_last treasuryfut_5y 
tsset date 


gen year = year(date)
gen dow = dow(date)

tsset date

* dow == 0 = Sunday 

gen log_price = log(treasuryfut_5y)  - log(L.treasuryfut_5y) 
replace log_price = log(treasuryfut_5y)  - log(L3.treasuryfut_5y) if dow == 1 
replace log_price = log(treasuryfut_5y)  - log(L2.treasuryfut_5y) if log_price == 0  
replace log_price = log(treasuryfut_5y)  - log(L3.treasuryfut_5y) if log_price == 0 
replace log_price = log(treasuryfut_5y)  - log(L4.treasuryfut_5y) if log_price == 0 
replace log_price = log(treasuryfut_5y)  - log(L5.treasuryfut_5y) if log_price == 0 
gen ret = (100 * log_price)^2   
replace ret = . if ret == 0 

drop if dow == 6
drop if dow == 0

gen t = _n 
tsset t 

gen h = . 
drop in 1
drop in 1
replace h = 0 in 1 
replace h = 0.03 * L.ret  + 0.97* L.h if t > 3

rename h emwa_5ytf 

drop if year > 2021
drop  if year < 2001

drop year 

save "$user/merged data/TreasuryFut5yVolaForecasts6.dta", replace 





**********************************************************************************
* Import 3M Eurodollar Futures from Bloomberg 
**********************************************************************************

import excel "$user/raw data/Bloomberg_futures.xlsx", sheet("3M EURODOLLAR") firstrow clear
rename px_last eurodollarfut_3m 
tsset date 

gen year = year(date)
gen dow = dow(date)

merge 1:1 date using "$user/raw data/boersenfeiertage.dta", nogen 
drop jahr 

tsset date
drop if year > 2022

drop month 
drop day 

gen public_holiday_lead = l.public_holiday
gen public_holiday_friday = .
replace public_holiday_friday  = l3.public_holiday if dow == 1

gen month = month(date)
gen day = day(date)

drop if dow == 6
drop if dow == 0

gen log_price = log(eurodollarfut_3m)  - log(L.eurodollarfut_3m) 
* Monday after Friday holiday → use L3
replace log_price = log(eurodollarfut_3m)  - log(L3.eurodollarfut_3m) if dow == 1 

replace log_price = log(eurodollarfut_3m)  - log(L2.eurodollarfut_3m) if public_holiday_lead == 1 & dow != 1 & dow !=2 
* Tuesday after Monday holiday → use L4
replace log_price = log(eurodollarfut_3m)  - log(L4.eurodollarfut_3m) if public_holiday_lead == 1 & dow == 2 

* Monday after Friday holiday → use L4
replace log_price = log(eurodollarfut_3m)  - log(L4.eurodollarfut_3m) if public_holiday_friday == 1 & dow == 1 

replace log_price = log(eurodollarfut_3m)  - log(L3.eurodollarfut_3m) if month == 12 & day == 27 & dow != 1 & dow !=2  
replace log_price = log(eurodollarfut_3m)  - log(L5.eurodollarfut_3m) if log_price == .  


winsor2 log_price, cut(0 99) replace 
gen ret = (100 * log_price)^2   


drop in 1
drop in 1

gen t = _n 
tsset t 

gen h = . 
drop in 1
drop in 1
replace h = 0 in 1 
replace h = 0.03 * L.ret  + 0.97* L.h if t > 3


gen emwa_eurodollar = sqrt(h)

drop if year > 2021
drop  if year < 2001

drop year 

keep date eurodollarfut_3m emwa_eurodollar

save "$user/merged data/EurodollarForecasts6.dta", replace 


**********************************************************************************
* Import 3M TBill rates from FRED
**********************************************************************************

import excel "$user/raw data/Tbill3M.xlsx", sheet("Daily") firstrow clear
rename observation_date date 
tsset date

rename DTB3 TBill3M 

replace TBill3M = L.TBill3M if TBill3M ==. 

gen TBill3M_lag = L.TBill3M
replace TBill3M_lag = L2.TBill3M if TBill3M_lag ==. 
replace TBill3M_lag = L3.TBill3M if TBill3M_lag ==. 
replace TBill3M_lag = L4.TBill3M if TBill3M_lag ==. 
replace TBill3M_lag = L5.TBill3M if TBill3M_lag ==. 


gen year = year(date)
drop if year > 2021
drop  if year < 2001
drop year 
save "$user/merged data/TBill3M.dta", replace 


