function [sum_predetermined_m] = sum_predetermined(r2, h_forecast, s, t, m)

sum_predetermined_m = 0;

for j = s:m

sum_predetermined_m = sum_predetermined_m + r2(t+s-j)./h_forecast(t+s-j);

end