* Long-term volatility shapes the stock market's sensitivity to news 
* Replication Package 
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

* Check whether necessary packages are installed 
cap which winsor2
if _rc ssc install winsor2, replace

cap which estout
if _rc ssc install estout, replace


*******************************************************************************
*              Define locals and globals 
*******************************************************************************

local Events= "NFPTCH  CPI RSTAXMOM  TMNOCHNG    NHSLTOT      DGNOCHNG   INJCJC  CONCCONF  NAPMPMI" 
local events830 = "NFPTCH CPI RSTAXMOM    DGNOCHNG  INJCJC"
local events10= "TMNOCHNG NHSLTOT CONCCONF NAPMPMI" 

global events830 "NFPTCH CPI RSTAXMOM    DGNOCHNG  INJCJC"
global events10 "TMNOCHNG NHSLTOT CONCCONF NAPMPMI" 
 
global Sevents= "S_INJCJC S_NFPTCH  S_RSTAXMOM S_NHSLTOT    S_DGNOCHNG S_TMNOCHNG S_CPI  S_CONCCONF  S_NAPMPMI"  

local Sevents= "S_INJCJC S_NFPTCH  S_RSTAXMOM S_NHSLTOT    S_DGNOCHNG S_TMNOCHNG S_CPI  S_CONCCONF  S_NAPMPMI"  
local Sevents830 = " S_INJCJC S_NFPTCH S_RSTAXMOM  S_DGNOCHNG  S_CPI"
local Sevents10= "S_NHSLTOT S_TMNOCHNG S_CONCCONF  S_NAPMPMI" 

global regression "{INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM +{NHSLTOT}* S_NHSLTOT+   {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {CPI}*S_CPI  + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI "
global regressiongood "{INJCJC_good}*S_INJCJC_good + {NFPTCH_good}*S_NFPTCH_good +  {RSTAXMOM_good}*S_RSTAXMOM_good +{NHSLTOT_good}* S_NHSLTOT_good+   {DGNOCHNG_good}* S_DGNOCHNG_good + {TMNOCHNG_good}*S_TMNOCHNG_good + {CPI_good}*S_CPI_good + {CONCCONF_good}*S_CONCCONF_good + {NAPMPMI_good}*S_NAPMPMI_good"
global regressionbad "{INJCJC_bad}*S_INJCJC_bad + {NFPTCH_bad}*S_NFPTCH_bad +  {RSTAXMOM_bad}*S_RSTAXMOM_bad +{NHSLTOT_bad}* S_NHSLTOT_bad+   {DGNOCHNG_bad}* S_DGNOCHNG_bad + {TMNOCHNG_bad}*S_TMNOCHNG_bad + {CPI_bad}*S_CPI_bad + {CONCCONF_bad}*S_CONCCONF_bad + {NAPMPMI_bad}*S_NAPMPMI_bad"

global regressionsquared "{INJCJCSq}*Sq_S_INJCJC + {NFPTCHSq}*Sq_S_NFPTCH +  {RSTAXMOMSq}*Sq_S_RSTAXMOM +{NHSLTOTSq}*Sq_S_NHSLTOT+   {DGNOCHNGSq}*Sq_S_DGNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {CPISq}*Sq_S_CPI  + {CONCCONFSq}*Sq_S_CONCCONF  + {NAPMPMISq}*Sq_S_NAPMPMI "
global regressionzero "{INJCJC}*S_INJCJC_zero + {NFPTCH}*S_NFPTCH_zero +  {RSTAXMOM}*S_RSTAXMOM_zero +{NHSLTOT}* S_NHSLTOT_zero+   {DGNOCHNG}* S_DGNOCHNG_zero + {TMNOCHNG}*S_TMNOCHNG_zero + {CPI}*S_CPI_zero  + {CONCCONF}*S_CONCCONF_zero  + {NAPMPMI}*S_NAPMPMI_zero "

global regression830 "{NFPTCH}*S_NFPTCH  + {CPI}*S_CPI + {RSTAXMOM}*S_RSTAXMOM+   {DGNOCHNG}* S_DGNOCHNG +{INJCJC}*S_INJCJC"
global regression10 " {TMNOCHNG}*S_TMNOCHNG +{NHSLTOT}* S_NHSLTOT  + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI "

global regressionsquared10 "{TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOTSq}*Sq_S_NHSLTOT   + {CONCCONFSq}*Sq_S_CONCCONF  + {NAPMPMISq}*Sq_S_NAPMPMI "
global regressionsquared830 "{NFPTCHSq}*Sq_S_NFPTCH  + {CPISq}*Sq_S_CPI + {RSTAXMOMSq}*Sq_S_RSTAXMOM+   {DGNOCHNGSq}*Sq_S_DGNOCHNG +{INJCJCSq}*Sq_S_INJCJC"

global regression830good "{NFPTCH}*S_NFPTCH_good  + {CPI}*S_CPI_good  + {RSTAXMOM}*S_RSTAXMOM_good +   {DGNOCHNG}* S_DGNOCHNG_good  +{INJCJC}*S_INJCJC_good "
global regression830bad "{NFPTCH_bad}*S_NFPTCH_bad  + {CPI_bad}*S_CPI_bad + {RSTAXMOM_bad}*S_RSTAXMOM_bad+   {DGNOCHNG_bad}* S_DGNOCHNG_bad +{INJCJC_bad}*S_INJCJC_bad"

global regressionsquaredGood "({NFPTCHSq_good}*Sq_S_NFPTCH*S_NFPTCH_goodD  + {CPISq_good}*Sq_S_CPI*S_CPI_goodD  +{RSTAXMOMSq_good}*Sq_S_RSTAXMOM*S_RSTAXMOM_goodD + {DGNOCHNGSq_good}* Sq_S_DGNOCHNG *S_DGNOCHNG_goodD +{INJCJCSq_good}*Sq_S_INJCJC * S_INJCJC_goodD + {TMNOCHNGSq_good}*Sq_S_TMNOCHNG * S_TMNOCHNG_goodD +{NHSLTOTSq_good}* Sq_S_NHSLTOT * S_NHSLTOT_goodD  + {CONCCONFSq_good}*Sq_S_CONCCONF *S_CONCCONF_goodD + {NAPMPMISq_good}*Sq_S_NAPMPMI * S_NAPMPMI_goodD)"

global regressionsquaredsquared "({NFPTCHSq4}*Sq4_S_NFPTCH  + {CPISq4}*Sq4_S_CPI  +{RSTAXMOMSq4}*Sq4_S_RSTAXMOM + {DGNOCHNGSq4}* Sq4_S_DGNOCHNG +{INJCJCSq4}*Sq4_S_INJCJC + {TMNOCHNGSq4}*Sq4_S_TMNOCHNG +{NHSLTOTSq4}* Sq4_S_NHSLTOT  + {CONCCONFSq4}*Sq4_S_CONCCONF  + {NAPMPMISq4}*Sq4_S_NAPMPMI)"
 
global regressionsquaredGood2 "{RSTAXMOMSq_good}*Sq_S_RSTAXMOM*S_RSTAXMOM_goodD  +{INJCJCSq_good}*Sq_S_INJCJC * S_INJCJC_goodD +{NHSLTOTSq_good}* Sq_S_NHSLTOT * S_NHSLTOT_goodD "

global regressionsquared2 " {TMNOCHNGSq}*Sq_S_TMNOCHNG + {CPISq}*Sq_S_CPI  + {CONCCONFSq}*Sq_S_CONCCONF   +   {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {NFPTCHSq}*Sq_S_NFPTCH + {NAPMPMISq}*Sq_S_NAPMPMI"

global eventsRealActivity830 "NFPTCH RSTAXMOM  INJCJC"
global eventsInvestmentCons830 "DGNOCHNG"
global eventsInvestmentCons10 "TMNOCHNG NHSLTOT" 
global eventsForwardlooking10 "CONCCONF NAPMPMI"  

log using "$user/tables/Longtermvolatility.log", replace 

*******************************************************************************
*                    Merge all previously created data sets 
*******************************************************************************

* Set up main data base by using a blank year-month-day sheet from 1997 to 2023
import excel "$user/raw data/datesheet.xlsx", sheet("Sheet1") firstrow clear
sort date
drop if year ==. 
rename date date3 
gen date = mdy(month, day, year)
format date %td
drop date3 

* Merge announcements data from Bloomberg 
cd "$user/merged data/announcements"	
local allfiles2 : dir . files "*.dta"
disp `allfiles2'
foreach file2 in `allfiles2' {
	merge m:1 date using "`file2'", nogen 
}

sort date

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

tsset date 
drop if year < 1998


* Merge S&P 500 Emini Futures Return Data 
merge m:1 date using "$user/merged data/SPmini10.dta", nogen 
merge m:1 date using "$user/merged data/SPmini830.dta", nogen 

* Merge Euro Stoxx 50 return data 
merge m:1 date using "$user/merged data/Eurostoxx10.dta", nogen 
merge m:1 date using "$user/merged data/Eurostoxx830.dta", nogen 

* Merge S&P 500 return data 
merge m:1 date using "$user/merged data/SP.dta", nogen 


* Merge MF2-GARCH forecasts for conditional volatility, long-term and short-term
* volatility (obtained from the corresponding Matlab File)
merge m:1 year month day using "$user/merged data/MF2optimalBICinmean.dta", nogen 

*** Choose the values for MF2 forecasts 
tsset date 
rename htau_BIC htau
rename tau_BIC tau 
rename h_BIC h 
rename annualizedvola_BIC annualizedvola

replace htau = L.htau if htau==.
replace tau = L.tau if tau==. 
replace h = L.h if h==.  

* Square Root 
gen sqrt_tau = sqrt(tau)
gen sqrt_h = sqrt(h) 
gen sqrt_htau_pr = sqrt_h*sqrt_tau
gen sqrt_htau = sqrt(htau) 

**********
drop if year > 2021
drop  if year < 2001
******

* Mean Adjustment 
quietly: summ tau, detail 
gen tau_mean = tau - r(mean) 

quietly: summ h, detail 
gen h_mean = h - r(mean) 

quietly: summ htau, detail 
gen htau_mean =htau - r(mean) 

gen htau_mean_pr = tau_mean*h_mean 

quietly: summ sqrt_htau, detail 
gen htau_mean_sqrt =sqrt_htau - r(mean) 

quietly: summ sqrt_tau, detail 
gen tau_mean_sqrt = sqrt_tau - r(mean) 

quietly: summ sqrt_h, detail 
gen h_mean_sqrt = sqrt_h - r(mean) 

gen htau_mean_sqrt_pr = h_mean_sqrt*tau_mean_sqrt

gen tauL = L.tau_mean_sqrt 

* Labels 
label variable htau  "Conditional volatility" 
label variable h  "short term component"
label variable tau "long term volatility"

*******************************************************************************
* Figure 2:  Plot of the estimated annualized volatility 
*******************************************************************************

preserve 
drop if year > 2021
drop  if year < 2001
* Figure 3
gen annualized_vola = sqrt(252*htau)
gen annualized_tau = sqrt(252*tau)
gen sqrt_h_fig = sqrt(h)


local upper = 120

