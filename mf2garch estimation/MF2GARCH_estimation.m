%% Code for estimating an (MF)^2 GARCH-rw-m in mean Model
% Christian Conrad & Julius Schoelkopf 
% Heidelberg University, February 2024 

clear 
close all
clc

addpath 'functions/'

% Read in return data

data = readtable('SPdailyneu.csv');
y = 100*diff(log(data.Close(1:end,1)));
date = data.Date(1:end,1); 
year = data.year(1:end,1); 
day = data.day(1:end,1); 
month = data.month(1:end,1); 

% parameters: mu, alpha, gamma, beta, lambda_0, lambda_1, lambda_2
% start values
param_init = [0.02; 0.007; 0.14 ; 0.85; mean(y.^2)*(1-0.07-0.91); 0.07; 0.91 ]; % m = 63


% constraints:
% alpha >=0
% alpha + gamma/2 + beta <=1
% lambda_1 >= 0
% lambda_1 + lambda_2 <=1
A = [  ...
    0.0 -1.0  0.0  0.0  0.0  0.0  0.0; ...
    0.0 1.0  0.5  1.0  0.0  0.0  0.0; ...
    0.0 0.0  0.0  0.0  0.0  -1.0  0.0; ...
    0.0 0.0  0.0  0.0  0.0  1.0  1.0...
];
b = [  0.0; 1.0; 0.0; 1.0 ];

Aeq = [];
beq = []; 
nlc = [];
% bounds:
LB = [-1; 0.0 ; -0.5; 0.0; 0.000001; 0.0; 0.0 ];
UB = [ 1; 1.0 ; 0.5; 1.0; 10.0; 1.0; 1.0 ];
%options = optimset('fmincon');
options = optimoptions(@fmincon,'Algorithm','sqp', 'Display', 'off'); 

% k = parameters estimated by the model 
k = 7; 

BIC=zeros(30,1); 
SigmaMatrix = zeros(6324,6324+252); 
Matrix = zeros(6324,5); 
CoefficientsMF2 = zeros(6324,7); 

for i = 1:6324
    % estimation
    for cm = 50:80
    [coeff, ll, ~, ~, ~, grad, ~] = fmincon('likelihood_mf2_garch', param_init, A, b, Aeq, beq, LB, UB, nlc, options, y(230:7173+i), cm);
    BIC(cm-49) = k*log(7174-230+i)+2*ll;  
    end 
    minimum =  min(BIC);
    m = find(BIC ==minimum)+49; 
    [ coeff, ll, exitFlag, ~, ~, ~, hessian ] = fmincon('likelihood_mf2_garch', param_init, A, b, Aeq, beq, LB, UB, nlc, options, y(230:7173+i), m);
    [ e, h, tau, V_m ] = mf2_garch_core(coeff, y(230:7173+i), m);

    [ kappa, horizon, forecast, an_vola_forecast, h_forecast, tau_forecast] = mf2_garch_forecasting( y(230:7173+i), e, h, tau, m, coeff);
    Matrix(i,:) = [forecast(length(h)+1) tau_forecast(length(tau)+1) h_forecast(length(h)+1) an_vola_forecast(1) m]; 
    SigmaMatrix(i,i:i+252-1) = forecast(length(h)+1:length(h)+252)'; 
    CoefficientsMF2(i,:) = coeff'; 

    i 
end

%% Export results for analysis 
T = table(year(7175:7175+6323,1), month(7175:7175+6323,1), day(7175:7175+6323,1), Matrix);
filename = 'MF2optimalBICChoiceEWMatrix20240326Deltatau.xlsx';
writetable(T,filename,'Sheet',1)

save MF2optimalBICChoiceEW20240226Deltatau Matrix SigmaMatrix 
