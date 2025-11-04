

data = readtable('SPdailyneu2.csv');
y = 100*diff(log(data.Close(1:end,1)));
date = data.Date(1:end,1); 
year = data.year(1:end,1); 
day = data.day(1:end,1); 
month = data.month(1:end,1); 

for i = 1:6325
Mdl = gjr('GARCHLags',1,'ARCHLags',1);
EstMdl = estimate(Mdl,y(30:7173+i));

numPeriods = 1;
vF = forecast(EstMdl,numPeriods,y(30:7173+i));
Matrix(i,:) = vF; 
end 


T = table(year(7175:end-1,1), month(7175:end-1,1), day(7175:end-1,1), Matrix);
%T = table(year(12670:end,1), month(12670:end,1), day(12670:end,1), Matrix);
filename = 'GJR_EW.xlsx';
writetable(T,filename,'Sheet',1)