gen recession = 0 
replace recession = `upper' if year == 2007 & month == 10 
replace recession = `upper' if year == 2007 & month == 11
replace recession = `upper' if year == 2007 & month == 12 
replace recession = `upper' if year == 2008 & month == 1 
replace recession = `upper' if year == 2008 & month == 2 
replace recession = `upper' if year == 2008 & month == 3 
replace recession = `upper' if year == 2008 & month == 4 
replace recession = `upper' if year == 2008 & month == 5 
replace recession = `upper' if year == 2008 & month == 6 
replace recession = `upper' if year == 2008 & month == 7 
replace recession = `upper' if year == 2008 & month == 8 
replace recession = `upper' if year == 2008 & month == 9 
replace recession = `upper' if year == 2008 & month == 10 
replace recession = `upper' if year == 2008 & month == 11
replace recession = `upper' if year == 2008 & month == 12 
replace recession = `upper' if year == 2009 & month == 1 
replace recession = `upper' if year == 2009 & month == 2 
replace recession = `upper' if year == 2009 & month == 3 
replace recession = `upper' if year == 2009 & month == 4 
replace recession = `upper' if year == 2009 & month == 5 
replace recession = `upper' if year == 2009 & month == 6 
replace recession = `upper' if year == 2009 & month == 7 
replace recession = `upper' if year == 2009 & month == 8 
replace recession = `upper' if year == 2009 & month == 9 
replace recession = `upper' if year == 2020 & month == 1 
replace recession = `upper' if year == 2020 & month == 2 
replace recession = `upper' if year == 2020 & month == 3 
replace recession = `upper' if year == 2020 & month == 4 
replace recession = `upper' if year == 2020 & month == 5 
replace recession = `upper' if year == 2020 & month == 6 
replace recession = `upper' if year == 2020 & month == 7 
replace recession = `upper' if year == 2020 & month == 8 
replace recession = `upper' if year == 2020 & month == 9 
replace recession = `upper' if year == 2001 & month == 1 
replace recession = `upper' if year == 2001 & month == 2 
replace recession = `upper' if year == 2001 & month == 3 
replace recession = `upper' if year == 2001 & month == 4 
replace recession = `upper' if year == 2001 & month == 5 
replace recession = `upper' if year == 2001 & month == 6 
replace recession = `upper' if year == 2001 & month == 7 
replace recession = `upper' if year == 2001 & month == 8 
replace recession = `upper' if year == 2001 & month == 9 
replace recession = `upper' if year == 2001 & month == 10 
replace recession = `upper' if year == 2001 & month == 11 
replace recession = `upper' if year == 2001 & month == 12 
label var recession "US recession"
label var date "Date"


twoway (area recession date, lwidth(none none none none) xscale(range(15000 22000)) color(gs14) yaxis(1))  ///
      (tsline sqrt_h_fig, yaxis(2) lcolor(green) lwidth(thin)) ///
      (tsline annualized_vola annualized_tau, yaxis(1) lcolor(red blue) lwidth(medthick medthick)), ///
      legend(position(11) cols(1) ring(0) order(1 "US recession" 2 "Annualized conditional volatility" 3 "Annualized long-term volatility" 4 "Short-term component")) ///
      ytitle("Conditional volatility and long-term volatility", axis(1)) ///
      ytitle("Short-term component", axis(2)) xtitle("")
graph export "$user/figures/Figure_2.png", replace

restore  

* Merge with FOMC sentiment from Gardner et al. (2022)
merge m:1 date using "$user/merged data/sentiment.dta", nogen 

**********
drop  if year < 2001
******

tsset date 
gen L_FOMCsentiment =. 
replace L_FOMCsentiment = L.sentiment 
replace L_FOMCsentiment = L.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 
replace L_FOMCsentiment = F.L_FOMCsentiment if L_FOMCsentiment == . 

summ L_FOMCsentiment, detail 
gen L_FOMCsentiment_mean = (L_FOMCsentiment -r(mean) ) / r(sd)


merge m:1 date using "$user/merged data/VIX.dta", nogen 

******
drop if year > 2021
drop  if year < 2001
******

tsset date
replace L_VIX = L2.VIX if L_VIX == . 
replace L_VIX = L3.VIX if L_VIX == . 
replace L_VIX = L4.VIX if L_VIX == . 

summ L_VIX, detail 
gen L_VIX_mean = L_VIX - r(mean) 

gen VIX2365 = (L_VIX)^2/365 

summ VIX2365, detail 
gen L_VIX2365_mean = VIX2365 - r(mean) 

gen VIX365sqrt = (L_VIX)/sqrt(365) 
summ VIX365sqrt, detail 
gen VIX365sqrt_mean = (VIX365sqrt - r(mean))/r(sd)

merge 1:1 year month day using "$user/merged data/RiskAppetite.dta", nogen 
tsset date 

replace L_risk_index = L.L_risk_index  if L_risk_index==.
replace L_risk_index = L2.L_risk_index  if L_risk_index==.
replace L_risk_index = L3.L_risk_index  if L_risk_index==.
replace L_risk_index = L4.L_risk_index  if L_risk_index==.
replace L_risk_index = L5.L_risk_index  if L_risk_index==.
	  

******
drop if year > 2021
drop  if year < 2001
******

summ L_risk_index, detail 
gen L_risk_index_mean = (L_risk_index - r(mean) ) / r(sd)


merge m:1 year month day using "$user/merged data/GJREW.dta", nogen 

**********
drop if year > 2021
drop  if year < 2001
******

tsset date 
replace Sigma_GJR_EW = L.Sigma_GJR_EW if Sigma_GJR_EW ==. 

gen Sqrt_Sigma_GJR_EW = sqrt(Sigma_GJR_EW)
summarize Sqrt_Sigma_GJR_EW, detail
gen Sqrt_Sigma_GJR_EW_mean = (Sqrt_Sigma_GJR_EW - r(mean)) / r(sd)

merge m:1 year month day using "$user/merged data/FOMC.dta", nogen 
replace FOMC = 0 if FOMC ==. 


merge m:1 year quarter using "$user/merged data/interestforecastCPIM.dta", nogen 

merge m:1 date using "$user/merged data/MPUBauer2.dta", nogen 
tsset date 
replace Lmpu10 = L.Lmpu10 if Lmpu10==. 
replace Lmpu10 = L2.Lmpu10 if Lmpu10==. 
replace Lmpu10 = L3.Lmpu10 if Lmpu10==. 
replace Lmpu10 = L4.Lmpu10 if Lmpu10==. 


replace Lmpu10 =. if year > 2020 
replace Lmpu10 =. if year == 2020 & month == 11 
replace Lmpu10 =. if year == 2020 & month == 12 

merge m:1 year quarter using "$user/merged data/GDPDeflator.dta", nogen 

summ l_inf_q_gdpdefl, detail 
gen l_inf_q_gdpdefl_mean = (l_inf_q_gdpdefl - r(mean))/r(sd)

summ l_inf_yoy_gdpdefl, det
gen l_inf_yoy_gdpdefl_mean = (l_inf_yoy_gdpdefl - r(mean) )/r(sd)


merge m:1 year month using "$user/merged data/HRSMPU2.dta", nogen 

******
drop if year > 2021
drop  if year < 2001
******

sort date
replace HRSMPU = L.HRSMPU if HRSMPU ==. 

drop if year ==. 

merge m:1 date using "$user/merged data/ECBPress.dta", nogen 
replace ecbpress = 0 if ecbpress ==. 

gen centralbankday = 0 
replace centralbankday = 1 if fomc_day==1
replace centralbankday = 1 if ecbpress == 1

replace fomc_day = 0 if fomc_day ==. 

tsset date 

drop if year < 2001 
drop if year > 2022 


summ L_Tbill3Mean
gen L_Tbill_mean =  (L_Tbill3Mean-r(mean))/r(sd)

sum Lmpu10, detail 

gen Lmpu10_mean = Lmpu10-r(mean) 

summ HRSMPU, detail 
gen HRSMPU_mean = (HRSMPU - r(mean))/r(sd)


gen yq =yq(year, quarter)
format yq %tq
merge m:1 yq using "$user/merged data/GapBEA.dta", nogen 

******
drop if year > 2021
drop  if year < 2001
******

summ L_Gap_BEA
gen L_Gap_BEA_mean = (L_Gap_BEA - r(mean))/r(sd)


merge 1:1 date using "$user/merged data/TBill3M.dta", nogen 

summ TBill3M_lag
gen TBill3M_lag_mean = TBill3M_lag - r(mean)


merge 1:1 date using "$user/merged data/TreasuryFut10YVolaForecasts6.dta", nogen 

summ emwa_10ytf
gen emwa_10ytf_mean = (emwa_10ytf - r(mean))/r(sd)



merge 1:1 date using "$user/merged data/TreasuryFut5YVolaForecasts6.dta", nogen 

summ emwa_5ytf
gen emwa_5ytf_mean = (emwa_5ytf - r(mean))/r(sd)

merge 1:1 date using "$user/merged data/TreasuryFut2YVolaForecasts6.dta", nogen 

summ emwa_2ytf
gen emwa_2ytf_mean = (emwa_2ytf - r(mean))/r(sd)

merge 1:1 date using "$user/merged data/EurodollarForecasts6.dta", nogen 

summ emwa_eurodollar
gen emwa_eurodollar_mean = (emwa_eurodollar - r(mean))/r(sd)


merge m:1 date using "$user/merged data/SpreadMoodys.dta", nogen
tsset date 

replace lag_CreditSpreadA10Y  = L2.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L3.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L4.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 
replace lag_CreditSpreadA10Y  = L5.CreditSpreadA10Y  if lag_CreditSpreadA10Y ==. 

summ lag_CreditSpreadA10Y 
gen CreditSpreadA10Y_lagmean = (lag_CreditSpreadA10Y - r(mean))/r(sd)



* Import macroeconomic uncertainty data from Jurado et al. (2015)
merge m:1 year month using "$user/merged data/Ludvigson_MacroUncert.dta", nogen 

drop if year > 2021
drop  if year < 2001

summ L_MacroUncertaintyh1 
gen L_MacroUncertaintyh1_mean = (L_MacroUncertaintyh1 -r(mean))/r(sd)


merge m:1 date using "$user/merged data/MOVE.dta", nogen 
tsset date 

gen  MOVE_lag = L.Move_Last
replace MOVE_lag = L2.Move_Last if L.Move_Last == . & MOVE_lag ==. 
replace MOVE_lag = L3.Move_Last if L2.Move_Last == . & MOVE_lag ==. 
replace MOVE_lag = L4.Move_Last if L3.Move_Last == . & MOVE_lag ==. 
replace MOVE_lag = L5.Move_Last if L4.Move_Last == . & MOVE_lag ==. 


tssmooth ma MOVE_MovAver = MOVE_lag, window(5)

drop if year > 2021
drop  if year < 2001

summ MOVE_lag
gen MOVE_lag_mean = (MOVE_lag - r(mean))/r(sd)

gen MOVE_365 = MOVE_lag/sqrt(365)
summ MOVE_365, det
gen MOVE_365_mean = (MOVE_365 - r(mean) )/r(sd)

summ MOVE_MovAver
gen MOVE_MovAver_mean = (MOVE_MovAver- r(mean))/r(sd)


merge m:1 date using "$user/merged data/TYVIX.dta", nogen 
tsset date 

gen TYVIX_lag = L.TYVIX 

replace TYVIX_lag = L.TYVIX_lag if TYVIX_lag == .  
replace TYVIX_lag = L2.TYVIX_lag if L.TYVIX_lag == . & TYVIX_lag ==. 
replace TYVIX_lag = L3.TYVIX_lag if L2.TYVIX_lag == . & TYVIX_lag ==. 
replace TYVIX_lag = L4.TYVIX_lag if L3.TYVIX_lag == . & TYVIX_lag ==. 
replace TYVIX_lag = F.TYVIX if TYVIX_lag == . & year == 2003 
replace TYVIX_lag = . if date > td(15may2020)


tssmooth ma TYVIX_MovAver = TYVIX_lag, window(5)

drop if year > 2021
drop  if year < 2001

summ TYVIX_lag
gen TYVIX_lag_mean = (TYVIX_lag - r(mean))/r(sd)

gen TYVIX_365 = TYVIX_lag/sqrt(365)
summ TYVIX_365, deta 
gen TYVIX_365_lag_mean = (TYVIX_365 - r(mean))/r(sd)

winsor2 TYVIX_365, cuts(0 99) 
summ TYVIX_365_w, deta 
gen TYVIX_365_lag_w_mean = (TYVIX_365_w - r(mean))/r(sd)


summ TYVIX_MovAver, deta 
gen TYVIX_MovAver_mean = (TYVIX_MovAver - r(mean))/r(sd)



merge m:1 date using  "$user/merged data/YieldCurveSlope.dta", nogen 
tsset date 
replace yield_curve_slope_lag = l.yield_curve_slope if yield_curve_slope_lag ==. 
replace yield_curve_slope_lag = l2.yield_curve_slope if yield_curve_slope_lag ==. 
replace yield_curve_slope_lag = l3.yield_curve_slope if yield_curve_slope_lag ==. & l2.yield_curve_slope == . 

summ yield_curve_slope_lag 
gen yield_curve_slope_lag_mean = (yield_curve_slope_lag - r(mean)) / r(sd)

**********
drop if year > 2021
drop  if year < 2001
******


*****************************************************************************
*   Preparation of Data set 
*****************************************************************************

drop if year > 2021
drop  if year < 2001

tsset date 

save "$user/merged data/TimeSeriesData.dta", replace 

*****************************************************************************
* Table A.3: High-frequency correlations 
*****************************************************************************

* Column (1) 
corr sqrt_htau sqrt_htau 
corr sqrt_htau sqrt_tau 
corr sqrt_htau sqrt_h
corr sqrt_htau Sqrt_Sigma_GJR_EW
corr sqrt_htau VIX
corr sqrt_htau L_risk_index 
corr sqrt_htau yield_curve_slope
corr sqrt_htau CreditSpreadA10Y
corr sqrt_htau emwa_eurodollar
corr sqrt_htau Move_Last
corr sqrt_htau emwa_10ytf
corr sqrt_htau TYVIX 

* Column (2) 
corr sqrt_tau sqrt_h
corr sqrt_tau Sqrt_Sigma_GJR_EW
corr sqrt_tau VIX
corr sqrt_tau L_risk_index 
corr sqrt_tau yield_curve_slope
corr sqrt_tau CreditSpreadA10Y
corr sqrt_tau emwa_eurodollar
corr sqrt_tau Move_Last
corr sqrt_tau emwa_10ytf
corr sqrt_tau TYVIX 

* Column (3)
corr sqrt_h Sqrt_Sigma_GJR_EW
corr sqrt_h VIX
corr sqrt_h L_risk_index 
corr sqrt_h yield_curve_slope
corr sqrt_h CreditSpreadA10Y
corr sqrt_h emwa_eurodollar
corr sqrt_h Move_Last
corr sqrt_h emwa_10ytf
corr sqrt_h TYVIX 

* Column (4)
corr Sqrt_Sigma_GJR_EW  Sqrt_Sigma_GJR_EW
corr Sqrt_Sigma_GJR_EW  VIX
corr Sqrt_Sigma_GJR_EW L_risk_index 
corr Sqrt_Sigma_GJR_EW yield_curve_slope
corr Sqrt_Sigma_GJR_EW CreditSpreadA10Y
corr Sqrt_Sigma_GJR_EW emwa_eurodollar
corr Sqrt_Sigma_GJR_EW Move_Last
corr Sqrt_Sigma_GJR_EW emwa_10ytf
corr Sqrt_Sigma_GJR_EW  TYVIX 

* Column (5)
corr VIX L_risk_index 
corr VIX yield_curve_slope
corr VIX CreditSpreadA10Y
corr VIX emwa_eurodollar
corr VIX Move_Last
corr VIX emwa_10ytf
corr VIX TYVIX 

* Column (6)
corr L_risk_index  yield_curve_slope
corr L_risk_index  CreditSpreadA10Y
corr L_risk_index  emwa_eurodollar
corr L_risk_index  Move_Last
corr L_risk_index  emwa_10ytf
corr L_risk_index  TYVIX 

* Column (7)
corr yield_curve_slope  CreditSpreadA10Y
corr yield_curve_slope  emwa_eurodollar
corr yield_curve_slope  Move_Last
corr yield_curve_slope emwa_10ytf
corr yield_curve_slope TYVIX 

* Column (8)
corr CreditSpreadA10Y emwa_eurodollar
corr CreditSpreadA10Y Move_Last
corr CreditSpreadA10Y emwa_10ytf
corr CreditSpreadA10Y TYVIX 

* Column (9)
corr emwa_eurodollar Move_Last
corr emwa_eurodollar emwa_10ytf
corr emwa_eurodollar TYVIX 


* Column (10)
corr Move_Last emwa_10ytf
corr Move_Last TYVIX 


* Column (11)
corr emwa_10ytf TYVIX 



***********************

gen ten = 0
gen eightthirty= 0 
gen event=0

* To allow for a consistent interpretation of good and bad news, we multiply Initial Jobless Claims and the CPI with (-1). 

replace CPI 	= (-1)* CPI 
replace CPICore 	= (-1)* CPICore
replace INJCJC= (-1)* INJCJC

* To reduce the impact of extreme surprises, we winsorize the difference between the announcement and the median forecast at the 95% level, i.e. we cut 2.5% on both sides of the distribution.

foreach ind of local events10 {
	
	winsor2 `ind' if E_`ind' == 1, cuts(2.5 97.5) suffix(_w)
	drop `ind' 
	rename `ind'_w `ind'
	
	summarize `ind' if E_`ind' == 1, detail 

	gen S_`ind' = `ind'/r(sd) if E_`ind' == 1 & year > 1999 & year < 2022
	
	
	gen Abs_S_`ind' = abs(S_`ind')
	
	replace E_`ind' = 0 if E_`ind' ==. 
	replace S_`ind' = 0 if S_`ind' ==. 	
	replace ten =1 if E_`ind' == 1
}


foreach indi of local events830 {
	
	winsor2 `indi' if E_`indi' == 1, cuts(2.5 97.5) suffix(_w)
	drop `indi' 
	rename `indi'_w `indi'
	
	summarize `indi' if E_`indi' == 1 & year > 1999 & year < 2022
	
	gen S_`indi' = `indi'/r(sd) if E_`indi' == 1
	
	
	gen Abs_S_`indi' = abs(S_`indi')
	
	replace E_`indi' = 0 if E_`indi' ==. 
	replace S_`indi' = 0 if S_`indi' ==. 
	replace eightthirty =1 if E_`indi' == 1
}


label variable S_NFPTCH "Employees on Nonfarm Payrolls"
label variable S_TMNOCHNG  "Manufacturers New Orders"
label variable S_NHSLTOT "New  Family Houses Sold"
label variable S_CPI  "Consumer Price Index"
label variable S_NAPMPMI  "Purchasing Managers Index"
label variable S_DGNOCHNG  "Durable Goods Order"
label variable S_INJCJC  "Initial Jobless Claims"
label variable S_CONCCONF  "Consumer Confidence"


foreach s of local Events {
	replace event = 1 if E_`s' == 1
 }	
 
