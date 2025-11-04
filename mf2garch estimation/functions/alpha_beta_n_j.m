function [sum_alpha_beta] = alpha_beta_n_j(alpha, gamma, beta, j)

sum_alpha_beta = 0;
		
for k = 1:j-2

sum_alpha_beta = sum_alpha_beta + ((alpha + gamma/2)+beta)^(k);

end