drop if event ==0 


 quietly foreach s of local Sevents {
	
	gen Sq_`s' = (`s')^2
	gen Sq4_`s' = (`s')^4
	
	gen `s'_goodD =. 
	replace `s'_goodD = 1 if `s'>0 
	replace `s'_goodD = 0 if `s'==0 
	replace `s'_goodD = 0 if `s'<0 
	label var `s'_goodD  "`s' good news"
	
	gen `s'_badD =. 
	replace `s'_badD = 1 if `s'<0 
	replace `s'_badD= 0 if `s'==0 
	replace `s'_badD= 0 if `s'>0 
	label var `s'_badD  "`s' bad news" 
	
	gen `s'_good = `s'_goodD * `s'
	label var `s'_good  "`s' good news"
	
	gen `s'_bad = `s'_badD* `s'
	label var `s'_bad  "`s' bad news"
	
	gen Sq_`s'_g = (`s'_good)^2
	gen Sq_`s'_b = (`s'_bad)^2
	
	summarize `s', detail 
	gen `s'_zero = 0 
	replace `s'_zero = `s' if `s' > 0.5*r(sd) 
	replace `s'_zero = `s' if `s' < - 0.5*r(sd) 
	replace `s'_zero = 0 if `s'_zero ==. 
 
}


save "$user/merged data/AnnoucementsDatabase.dta", replace
drop if eightthirty==0

gen eightEvent = 1 

save "$user/merged data/AnnoucementsDatabase830.dta", replace

use  "$user/merged data/AnnoucementsDatabase.dta", clear 
drop if ten == 0 

gen tenEvent = 1 
save "$user/merged data/AnnoucementsDatabase10.dta", replace

use  "$user/merged data/AnnoucementsDatabase830.dta", clear 
append using "$user/merged data/AnnoucementsDatabase10.dta" 

* Generate Time Dummies 

sort date
drop eightthirty ten 
gen eightthirty =. 
replace eightthirty = 1 if eightEvent == 1 
replace eightthirty = 0 if eightEvent ==. 


gen ten =. 
replace ten = 1 if tenEvent == 1 
replace ten = 0 if tenEvent ==. 


* Generating Return Data 
gen return = . 
replace return = rm10emini if ten==1 & eightthirty != 1 
replace return = rm83emini if ten!=1 & eightthirty == 1  

gen return1min = . 
replace return1min = rm10emini1min if ten==1 & eightthirty != 1
replace return1min = rm83emini1min if ten!=1 & eightthirty == 1  
 
 gen return10min = . 
replace return10min = rm10emini10min if ten==1 & eightthirty != 1 
replace return10min = rm83emini10min if ten!=1 & eightthirty == 1  

gen returnSP5001min = rm101min if ten==1 & eightthirty != 1 
gen returnSP50010min = rm1010min if ten==1 & eightthirty != 1 
gen returnSP5005min = rm105min if ten==1 & eightthirty != 1 


* EuroStoxx 
gen returnEStoxx = . 
replace returnEStoxx = rm10eurostoxx5min if ten==1 & eightthirty != 1 
replace returnEStoxx = rm83eurostoxx5min if ten!=1 & eightthirty == 1  

gen return1minEStoxx = . 
replace return1minEStoxx = rm10eurostoxx1min if ten==1 & eightthirty != 1
replace return1minEStoxx = rm83eurostoxx1min if ten!=1 & eightthirty == 1  
 
gen return10minEStoxx = . 
replace return10minEStoxx = rm10eurostoxx10min if ten==1 & eightthirty != 1 
replace return10minEStoxx = rm83eurostoxx10min if ten!=1 & eightthirty == 1  


quietly foreach s of local Sevents830 {
	replace `s' = 0 if eightthirty == 0 
	replace Sq_`s' = 0 if eightthirty == 0 
	replace Sq4_`s' = 0 if eightthirty == 0 
	replace `s'_good = 0 if eightthirty == 0 
	replace `s'_bad = 0 if eightthirty == 0 
	replace `s'_zero = 0 if eightthirty == 0 

}

foreach s of local Sevents10 {
	replace `s' = 0 if ten == 0 
	replace Sq_`s' = 0 if ten == 0 
	replace Sq4_`s' = 0 if ten == 0 
	replace `s'_good = 0 if ten == 0 
	replace `s'_bad = 0 if ten == 0 
	replace `s'_zero = 0 if ten == 0 

} 

save "$user/merged data/AnnoucementsDatabaseAllTimes.dta", replace


drop if return==. 

drop if year > 2021
drop  if year < 2001

cd "$user/tables" 

*********************************************************************************
* Table 1: Summary Statistics for U.S. macroeconomic announcement data for 
* 		   January 2001 to December 2021 period.
*********************************************************************************
 	
foreach s of local events830 {
	
	tab E_`s' if E_`s' == 1 & eightthirty == 1 & ten==0
	*tab E_`s' if E_`s' == 1 & eightEvent==1
	disp `s' ":" r(N) 
	
	}

	foreach s of local events10 {
	
	tab E_`s' if E_`s' == 1 & ten == 1 & eightthirty ==0
	*tab E_`s' if E_`s' == 1 & ten == 1 & tenEvent ==1
	disp `s' ":" r(N) 
	
	}
	
*********************************************************************************
* Table 2: Baseline Model with time-varying sensitivity and Newey West 
*********************************************************************************

sort date
drop t
gen t= _n 
tsset t 

eststo clear 
eststo: newey return `Sevents', lag(3)
eststo:  nl (return = {b1} + (1 + {gammasigma}*htau_mean_sqrt)*($regression )),  vce(hac nwest 3)
eststo:  nl (return = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression )),  vce(hac nwest 3)
eststo:  nl (return = {b1} + (1+ {gammah}*h_mean_sqrt)*($regression )),  vce(hac nwest 3)
eststo:  nl (return = {b1} + (1 + {gammasigma}*htau_mean_sqrt + {gammat}*tau_mean_sqrt )*($regression )),  vce(hac nwest 3)
eststo:  nl (return = {b1} + (1+ {gammat}*tau_mean_sqrt + {gammah}*h_mean_sqrt + {gammasigma}*htau_mean_sqrt)*($regression )),  vce(hac nwest 3)

esttab using Table2.tex, label  title(Baseline) ar2 replace se star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear

*********************************************************************************
* Figure 3: Marginal Effects
*********************************************************************************

* Statement in the text 

summ tau if E_CONCCONF==1, detail 
local taupercentileCC  = r(p90) 
local taupercentile10CC  = r(p10) 

disp "Annualized:" sqrt(252*`taupercentileCC') 
disp "Annualized:" sqrt(252*`taupercentile10CC') 

* Figure for 8:30 am EST announcements  

summ tau_mean_sqrt if E_CONCCONF == 1, detail

eststo:  nl (return = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression )),   vce(hac nwest 3)

foreach announcement of global events830 { 

predictnl marginal`announcement'g =_b[/`announcement']*(1+_b[/gammat]*tau_mean_sqrt), se(semarginal`announcement'g)
predictnl marginal`announcement'b =-_b[/`announcement']*(1+_b[/gammat]*tau_mean_sqrt), se(semarginal`announcement'b)

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

graph twoway (histogram tau_mean_sqrt if E_`announcement' == 1 & eightthirty ==1 , yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ytitle("Density", size(medlarge)) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) (rarea `announcement'g_upper  `announcement'g_lower tau_mean_sqrt if eightthirty ==1 , fcolor(green%20) yline(0)  sort lcolor(green%0))  (rarea `announcement'b_upper  `announcement'b_lower tau_mean_sqrt, fcolor("198 24 38"%5)  sort lcolor(red%0))    (line marginal`announcement'g  tau_mean_sqrt, lcolor(green)  ytitle("Marginal Effect", size(medlarge)) xtitle("Demeaned long-term volatility", size(medlarge)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b  tau_mean_sqrt, lcolor("198 24 38") ), legend(off) name(`announcement', replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_3_`announcement'.png", name(`announcement') replace

drop  `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 


* Figure for 10:00 am EST announcements 
foreach announcement of global events10 { 


predictnl marginal`announcement'g =_b[/`announcement']*(1+_b[/gammat]*tau_mean_sqrt), se(semarginal`announcement'g)

predictnl marginal`announcement'b =-_b[/`announcement']*(1+_b[/gammat]*tau_mean_sqrt), se(semarginal`announcement'b)


gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

graph twoway (histogram tau_mean_sqrt if E_`announcement' == 1 & ten ==1 , yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ytitle("Density", size(medlarge)) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) (rarea `announcement'g_upper  `announcement'g_lower tau_mean_sqrt if ten ==1 , fcolor(green%20) yline(0)  sort lcolor(green%0))  (rarea `announcement'b_upper  `announcement'b_lower tau_mean_sqrt, fcolor("198 24 38"%5)  sort lcolor(red%0))    (line marginal`announcement'g  tau_mean_sqrt, lcolor(green)  ytitle("Marginal effect", size(medlarge)) xtitle("Demeaned long-term volatility", size(medlarge)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b  tau_mean_sqrt, lcolor("198 24 38") ), legend(off) name(`announcement', replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_3_`announcement'.png", name(`announcement') replace

drop  `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 

*********************************************************************************
* Table 3: Heterogeneity in the time-varying sensitivity to news 
*			across announcements 
*********************************************************************************
eststo clear
eststo:  nl (return = {b1}+ (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI )) , vce(hac nwest 3)  

test _b[gammatauInvestmentCons:_cons] = _b[gammatauRealActivity:_cons]
test _b[gammatauInvestmentCons:_cons] = _b[gammatauForwardlooking:_cons]
test _b[gammatauForwardlooking:_cons] = _b[gammatauRealActivity:_cons]
test _b[gammatauInvestmentCons:_cons] = _b[gammatauPrices:_cons]

eststo:  nl (return = {b1}+ (1+ {gammatauINJC}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC ) + (1+ {gammatauRSales}*tau_mean_sqrt)*(  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauDGN}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG ) +  (1+ {gammataTMOCHNG}*tau_mean_sqrt)* ( {TMNOCHNG}*S_TMNOCHNG) + (1+ {gammatauCONCONF}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF  ) + (1+ {gammatauPMI}*tau_mean_sqrt)*({NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauCPI}*tau_mean_sqrt)*({CPI}*S_CPI ) + (1+ {gammatauNFP}*tau_mean_sqrt)*({NFPTCH}*S_NFPTCH) + (1+ {gammatauNHS}*tau_mean_sqrt)*({NHSLTOT}* S_NHSLTOT) ), vce(hac nwest 3)  

eststo: newey return c.S_INJCJC##c.tau_mean_sqrt c.S_NFPTCH##c.tau_mean_sqrt c.S_RSTAXMOM##c.tau_mean_sqrt c.S_NHSLTOT##c.tau_mean_sqrt c.S_DGNOCHNG##c.tau_mean_sqrt c.S_TMNOCHNG##c.tau_mean_sqrt  c.S_CPI##c.tau_mean_sqrt c.S_CONCCONF##c.tau_mean_sqrt c.S_NAPMPMI##c.tau_mean_sqrt, lag(3)
esttab using Table3.tex, label  title(Heterogeneity in the time-varying sensitivity to news across announcements.) ar2 replace se star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear


*********************************************************************************
* Table 4: Testing for asymmetric effects of good and bad news 
*********************************************************************************

* Claim in Text: 
nl (return =  {b1} + $regressiongood + $regressionbad  ),  vce(hac nwest 3)

* Claim in section 4.2.2. (holds for all)
eststo: nl (return = {b1}+ {gamma1}*tau_mean + (1+ {gammat}*tau_mean_sqrt + {gammah}*h_mean_sqrt + {gammasigma}*htau_mean_sqrt)*($regression + $regressionsquaredGood2 + $regressionsquared2) ), vce(hac nwest 3)


* Table  
eststo clear
eststo:  nl (return =  {b1}+ {gamma1}*tau_mean + (1+ {gammat}*tau_mean_sqrt )*($regressiongood + $regressionbad ) ),  vce(hac nwest 3)
test _b[/INJCJC_good] = _b[/INJCJC_bad]
test _b[/DGNOCHNG_good] = _b[/DGNOCHNG_bad]
test _b[/NAPMPMI_good] = _b[/NAPMPMI_bad]
test _b[/RSTAXMOM_good] = _b[/RSTAXMOM_bad]
test _b[/CONCCONF_good] = _b[/CONCCONF_bad]
test _b[/CPI_good] = _b[/CPI_bad]
test _b[/NHSLTOT_good] = _b[/NHSLTOT_bad]
test _b[/NFPTCH_good] = _b[/NFPTCH_bad]
test _b[/TMNOCHNG_good] = _b[/TMNOCHNG_bad]

eststo:  nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean_sqrt)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 

test _b[INJCJCgood:_cons] = _b[INJCJCbad:_cons]
test _b[NFPTCHgood:_cons] = _b[NFPTCHbad:_cons]
test _b[RSTAXMOMgood:_cons] = _b[RSTAXMOMbad:_cons]
test _b[DGNOCHNGgood:_cons] = _b[DGNOCHNGbad:_cons]
test _b[TMNOCHNGgood:_cons] = _b[TMNOCHNGbad:_cons]
test _b[NHSgood:_cons] = _b[NHSbad:_cons]
test _b[CONCCONFgood:_cons] = _b[CONCCONFbad:_cons]
test _b[NAPMPMIgood:_cons] = _b[NAPMPMIbad:_cons]
test _b[CPIgood:_cons] = _b[CPIbad:_cons]

eststo: nl (return = {b1}+ {gamma1}*tau_mean + (1+ {gammat}*tau_mean_sqrt)*($regression + $regressionsquaredGood2 + $regressionsquared2) ), vce(hac nwest 3)

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 

esttab using Table4.tex, label  title(Testing for asymmetric effects of good and bad news) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear


*********************************************************************************
* Figure 4: Squared News 
*********************************************************************************

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 


foreach announcement of global eventsRealActivity830 { 

summ tau_mean if E_`announcement' ==1, detail
scalar p5 = r(p10) 
scalar p95 = r(p90) 

summ tau_mean_sqrt if E_`announcement' ==1, detail
scalar p5s = r(p10) 
scalar p95s = r(p90) 


predictnl marginal`announcement'tau1 =_b[/b1] +_b[/gamma1]*(`=p95') +(1+_b[/gammatauRealActivity]*(`=p95s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'*S_`announcement'_goodD), se(semarginal`announcement'1)
predictnl marginal`announcement'tau2 =_b[/b1] +_b[/gamma1]*(`=p5') +(1+_b[/gammatauRealActivity]*(`=p5s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'*S_`announcement'_goodD), se(semarginal`announcement'2)

gen `announcement'1_upper = marginal`announcement'tau1 + 1.64 * semarginal`announcement'1
gen `announcement'2_upper = marginal`announcement'tau2 + 1.64 * semarginal`announcement'2
gen `announcement'1_lower = marginal`announcement'tau1 - 1.64 * semarginal`announcement'1
gen `announcement'2_lower = marginal`announcement'tau2 - 1.64 * semarginal`announcement'2


graph twoway (rarea `announcement'1_upper  `announcement'1_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' <  2, fcolor(blue%20) yline(0)  sort lcolor(orange_red%0))  (rarea `announcement'2_upper  `announcement'2_lower S_`announcement' if S_`announcement' >= -2 & S_`announcement' <= 2, fcolor(orange_red%20)  sort lcolor(orange_red%0))    (function y=_b[/b1] +_b[/gamma1]*(`=p95') + (1+_b[/gammatauRealActivity]*(`=p95s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if  S_`announcement' >= 0 & S_`announcement' <= 2 , range(S_`announcement') lcolor(blue) lpattern(solid) ytitle("Predicted return", size(medium)) xtitle("Standardized surprise", size(medium))  yaxis(1) yscale(alt) lpattern(solid) yscale(alt axis(1)))   (function y = _b[/b1] +_b[/gamma1]*(`=p5') + (1+_b[/gammatauRealActivity]*(`=p5s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if  S_`announcement' >= 0 & S_`announcement'  <= 2 , lcolor(orange_red)  lpattern(solid) range(S_`announcement'))  (function y=_b[/b1] +_b[/gamma1]*(`=p95') + (1+_b[/gammatauRealActivity]*(`=p95s'))*(_b[/`announcement']*x) if  S_`announcement' >- 2 & S_`announcement' <= 0 , range(S_`announcement') lcolor(blue) lpattern(solid))   (function y = _b[/b1] +_b[/gamma1]*(`=p5') + (1+_b[/gammatauRealActivity]*(`=p5s'))*(_b[/`announcement']*x) if  S_`announcement' > - 2 & S_`announcement'  <= 0 , lcolor(orange_red)  lpattern(solid) range(S_`announcement'))  (histogram S_`announcement' if E_`announcement' == 1 & eightthirty ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) lpattern(solid) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) , legend(off) name(`announcement'_squarednew, replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_4_`announcement'.png", name(`announcement'_squarednew) replace


drop  marginal`announcement'tau1 marginal`announcement'tau2 semarginal`announcement'1 semarginal`announcement'2 `announcement'1_upper `announcement'1_lower `announcement'2_upper `announcement'2_lower
}


foreach announcement of global eventsInvestmentCons830 { 

summ tau_mean if E_`announcement' ==1, detail
scalar p5 = r(p10) 
scalar p95 = r(p90) 

summ tau_mean_sqrt if E_`announcement' ==1, detail
scalar p5s = r(p10) 
scalar p95s = r(p90) 


predictnl marginal`announcement'tau1 =_b[/b1] +_b[/gamma1]*(`=p95') +(1+_b[/gammatauInvestmentCons]*(`=p95s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'1)
predictnl marginal`announcement'tau2 =_b[/b1] +_b[/gamma1]*(`=p5') +(1+_b[/gammatauInvestmentCons]*(`=p5s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'2)

gen `announcement'1_upper = marginal`announcement'tau1 + 1.64 * semarginal`announcement'1
gen `announcement'2_upper = marginal`announcement'tau2 + 1.64 * semarginal`announcement'2
gen `announcement'1_lower = marginal`announcement'tau1 - 1.64 * semarginal`announcement'1
gen `announcement'2_lower = marginal`announcement'tau2 - 1.64 * semarginal`announcement'2


graph twoway (rarea `announcement'1_upper  `announcement'1_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' <  2, fcolor(blue%20) yline(0)  sort lcolor(orange_red%0))  (rarea `announcement'2_upper  `announcement'2_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0))    (function y=_b[/b1] +_b[/gamma1]*(`=p95') + (1+_b[/gammatauInvestmentCons]*(`=p95s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, range(S_`announcement') lcolor(blue) lpattern(solid) ytitle("Predicted return", size(medium)) xtitle("Standardized surprise", size(medium))  yaxis(1) yscale(alt) lpattern(solid) yscale(alt axis(1)))   (function y = _b[/b1] +_b[/gamma1]*(`=p5') + (1+_b[/gammatauInvestmentCons]*(`=p5s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red)  lpattern(solid) range(S_`announcement')) (histogram S_`announcement' if E_`announcement' == 1 & eightthirty==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) lpattern(solid) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) , legend(off) name(`announcement'_squarednew, replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_4_`announcement'.png", name(`announcement'_squarednew) replace

drop  marginal`announcement'tau1 marginal`announcement'tau2 semarginal`announcement'1 semarginal`announcement'2 `announcement'1_upper `announcement'1_lower `announcement'2_upper `announcement'2_lower
}





foreach announcement of global eventsInvestmentCons10 { 

summ tau_mean if E_`announcement' ==1, detail
scalar p5 = r(p10) 
scalar p95 = r(p90) 


summ tau_mean_sqrt if E_`announcement' ==1, detail
scalar p5s = r(p10) 
scalar p95s = r(p90) 

predictnl marginal`announcement'tau1 =_b[/b1] +_b[/gamma1]*(`=p95') +(1+_b[/gammatauInvestmentCons]*(`=p95s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'1)
predictnl marginal`announcement'tau2 =_b[/b1] +_b[/gamma1]*(`=p5') +(1+_b[/gammatauInvestmentCons]*(`=p5s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'2)


gen `announcement'1_upper = marginal`announcement'tau1 + 1.64 * semarginal`announcement'1
gen `announcement'2_upper = marginal`announcement'tau2 + 1.64 * semarginal`announcement'2
gen `announcement'1_lower = marginal`announcement'tau1 - 1.64 * semarginal`announcement'1
gen `announcement'2_lower = marginal`announcement'tau2 - 1.64 * semarginal`announcement'2

graph twoway (rarea `announcement'1_upper  `announcement'1_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' <  2, fcolor(blue%20) yline(0)  sort lcolor(orange_red%0))  (rarea `announcement'2_upper  `announcement'2_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0))    (function y=_b[/b1] +_b[/gamma1]*(`=p95') + (1+_b[/gammatauInvestmentCons]*(`=p95s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, range(S_`announcement') lcolor(blue) lpattern(solid) ytitle("Predicted return", size(medium)) xtitle("Standardized surprise", size(medium))  yaxis(1) yscale(alt) lpattern(solid) yscale(alt axis(1)))   (function y = _b[/b1] +_b[/gamma1]*(`=p5') + (1+_b[/gammatauInvestmentCons]*(`=p5s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red)  lpattern(solid) range(S_`announcement')) (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) lpattern(solid) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) , legend(off) name(`announcement'_squarednew, replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_4_`announcement'.png", name(`announcement'_squarednew) replace

drop  marginal`announcement'tau1 marginal`announcement'tau2 semarginal`announcement'1 semarginal`announcement'2 `announcement'1_upper `announcement'1_lower `announcement'2_upper `announcement'2_lower
}


foreach announcement of global eventsForwardlooking10 { 

summ tau_mean if E_`announcement' ==1, detail
scalar p5 = r(p10) 
scalar p95 = r(p90) 


summ tau_mean_sqrt if E_`announcement' ==1, detail
scalar p5s = r(p10) 
scalar p95s = r(p90) 

predictnl marginal`announcement'tau1 =_b[/b1] +_b[/gamma1]*(`=p95') +(1+_b[/gammatauForwardlooking]*(`=p95s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'1)
predictnl marginal`announcement'tau2 =_b[/b1] +_b[/gamma1]*(`=p5') +(1+_b[/gammatauForwardlooking]*(`=p5s'))*( _b[/`announcement']*S_`announcement' + _b[/`announcement'Sq]*Sq_S_`announcement'), se(semarginal`announcement'2)


gen `announcement'1_upper = marginal`announcement'tau1 + 1.64 * semarginal`announcement'1
gen `announcement'2_upper = marginal`announcement'tau2 + 1.64 * semarginal`announcement'2
gen `announcement'1_lower = marginal`announcement'tau1 - 1.64 * semarginal`announcement'1
gen `announcement'2_lower = marginal`announcement'tau2 - 1.64 * semarginal`announcement'2

graph twoway (rarea `announcement'1_upper  `announcement'1_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' <  2, fcolor(blue%20) yline(0)  sort lcolor(orange_red%0))  (rarea `announcement'2_upper  `announcement'2_lower S_`announcement' if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0))    (function y=_b[/b1] +_b[/gamma1]*(`=p95') + (1+_b[/gammatauForwardlooking]*(`=p95s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, range(S_`announcement') lcolor(blue) lpattern(solid) ytitle("Predicted return", size(medium)) xtitle("Standardized surprise", size(medium))  yaxis(1) yscale(alt) lpattern(solid) yscale(alt axis(1)))   (function y = _b[/b1] +_b[/gamma1]*(`=p5') + (1+_b[/gammatauForwardlooking]*(`=p5s'))*(_b[/`announcement']*x+ _b[/`announcement'Sq]*x^2) if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red)  lpattern(solid) range(S_`announcement')) (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) lpattern(solid) fcolor(gs14%40) fintensity(20)  lcolor(gs9) , graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black))) , legend(off) name(`announcement'_squarednew, replace) title("`announcement'", size(large))
graph export "$user/figures/Figure_4_`announcement'.png", name(`announcement'_squarednew) replace

drop  marginal`announcement'tau1 marginal`announcement'tau2 semarginal`announcement'1 semarginal`announcement'2 `announcement'1_upper `announcement'1_lower `announcement'2_upper `announcement'2_lower
}




preserve 

*********************************************************************************
* Figure 5: Absolute returns predicted by the model for consumer confidence 
*********************************************************************************

*nl (return = {b1}+ {gamma1}*tau_mean + (1+ {gammat}*tau_mean_sqrt)*($regressiongood + $regressionbad ) ),  vce(hac nwest 3)
eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3)  

drop if ten == 0 & eightthirty == 1 
tsset date 

predictnl predictedCCgood = _b[/b1] + _b[/gamma1]*tau_mean + (1+  _b[/gammatauForwardlooking]*tau_mean_sqrt)*(_b[/CONCCONF]*2 + _b[/CONCCONFSq]*4) if E_CONCCONF == 1, ci(CCgoodu CCgoodl) level(68)
predictnl predictedCCbad = (-1)*(_b[/b1] + _b[/gamma1]*tau_mean + (1+  _b[/gammatauForwardlooking]*tau_mean_sqrt)*(_b[/CONCCONF]*(-2) + _b[/CONCCONFSq]*4)) if E_CONCCONF == 1, ci(CCbadu CCbadl) level(68)


local upper = 1.1

gen recession = 0 
replace recession = `upper' if year == 2007 & month == 10 
replace recession = `upper' if year == 2007 & month == 11
replace recession = `upper' if year == 2007 & month == 12 
replace recession = `upper' if year == 2008 & month == 1 
replace recession = `upper' if year == 2008 & month == 2 
replace recession = `upper' if year == 2008 & month == 3 
replace recession = `upper' if year == 2008 & month == 4 
replace recession = `upper' if year == 2008 & month == 5 
replace recession = `upper' if year == 2008 & month == 6 
replace recession = `upper' if year == 2008 & month == 7 
replace recession = `upper' if year == 2008 & month == 8 
replace recession = `upper' if year == 2008 & month == 9 
replace recession = `upper' if year == 2008 & month == 10 
replace recession = `upper' if year == 2008 & month == 11
replace recession = `upper' if year == 2008 & month == 12 
replace recession = `upper' if year == 2009 & month == 1 
replace recession = `upper' if year == 2009 & month == 2 
replace recession = `upper' if year == 2009 & month == 3 
replace recession = `upper' if year == 2009 & month == 4 
replace recession = `upper' if year == 2009 & month == 5 
replace recession = `upper' if year == 2009 & month == 6 
replace recession = `upper' if year == 2009 & month == 7 
replace recession = `upper' if year == 2009 & month == 8 
replace recession = `upper' if year == 2009 & month == 9 
replace recession = `upper' if year == 2020 & month == 1 
replace recession = `upper' if year == 2020 & month == 2 
replace recession = `upper' if year == 2020 & month == 3 
replace recession = `upper' if year == 2020 & month == 4 
replace recession = `upper' if year == 2020 & month == 5 
replace recession = `upper' if year == 2020 & month == 6 
replace recession = `upper' if year == 2020 & month == 7 
replace recession = `upper' if year == 2020 & month == 8 
replace recession = `upper' if year == 2020 & month == 9 
replace recession = `upper' if year == 2001 & month == 1 
replace recession = `upper' if year == 2001 & month == 2 
replace recession = `upper' if year == 2001 & month == 3 
replace recession = `upper' if year == 2001 & month == 4 
replace recession = `upper' if year == 2001 & month == 5 
replace recession = `upper' if year == 2001 & month == 6 
replace recession = `upper' if year == 2001 & month == 7 
replace recession = `upper' if year == 2001 & month == 8 
replace recession = `upper' if year == 2001 & month == 9 
replace recession = `upper' if year == 2001 & month == 10 
replace recession = `upper' if year == 2001 & month == 11 
replace recession = `upper' if year == 2001 & month == 12 
label var recession "US recession"
label var date "Date"

twoway  (area recession date, lwidth(none none none none) xscale(range(15000, 22000))  color(gs14) yaxis(1))  (rarea CCbadl CCbadu date, lwidth(none none none none))  (rarea CCgoodl CCgoodu date, lwidth(none none none none))  (tsline predictedCCgood, lcolor(dkgreen) lpattern(solid)) (tsline predictedCCbad, lcolor(red) lpattern(solid)) (tsline tau, yaxis(2)  lcolor(stc1) lwidth(0.5) lpattern(dash)) , legend(position(2) cols(1) ring(0)) legend(order(1 "US recession" 2 "Bad news" 3 "Good news" 6 "Long-term volatility")) ytitle("Absolute predicted return") ytitle("Long-term volatility", axis(2)) xtitle("") name(TimeSeriesAnn, replace)

graph export "$user/figures/Figure_5.png", replace



restore 





*********************************************************************************
* Table 5: Explaining the time-varying sensitivity with additional 
*		   economic predictors
*********************************************************************************

* Panel A: Macroeconomic conditions (low-frequency) 
eststo clear 
eststo:  nl (return = {b1} + (1+ {gammatGroup1}*tau_mean_sqrt  + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean + {InflationGroup1}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+  {gammatPrices}*tau_mean_sqrt  + {OutputgapPrices}*L_Gap_BEA_mean +  {InterestExpectationsPrices}*L_Tbill_mean + {InflationPrices}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean )*({CPI}*S_CPI )) if year < 2021,  vce(hac nwest 3)

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatGroup1}*tau_mean_sqrt  + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean   + {InflationGroup1}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+  {gammatPrices}*tau_mean_sqrt  + {OutputgapPrices}*L_Gap_BEA_mean + {InflationPrices}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean +  {InterestExpectationsPrices}*L_Tbill_mean )*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if year < 2021, vce(hac nwest 3) 

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatGroup1}*tau_mean_sqrt  + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean + {InflationGroup1}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+  {gammatPrices}*tau_mean_sqrt  + {OutputgapPrices}*L_Gap_BEA_mean +  {InterestExpectationsPrices}*L_Tbill_mean + {InflationPrices}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) if year < 2021, vce(hac nwest 3) 
esttab using Table5_PanelA.tex, label  title(Panel A: Macroeconomic conditions (low-frequency)) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 




* Panel B: Macroeconomic conditions (high-frequency)

eststo clear 
eststo:  nl (return = {b1} +  (1 + {gammatGroup1}*tau_mean_sqrt   + {YCslope}*yield_curve_slope_lag_mean    + {CSpread}*CreditSpreadA10Y_lagmean+ {RVED}*emwa_eurodollar_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatPrices}*tau_mean_sqrt  + {YCslopePrices}*yield_curve_slope_lag_mean    + {CSpreadPrices}*CreditSpreadA10Y_lagmean+ {RVEDPrices}*emwa_eurodollar_mean)*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1 + {gammatGroup1}*tau_mean_sqrt   + {YCslope}*yield_curve_slope_lag_mean    + {CSpread}*CreditSpreadA10Y_lagmean+ {RVED}*emwa_eurodollar_mean )*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatPrices}*tau_mean_sqrt  + {YCslopePrices}*yield_curve_slope_lag_mean    + {CSpreadPrices}*CreditSpreadA10Y_lagmean+ {RVEDPrices}*emwa_eurodollar_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3) 

test _b[/INJCJCgood] = _b[/INJCJCbad]
test _b[/DGNOCHNGgood] = _b[/DGNOCHNGbad]
test _b[/NAPMPMIgood] = _b[/NAPMPMIbad]
test _b[/RSTAXMOMgood] = _b[/RSTAXMOMbad]
test _b[/CONCCONFgood] = _b[/CONCCONFbad]
test _b[/CPIgood] = _b[/CPIbad]
test _b[/NHSLTOTgood] = _b[/NHSLTOTbad]
test _b[/NFPTCHgood] = _b[/NFPTCHbad]
test _b[/TMNOCHNGgood] = _b[/TMNOCHNGbad]


eststo: nl (return = {b1} + {gamma1}*tau_mean + (1 + {gammatGroup1}*tau_mean_sqrt   + {YCslope}*yield_curve_slope_lag_mean    + {CSpread}*CreditSpreadA10Y_lagmean+ {RVED}*emwa_eurodollar_mean )*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatPrices}*tau_mean_sqrt  + {YCslopePrices}*yield_curve_slope_lag_mean    + {CSpreadPrices}*CreditSpreadA10Y_lagmean+ {RVEDPrices}*emwa_eurodollar_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 

esttab using Table5_PanelB.tex, label  title(Panel B: Macroeconomic conditions (high-frequency)) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 


* Panel C: Macroeconomic and monetary policy uncertainty 

eststo clear 
eststo:  nl (return = {b1} + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTreaPric}*emwa_10ytf_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea10Pr}*emwa_10ytf_mean) *({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3) 
test _b[/INJCJCgood] = _b[/INJCJCbad]
test _b[/DGNOCHNGgood] = _b[/DGNOCHNGbad]
test _b[/NAPMPMIgood] = _b[/NAPMPMIbad]
test _b[/RSTAXMOMgood] = _b[/RSTAXMOMbad]
test _b[/CONCCONFgood] = _b[/CONCCONFbad]
test _b[/CPIgood] = _b[/CPIbad]
test _b[/NHSLTOTgood] = _b[/NHSLTOTbad]
test _b[/NFPTCHgood] = _b[/NFPTCHbad]
test _b[/TMNOCHNGgood] = _b[/TMNOCHNGbad]

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatPrices}*tau_mean_sqrt   + {MOVEPrices}*MOVE_365_mean+ {HRSMPUPR}*HRSMPU_mean + {MUPR}*L_MacroUncertaintyh1_mean + {RVTrea10Pr}*emwa_10ytf_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) , vce(hac nwest 3)

esttab using Table5_PanelC1.tex, label  title(Panel C: Macroeconomic and monetary policy uncertainty ) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 



* with TYVIX 
eststo clear 
eststo:  nl (return = {b1} + (1+ {gammatauGroup1}*tau_mean_sqrt + {TYVIXG1}*TYVIX_365_lag_w_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean )*({INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt + {TYVIXPrices}*TYVIX_365_lag_w_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTreaPric}*emwa_10ytf_mean )*({CPI}*S_CPI)) if TYVIX_365_lag_w_mean !=. ,  vce(hac nwest 3)


eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauGroup1}*tau_mean_sqrt + {TYVIXG1}*TYVIX_365_lag_w_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt + {TYVIXPrices}*TYVIX_365_lag_w_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea10Pr}*emwa_10ytf_mean) *({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if TYVIX_365_lag_w_mean !=., vce(hac nwest 3) 
test _b[/INJCJCgood] = _b[/INJCJCbad]
test _b[/DGNOCHNGgood] = _b[/DGNOCHNGbad]
test _b[/NAPMPMIgood] = _b[/NAPMPMIbad]
test _b[/RSTAXMOMgood] = _b[/RSTAXMOMbad]
test _b[/CONCCONFgood] = _b[/CONCCONFbad]
test _b[/CPIgood] = _b[/CPIbad]
test _b[/NHSLTOTgood] = _b[/NHSLTOTbad]
test _b[/NFPTCHgood] = _b[/NFPTCHbad]
test _b[/TMNOCHNGgood] = _b[/TMNOCHNGbad]

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauGroup1}*tau_mean_sqrt + {TYVIXG1}*TYVIX_365_lag_w_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt + {TYVIXPrices}*TYVIX_365_lag_w_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea10Pr}*emwa_10ytf_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) if TYVIX_365_lag_mean !=., vce(hac nwest 3)

esttab using Table5_PanelC2.tex, label  title(Panel C: Macroeconomic and monetary policy uncertainty (2) ) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 


* Claim in footnote for maturities  

* 5 years: 
 nl (return = {b1} + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea5}*emwa_5ytf_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea5Pric}*emwa_5ytf_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

  
 eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea5}*emwa_5ytf_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea5Pric}*emwa_5ytf_mean) *({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3) 
 
 
 eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea5}*emwa_5ytf_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatPrices}*tau_mean_sqrt   + {MOVEPrices}*MOVE_365_mean+ {HRSMPUPR}*HRSMPU_mean + {MUPR}*L_MacroUncertaintyh1_mean + {RVTrea5Pric}*emwa_5ytf_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) , vce(hac nwest 3)
 
 * 2 years: 
 nl (return = {b1} + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_2ytf_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTreaPric}*emwa_2ytf_mean )*({CPI}*S_CPI )), vce(hac nwest 3)
 
 
 eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea2}*emwa_2ytf_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea2Pric}*emwa_2ytf_mean) *({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3) 
 
 
 eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea2}*emwa_2ytf_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatPrices}*tau_mean_sqrt   + {MOVEPrices}*MOVE_365_mean+ {HRSMPUPR}*HRSMPU_mean + {MUPR}*L_MacroUncertaintyh1_mean + {RVTrea2Pric}*emwa_2ytf_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) , vce(hac nwest 3)
 
 
 
 
eststo clear 

*** Panel D: Stock Market Volatility 
eststo:  nl (return = {b1} + (1+ {gammatauGroup1}*tau_mean_sqrt + {GJRG1}*Sqrt_Sigma_GJR_EW_mean  + {VIXG1}*VIX365sqrt_mean  + {RiskApG1}*L_risk_index_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatPrices}*tau_mean_sqrt  + {GJRPrices}*Sqrt_Sigma_GJR_EW_mean  + {VIXPrices}*VIX365sqrt_mean  + {RiskAprices}*L_risk_index_mean)*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauGroup1}*tau_mean_sqrt + {GJRG1}*Sqrt_Sigma_GJR_EW_mean  + {VIXG1}*VIX365sqrt_mean  + {RiskApG1}*L_risk_index_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatPrices}*tau_mean_sqrt + {GJRPrices}*Sqrt_Sigma_GJR_EW_mean + {VIXPrices}*VIX365sqrt_mean  + {RiskAprices}*L_risk_index_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3)
test _b[/INJCJCgood] = _b[/INJCJCbad]
test _b[/DGNOCHNGgood] = _b[/DGNOCHNGbad]
test _b[/NAPMPMIgood] = _b[/NAPMPMIbad]
test _b[/RSTAXMOMgood] = _b[/RSTAXMOMbad]
test _b[/CONCCONFgood] = _b[/CONCCONFbad]
test _b[/CPIgood] = _b[/CPIbad]
test _b[/NHSLTOTgood] = _b[/NHSLTOTbad]
test _b[/NFPTCHgood] = _b[/NFPTCHbad]
test _b[/TMNOCHNGgood] = _b[/TMNOCHNGbad]

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauGroup1}*tau_mean_sqrt  + {GJRG1}*Sqrt_Sigma_GJR_EW_mean + {VIXG1}*VIX365sqrt_mean + {RiskApG1}*L_risk_index_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH + {DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD + {CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatPrices}*tau_mean_sqrt + {GJRPrices}*Sqrt_Sigma_GJR_EW_mean + {VIXPrices}*VIX365sqrt_mean  + {RiskAprices}*L_risk_index_mean  )*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 

esttab using Table5_PanelD.tex, label  title(Panel D: Stock Market Volatility ) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 






***** Claim in Text: all announcements jointly 
eststo:  nl (return = {b1} + (1 + {gammatauGroup1}*tau_mean_sqrt + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean + {InflationGroup1}*l_inf_q_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean + {YCslope}*yield_curve_slope_lag_mean    + {CSpread}*CreditSpreadA10Y_lagmean+ {RVED}*emwa_eurodollar  + {GJRG1}*Sqrt_Sigma_GJR_EW_mean + {VIXG1}*VIX365sqrt_mean +  {RiskApG1}*L_risk_index_mea  + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt + {OutputgapPrices}*L_Gap_BEA_mean +  {InterestExpectationsPrices}*L_Tbill_mean + {InflationPrices}*l_inf_q_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean + {YCslopePrices}*yield_curve_slope_lag_mean    + {CSpreadPrices}*CreditSpreadA10Y_lagmean+ {RVEDPrices}*emwa_eurodollar + {GJRPri}*Sqrt_Sigma_GJR_EW_mean + {VIXPri}*VIX365sqrt_mean  + {RiskApPri}*L_risk_index_mea + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTreaPric}*emwa_10ytf_mean )*({CPI}*S_CPI )), vce(hac nwest 3)



********************************************************************************
* Figure A.5: Returns predicted by the model in Column (2) of Table 5 as a 
* 				function of Consumer Confidence
********************************************************************************

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatGroup1}*tau_mean_sqrt  + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean   + {InflationGroup1}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+  {gammatPrices}*tau_mean_sqrt  + {OutputgapPrices}*L_Gap_BEA_mean + {InflationPrices}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean +  {InterestExpectationsPrices}*L_Tbill_mean )*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if year < 2021, vce(hac nwest 3) 

global eventCC "CONCCONF" 

foreach announcement of global eventCC { 

summ tau_mean if E_`announcement'==1 & ten ==1 , detail 
local taupercentile  = 0 //r(p90) 

summ tau_mean_sqrt if E_`announcement'==1 & ten ==1, detail 
local taupercentilesqrt  = 0 //r(p90) 

summ L_Gap_BEA_mean if E_`announcement'==1 & ten ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapGroup1]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapGroup1]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapGroup1]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapGroup1]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Confidence", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))  legend(order(2 "Output gap at 90% quantile" 7 "Output gap at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_`announcement'.png",  replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 



eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatGroup1}*tau_mean_sqrt  + {OutputgapGroup1}*L_Gap_BEA_mean +  {InterestExpectationsGroup1}*L_Tbill_mean   + {InflationGroup1}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentGroup1}*L_FOMCsentiment_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+  {gammatPrices}*tau_mean_sqrt  + {OutputgapPrices}*L_Gap_BEA_mean + {InflationPrices}*l_inf_yoy_gdpdefl_mean + {FOMCsentimentPrices}*L_FOMCsentiment_mean +  {InterestExpectationsPrices}*L_Tbill_mean )*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if year < 2021, vce(hac nwest 3) 


foreach announcement of global eventCC { 

summ tau_mean if E_`announcement'==1 & ten ==1 , detail 
local taupercentile  = 0 //r(p90) 

summ tau_mean_sqrt if E_`announcement'==1 & ten ==1, detail 
local taupercentilesqrt  = 0 //r(p90) 

summ L_Tbill_mean if E_`announcement'==1 & ten ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/InterestExpectationsGroup1]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/InterestExpectationsGroup1]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/InterestExpectationsGroup1]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/InterestExpectationsGroup1]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Confidence", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))   legend(order(2 "Interest rate expectations" "at 90% quantile" 7 "Interest rate expectations" "at 10% quantile") position(11) ring(0)) 
graph export "$user/figures/Figure_A5_2_`announcement'.png",  replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 




* FOR CPI 
global eventCPI "CPI" 

foreach announcement of global eventCPI { 

summ tau_mean if E_`announcement'==1 & eightthirty ==1 , detail 
local taupercentile  = 0  //r(p10) 

summ tau_mean_sqrt if E_`announcement'==1 & eightthirty ==1, detail 
local taupercentilesqrt  =   0 //r(p10) 

summ L_Gap_BEA_mean if E_`announcement'==1 & eightthirty ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapPrices]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapPrices]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapPrices]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/OutputgapPrices]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & eightthirty ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("CPI", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))  legend(order(2 "Output gap at 90% quantile" 7 "Output gap at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_1_`announcement'.png", replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 



** Regression from Panel B: 
eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1 + {gammatGroup1}*tau_mean_sqrt   + {YCslope}*yield_curve_slope_lag_mean    + {CSpread}*CreditSpreadA10Y_lagmean+ {RVED}*emwa_eurodollar_mean )*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatPrices}*tau_mean_sqrt  + {YCslopePrices}*yield_curve_slope_lag_mean    + {CSpreadPrices}*CreditSpreadA10Y_lagmean+ {RVEDPrices}*emwa_eurodollar_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3) 



foreach announcement of global eventCC { 

summ tau_mean if E_`announcement'==1 & ten ==1 , detail 
local taupercentile  = 0 //r(p90) 

summ tau_mean_sqrt if E_`announcement'==1 & ten ==1, detail 
local taupercentilesqrt  = 0 //r(p90) 

summ yield_curve_slope_lag_mean  if E_`announcement'==1 & ten ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/CSpread]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/CSpread]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/CSpread]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/CSpread]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Confidence", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))  legend(order(2 "Term spread at 90% quantile" 7 "Term spread at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_3_`announcement'.png", replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 




** Regression from Panel C: 

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatGroup1}*tau_mean_sqrt + {MOVEG1}*MOVE_365_mean + {HRSMPUG1}*HRSMPU_mean + {MUG1}*L_MacroUncertaintyh1_mean + {RVTrea10}*emwa_10ytf_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatPrices}*tau_mean_sqrt + {MOVEPrices}*MOVE_365_mean + {HRSMPUPrices}*HRSMPU_mean + {MUPrices}*L_MacroUncertaintyh1_mean + {RVTrea10Pr}*emwa_10ytf_mean) *({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )), vce(hac nwest 3)


* for MPU 
foreach announcement of global eventCC { 

summ tau_mean if E_`announcement'==1 & ten ==1 , detail 
local taupercentile  = 0 //r(p90) 

summ tau_mean_sqrt if E_`announcement'==1 & ten ==1, detail 
local taupercentilesqrt  = 0 //r(p90) 

summ HRSMPU_mean if E_`announcement'==1 & ten ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUG1]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUG1]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUG1]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUG1]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Confidence", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))   legend(order(2 "Monetary policy uncertainty" "at 90% quantile" 7 "Monetary policy uncertainty" "at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_4_`announcement'.png", replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 




* FOR CPI 
foreach announcement of global eventCPI { 

summ tau_mean if E_`announcement'==1 & eightthirty ==1 , detail 
local taupercentile  = 0  //r(p10) 

summ tau_mean_sqrt if E_`announcement'==1 & eightthirty ==1, detail 
local taupercentilesqrt  =   0 //r(p10) 

summ HRSMPU_mean if E_`announcement'==1 & eightthirty ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUPrices]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUPrices]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUPrices]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/HRSMPUPrices]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & eightthirty ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Price Index", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))  legend(order(2 "Monetary policy uncertainty" "at 90% quantile" 7 "Monetary policy uncertainty" "at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_4_`announcement'.png", replace


drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 



* Regression from Panel D: 

eststo: nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatGroup1}*tau_mean_sqrt + {GJRG1}*Sqrt_Sigma_GJR_EW_mean  + {VIXG1}*VIX365sqrt_mean  + {RiskApG1}*L_risk_index_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad + {DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad + {CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatPrices}*tau_mean_sqrt + {GJRPrices}*Sqrt_Sigma_GJR_EW_mean + {VIXPrices}*VIX365sqrt_mean  + {RiskAprices}*L_risk_index_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3)

foreach announcement of global eventCC { 

summ tau_mean if E_`announcement'==1 & ten ==1 , detail 
local taupercentile  = 0 //r(p90) 

summ tau_mean_sqrt if E_`announcement'==1 & ten ==1, detail 
local taupercentilesqrt  = 0 //r(p90) 

summ L_risk_index_mean if E_`announcement'==1 & ten ==1, detail 
local gappercentile10  = r(p10) 
local gappercentile90  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
 
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/RiskApG1]*`gappercentile10')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/RiskApG1]*`gappercentile10')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  

gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/RiskApG1]*`gappercentile90')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatGroup1]*`taupercentilesqrt' + _b[/RiskApG1]*`gappercentile90')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)   

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten ==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40) yline(0)  sort lcolor(gold%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(gold%40)  sort lcolor(gold%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(gold) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) yline(0)  xscale(range(-2, 2)) sort lcolor(purple%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(purple%20) xscale(range(-2, 2)) sort lcolor(purple%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(purple))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(purple) xscale(range(-2, 2))),  name(`announcement', replace) title("Consumer Confidence", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2))    legend(order(2 "Risk appetite" "at 90% quantile" 7 "Risk appetite" "at 10% quantile") position(11) ring(0))
graph export "$user/figures/Figure_A5_5_`announcement'.png", replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 

*******************************************************************************
*                     A P P E N D I X     F I G U R E S 
*******************************************************************************


*********************************************************************************
*** Figure A.4: Asymmetric effects of good and bad news (piece-wise linear)
*********************************************************************************

summ tau if E_INJCJ==1, detail 
local taupercentile  = r(p90) 
local taupercentile10  = r(p10) 

disp "Annualized:" sqrt(252*`taupercentile') 
disp "Annualized:" sqrt(252*`taupercentile10') 


eststo:  nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean_sqrt)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSLTOTgood}*S_NHSLTOT_good  + {NHSLTOTbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 



foreach announcement of global eventsRealActivity830 { 

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p90) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauRealActivity]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauRealActivity]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  


gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p10) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p10) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauRealActivity]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauRealActivity]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)  

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & eightthirty==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20) yline(0)  sort lcolor(orange_red%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) yline(0)  xscale(range(-2, 2)) sort lcolor(blue%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) xscale(range(-2, 2)) sort lcolor(blue%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(blue))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(blue) xscale(range(-2, 2))), legend(off) name(`announcement', replace) title("`announcement'", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2)) 
graph export "$user/figures/Figure_A4_`announcement'.png", name(`announcement') replace


drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 




foreach announcement of global eventsInvestmentCons830 { 

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p90) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauInvestmentCons]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauInvestmentCons]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  


gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p10) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p10) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauInvestmentCons]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauInvestmentCons]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)  

gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

graph twoway (histogram S_`announcement' if E_`announcement' == 1 & eightthirty==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20) yline(0)  sort lcolor(orange_red%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) yline(0)  xscale(range(-2, 2)) sort lcolor(blue%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) xscale(range(-2, 2)) sort lcolor(blue%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(blue))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(blue) xscale(range(-2, 2))), legend(off) name(`announcement', replace) title("`announcement'", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2)) 
graph export "$user/figures/Figure_A4_`announcement'.png", name(`announcement') replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 


foreach announcement of global eventsForwardlooking10 { 

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p90) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p90) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauForwardlooking]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g)  
predictnl marginal`announcement'b = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauForwardlooking]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b)  


gen `announcement'g_upper = marginal`announcement'g+ 1.64 * semarginal`announcement'g
gen `announcement'b_upper = marginal`announcement'b+ 1.64 * semarginal`announcement'b
gen `announcement'g_lower = marginal`announcement'g- 1.64 * semarginal`announcement'g
gen `announcement'b_lower = marginal`announcement'b- 1.64 * semarginal`announcement'b

summ tau_mean if E_`announcement'==1, detail 
local taupercentile  = r(p10) 

summ tau_mean_sqrt if E_`announcement'==1, detail 
local taupercentilesqrt  = r(p10) 

disp `taupercentile' `taupercentilesqrt'
* predictnl marginal`announcement'g = _b[/`announcement'_good]*S_`announcement'_good, se(semarginal`announcement'g)  
predictnl marginal`announcement'g90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauForwardlooking]*`taupercentilesqrt')*(_b[/`announcement'good]*S_`announcement'_good), se(semarginal`announcement'g90)  
predictnl marginal`announcement'b90 = _b[/b1]+_b[/gamma1]*`taupercentile' + (1+_b[/gammatauForwardlooking]*`taupercentilesqrt')*(_b[/`announcement'bad]*S_`announcement'_bad), se(semarginal`announcement'b90)  


gen `announcement'g_upper90 = marginal`announcement'g90+ 1.64 * semarginal`announcement'g90
gen `announcement'b_upper90 = marginal`announcement'b90+ 1.64 * semarginal`announcement'b90
gen `announcement'g_lower90 = marginal`announcement'g90- 1.64 * semarginal`announcement'g90
gen `announcement'b_lower90 = marginal`announcement'b90- 1.64 * semarginal`announcement'b90

  
graph twoway (histogram S_`announcement' if E_`announcement' == 1 & ten==1 & S_`announcement' > -2 & S_`announcement' < 2, yaxis(2) fcolor(gs14%40) fintensity(20)  lcolor(gs9) xscale(range(-2, 2)) graphregion(color(white)) bgcolor(white) ylabel(,nogrid) xline(0, lwidth(thin) lcolor(black)))    (rarea `announcement'g_upper90  `announcement'g_lower90 S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20) yline(0)  sort lcolor(orange_red%0) xscale(range(-2, 2)))   (rarea `announcement'b_upper90  `announcement'b_lower90 S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(orange_red%20)  sort lcolor(orange_red%0) xscale(range(-2, 2)))    (line marginal`announcement'g90  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2)) yaxis(1) yscale(alt) yscale(alt axis(2)))   (line marginal`announcement'b90  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(orange_red) xscale(range(-2, 2))) (rarea `announcement'g_upper  `announcement'g_lower S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) yline(0)  xscale(range(-2, 2)) sort lcolor(blue%0))  (rarea `announcement'b_upper  `announcement'b_lower S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, fcolor(blue%20) xscale(range(-2, 2)) sort lcolor(blue%0))    (line marginal`announcement'g  S_`announcement'_good if S_`announcement' > -2 & S_`announcement' < 2, xscale(range(-2, 2)) lcolor(blue))   (line marginal`announcement'b  S_`announcement'_bad if S_`announcement' > -2 & S_`announcement' < 2, lcolor(blue) xscale(range(-2, 2))), legend(off) name(`announcement', replace) title("`announcement'", size(large)) xline(0) xscale(range(-2, 2))   ytitle("Predicted return") xtitle("Standardized surprise") xscale(range(-2, 2)) 
graph export "$user/figures/Figure_A_4_`announcement'.png", name(`announcement') replace

drop `announcement'g_upper90 `announcement'b_upper90  `announcement'g_lower90 `announcement'b_lower90 marginal`announcement'b90 marginal`announcement'g90 semarginal`announcement'g90 semarginal`announcement'b90 `announcement'g_upper `announcement'b_upper  `announcement'g_lower `announcement'b_lower marginal`announcement'b marginal`announcement'g semarginal`announcement'g semarginal`announcement'b
} 





*******************************************************************************
*                     A P P E N D I X     T A B L E S
*******************************************************************************



*********************************************************************************
* Table A.5: Time-varying sensitivity and additional predictors (Robustness)
*********************************************************************************

* Panel A 
eststo clear 
eststo:  nl (return = {b1} + (1 + {FOMCsentimentGroup1}*L_FOMCsentiment_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {FOMCsentimentPrices}*L_FOMCsentiment_mean )*({CPI}*S_CPI )) if year < 2021,  vce(hac nwest 3)

eststo:  nl (return = {b1} + (1 + {OutputgapGroup1}*L_Gap_BEA_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {OutputgapPrices}*L_Gap_BEA_mean )*({CPI}*S_CPI )) ,  vce(hac nwest 3)

eststo:  nl (return = {b1} + (1+  {InterestExpectationsGroup1}*L_Tbill_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 +  {InterestExpectationsPrices}*L_Tbill_mean)*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo:  nl (return = {b1} + (1+ {InflationGroup1}*l_inf_q_gdpdefl_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {InflationPrices}*l_inf_q_gdpdefl_mean )*({CPI}*S_CPI )),  vce(hac nwest 3)

esttab using "$user/tables/TableA5_PanelA.tex", label  title(Baseline with add. predictors, Panel A) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 


* Panel B: 

eststo clear 
eststo:  nl (return = {b1} +  (1 + {YCslope}*yield_curve_slope_lag_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {YCslopePrices}*yield_curve_slope_lag_mean )*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo:  nl (return = {b1} +  (1  +  {CSpread}*CreditSpreadA10Y_lagmean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1  + {CSpreadPrices}*CreditSpreadA10Y_lagmean)*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo:  nl (return = {b1} +  (1  + {RVED}*emwa_eurodollar_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {RVEDPrices}*emwa_eurodollar_mean)*({CPI}*S_CPI )),  vce(hac nwest 3)


esttab using "$user/tables/TableA5_PanelB.tex", label  title(Baseline with add. predictors, Panel B) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 



* Panel C: Macroeconomic uncertainty 

eststo clear 
eststo:  nl (return = {b1} + (1+  {MOVEG1}*MOVE_365_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1  + {MOVEPrices}*MOVE_365_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

eststo:  nl (return = {b1} + (1 + {HRSMPUG1}*HRSMPU_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {HRSMPUPrices}*HRSMPU_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

eststo:  nl (return = {b1} + (1  + {MUG1}*L_MacroUncertaintyh1_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {MUPrices}*L_MacroUncertaintyh1_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

eststo:  nl (return = {b1} + (1 + {RVTrea10}*emwa_10ytf_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {RVTreaPric}*emwa_10ytf_mean )*({CPI}*S_CPI )), vce(hac nwest 3)

eststo:  nl (return = {b1} + (1 + {TYVIXG1}*TYVIX_365_lag_w_mean  )*({INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {TYVIXPrices}*TYVIX_365_lag_w_mean  )*({CPI}*S_CPI)) if TYVIX_365_lag_mean !=. ,  vce(hac nwest 3)

esttab using "$user/tables/TableA5_PanelC.tex", label  title(Baseline with add. predictors) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 


*** Panel E: 
eststo clear
eststo:  nl (return = {b1} + (1 + {GJRG1}*Sqrt_Sigma_GJR_EW_mean )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {GJRPrices}*Sqrt_Sigma_GJR_EW_mean )*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo:  nl (return = {b1} + (1 +  {VIXG1}*VIX365sqrt_mean  )*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {VIXPrices}*VIX365sqrt_mean )*({CPI}*S_CPI )),  vce(hac nwest 3)

eststo:  nl (return = {b1} + (1+  {RiskApG1}*L_risk_index_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM + {DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1 + {RiskAprices}*L_risk_index_mean)*({CPI}*S_CPI )),  vce(hac nwest 3)


esttab using "$user/tables/TableA5_PanelD.tex", label  title(Baseline with add. predictors) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)   b(3)  se(3) 
eststo clear 







*********************************************************************************
* Table A.7: Regression for baseline specification and time-varying sensitivity 
* using the long-term variance instead of the long-term volatility.
*********************************************************************************

eststo clear
eststo:  nl (return =  {b1}+  (1+ {gammat}*tau_mean)*($regression ) ),  vce(hac nwest 3)

eststo:  nl (return = {b1}+ (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI )) , vce(hac nwest 3)  

eststo:  nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 

esttab using "$user/tables/TableA7.tex", label  title(Regressions using the long-term variance instead of the long-term volatility) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear






*********************************************************************************
* Table A.8: Heterogeneity in the time-varying sensitivity to news 
*			across announcements (with 1 and 10 minute)
*********************************************************************************
eststo clear
eststo:  nl (return1min = {b1}+ (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI )) , vce(hac nwest 3)  

eststo:  nl (return1min = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean_sqrt)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 

eststo: nl (return1min = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 

eststo:  nl (return10min = {b1}+ (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI )) , vce(hac nwest 3)  

eststo:  nl (return10min = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean_sqrt)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 

eststo: nl (return10min = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ), vce(hac nwest 3) 


esttab using "$user/tables/TableA8.tex", label  title(Table 8) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear


*********************************************************************************
* Table A.9: Exclude FOMC und ECB 
*********************************************************************************
 
eststo clear   

eststo:  nl (return =  {b1}+  (1+ {gammat}*tau_mean)*($regression ) ) if FOMC==0 & ecbpress ==0,  vce(hac nwest 3)

eststo:  nl (return = {b1}+ (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI )) if FOMC==0 & ecbpress ==0, vce(hac nwest 3)  

eststo:  nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if FOMC==0 & ecbpress ==0, vce(hac nwest 3) 

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) if FOMC==0 & ecbpress ==0, vce(hac nwest 3) 

esttab using "$user/tables/TableA9.tex", label  title(Excluding FOMC and ECB Press Conference Days) ar2 replace se longtable star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear 


*********************************************************************************
* Table A.10: Baseline Model with time-varying sensitivity separetely for 8:30 am and 10:00 am EST 
*********************************************************************************

global regressionsquared10 "{NHSLTOTSq}*Sq_S_NHSLTOT  + {TMNOCHNGSq}*Sq_S_TMNOCHNG   + {CONCCONFSq}*Sq_S_CONCCONF  + {NAPMPMISq}*Sq_S_NAPMPMI "
global regressionsquared830 "{INJCJCSq}*Sq_S_INJCJC + {NFPTCHSq}*Sq_S_NFPTCH + {RSTAXMOMSq}*Sq_S_RSTAXMOM +  {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {CPISq}*Sq_S_CPI  "

local Sevents830 = " S_INJCJC S_NFPTCH S_RSTAXMOM  S_DGNOCHNG  S_CPI"
local Sevents10= "S_NHSLTOT S_TMNOCHNG S_CONCCONF  S_NAPMPMI" 


eststo clear 

eststo:  nl (rm83emini = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression830  )) if eightthirty == 1,  vce(robust)

eststo:  nl (rm83emini = {b1}+ (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG)  + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI )) if eightthirty == 1, vce(hac nwest 3)  

eststo:  nl (rm83emini = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad)  + (1+ {gammatauPrices}*tau_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if eightthirty == 1, vce(hac nwest 3) 

eststo: nl (rm83emini = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  )  + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) if eightthirty == 1, vce(hac nwest 3) 


esttab using "$user/tables/TableA10_1.tex", label  title(Separate regressions for 8:30 am announcements) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3) 
eststo clear 

 
eststo clear 
eststo:  nl (rm10emini = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression10  ))  if ten==1,  vce(robust)

eststo:  nl (rm10emini = {b1}+ (1+ {gammatauInvestmentCons}*tau_mean)* ( {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI )) if ten==1, vce(hac nwest 3)  

eststo:  nl (rm10emini = {b1} + {gamma1}*tau_mean  +  (1+ {gammatauInvestmentCons}*tau_mean)* ({TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) ) if ten==1, vce(hac nwest 3) 

eststo: nl (rm10emini = {b1} + {gamma1}*tau_mean +  (1+ {gammatauInvestmentCons}*tau_mean)* ( {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI)  ) if ten==1, vce(hac nwest 3) 
esttab using "$user/tables/TableA10_2.tex", label  title(Separate regressions for 10:00 am announcements) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear 


 
*********************************************************************************
* Table A.11: Robustness Checks with S&P 500 at 10:00 am  
*********************************************************************************
eststo clear 

eststo:  nl (returnSP5005min = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression10  ))  if ten==1,  vce(robust)

eststo:  nl (returnSP5005min = {b1}+ (1+ {gammatauInvestmentCons}*tau_mean)* ( {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI )) if ten==1, vce(hac nwest 3)  

eststo:  nl (returnSP5005min = {b1} + {gamma1}*tau_mean  +  (1+ {gammatauInvestmentCons}*tau_mean)* ({TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) ) if ten==1, vce(hac nwest 3) 

eststo: nl (returnSP5005min = {b1} + {gamma1}*tau_mean +  (1+ {gammatauInvestmentCons}*tau_mean)* ( {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI)  ) if ten==1, vce(hac nwest 3) 

esttab using "$user/tables/TableA11_SP5005min.tex", label  title(Regression of 10:00 events) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3) 
eststo clear   




*******************************************************************************
***** Table A.12: Excluding the Covid-19 pandemic
*******************************************************************************

eststo clear 
eststo:  nl (return =  {b1}+  (1+ {gammat}*tau_mean)*($regression ) ) if year < 2020,  vce(hac nwest 3)

eststo:  nl (return = {b1}+ (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI )) if year < 2020, vce(hac nwest 3)  

eststo:  nl (return = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) if year < 2020, vce(hac nwest 3) 

eststo: nl (return = {b1} + {gamma1}*tau_mean + (1+ {gammatauRealActivity}*tau_mean)*( {INJCJC}*S_INJCJC + {INJCJCSq}*Sq_S_INJCJC* S_INJCJC_goodD  + {RSTAXMOM}*S_RSTAXMOM + {RSTAXMOMSq}*Sq_S_RSTAXMOM *S_RSTAXMOM_goodD+ {NFPTCH}*S_NFPTCH + {NFPTCHSq}*Sq_S_NFPTCH) +  (1+ {gammatauInvestmentCons}*tau_mean)* ({DGNOCHNG}* S_DGNOCHNG + {DGNOCHNGSq}*Sq_S_DGNOCHNG  + {TMNOCHNG}*S_TMNOCHNG + {TMNOCHNGSq}*Sq_S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT + {NHSLTOTSq}*Sq_S_NHSLTOT * S_NHSLTOT_goodD) + (1+ {gammatauForwardlooking}*tau_mean)*({CONCCONF}*S_CONCCONF + {CONCCONFSq}*Sq_S_CONCCONF + {NAPMPMI}*S_NAPMPMI + {NAPMPMISq}*Sq_S_NAPMPMI) + (1+ {gammatauPrices}*tau_mean)*({CPI}*S_CPI + {CPISq}*Sq_S_CPI)  ) if year < 2020, vce(hac nwest 3) 

esttab using "$user/tables/TableA12.tex", label  title(Regression excluding the COVID-19 pandemic.) ar2 replace se  star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear 



*************************************************************************************
* Table A.13: European Extension 
* 			  Baseline Model with time-varying sensitivity using EuroStoxx Data
*************************************************************************************

eststo clear 

eststo:  nl (returnEStoxx = {b1} + (1+ {gammat}*tau_mean_sqrt)*($regression )) ,  vce(hac nwest 3)

eststo:  nl (returnEStoxx = {b1}+ (1+ {gammatauRealActivity}*tau_mean_sqrt)*( {INJCJC}*S_INJCJC + {NFPTCH}*S_NFPTCH +  {RSTAXMOM}*S_RSTAXMOM ) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNG}* S_DGNOCHNG + {TMNOCHNG}*S_TMNOCHNG + {NHSLTOT}* S_NHSLTOT) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONF}*S_CONCCONF  + {NAPMPMI}*S_NAPMPMI ) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPI}*S_CPI )) , vce(hac nwest 3)  

eststo:  nl (returnEStoxx = {b1} + {gamma1}*tau_mean  + (1+ {gammatauRealActivity}*tau_mean_sqrt)*({INJCJCgood}*S_INJCJC_good+ {INJCJCbad}*S_INJCJC_bad  + {NFPTCHgood}*S_NFPTCH_good  + {NFPTCHbad}*S_NFPTCH_bad + {RSTAXMOMgood}*S_RSTAXMOM_good  +  {RSTAXMOMbad}*S_RSTAXMOM_bad) +  (1+ {gammatauInvestmentCons}*tau_mean_sqrt)* ({DGNOCHNGgood}*S_DGNOCHNG_good + {DGNOCHNGbad}*S_DGNOCHNG_bad + {TMNOCHNGgood}*S_TMNOCHNG_good + {TMNOCHNGbad}*S_TMNOCHNG_bad + {NHSgood}*S_NHSLTOT_good  + {NHSbad}*S_NHSLTOT_bad ) + (1+ {gammatauForwardlooking}*tau_mean_sqrt)*({CONCCONFgood}*S_CONCCONF_good+ {CONCCONFbad}*S_CONCCONF_bad + {NAPMPMIgood}*S_NAPMPMI_good   + {NAPMPMIbad}*S_NAPMPMI_bad) + (1+ {gammatauPrices}*tau_mean_sqrt)*({CPIgood}*S_CPI_good + {CPIbad}*S_CPI_bad )) , vce(hac nwest 3) 

esttab using "$user/tables/TableA13.tex", label  title(Table A13 European Extension) ar2 replace se star(* 0.10 ** 0.05 *** 0.01)  b(3)  se(3)  
eststo clear



*******************************************************************************
***** Table A.4 (Panel B): Correlations 
*******************************************************************************

use "$user/merged data/TimeSeriesData.dta", clear 
gen ym = ym(year(date), month(date))
format ym %tm

collapse (mean) htau tau h L_Gap_BEA L_FOMCsentiment L_MacroUncertaintyh1 HRSMPU l_inf_q_gdpdefl L_Tbill3Mean quarter year, by(ym)

gen htau_sqrt = sqrt(htau)
gen h_sqrt = sqrt(h)
gen tau_sqrt = sqrt(tau)


corr htau_sqrt tau_sqrt
corr htau_sqrt h_sqrt
corr htau_sqrt L_FOMCsentiment
corr htau_sqrt L_MacroUncertaintyh1
corr htau_sqrt HRSMPU
corr htau_sqrt l_inf_q_gdpdefl

corr tau_sqrt L_FOMCsentiment
corr tau_sqrt L_MacroUncertaintyh1
corr tau_sqrt HRSMPU
corr tau_sqrt l_inf_q_gdpdefl


corr h_sqrt L_FOMCsentiment
corr h_sqrt L_MacroUncertaintyh1
corr h_sqrt HRSMPU
corr h_sqrt l_inf_q_gdpdefl
corr h_sqrt tau_sqrt

corr L_FOMCsentiment l_inf_q_gdpdefl
corr L_FOMCsentiment L_MacroUncertaintyh1
corr L_FOMCsentiment  HRSMPU


corr L_MacroUncertaintyh1 HRSMPU
corr L_MacroUncertaintyh1 l_inf_q_gdpdefl
corr HRSMPU l_inf_q_gdpdefl

* For quarterly frequency: 
gen qtr = yq(year, quarter) 
format qtr %tq

collapse (mean) htau tau h L_Gap_BEA L_FOMCsentiment L_MacroUncertaintyh1 HRSMPU l_inf_q_gdpdefl L_Tbill3Mean, by(qtr)
sort qtr

gen htau_sqrt = sqrt(htau)
gen h_sqrt = sqrt(h)
gen tau_sqrt = sqrt(tau)


corr htau_sqrt L_Gap_BEA
corr htau_sqrt L_Tbill3Mean

corr tau_sqrt L_Gap_BEA
corr tau_sqrt L_Tbill3Mean

corr h_sqrt L_Gap_BEA
corr h_sqrt L_Tbill3Mean


corr L_Gap_BEA L_FOMCsentiment
corr L_Gap_BEA l_inf_q_gdpdefl
corr L_Gap_BEA L_Tbill3Mean
corr L_Gap_BEA L_MacroUncertaintyh1
corr L_Gap_BEA  HRSMPU

corr L_Tbill3Mean L_FOMCsentiment
corr L_Tbill3Mean l_inf_q_gdpdefl
corr L_Tbill3Mean L_MacroUncertaintyh1
corr L_Tbill3Mean HRSMPU




log close 
