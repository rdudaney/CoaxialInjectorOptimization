function [x] = Kim_Marshall(sigma_l,mu_l,rho_l,rho_a,V,W_l,W_a,A_a)
% x = microns
% sigma = dynes/cm
% mu = cp
% v = ft/s
% A = ft^2
% rho = lb/ft^3
% W = lb/min

sigma_l = sigma_l*1000; % N/m to dynes/cm
mu_l = mu_l * 1000; % Pa*s to centipoise
rho_l = rho_l/1000*62.428; % kg/m^3 to lb/ft^3
rho_a = rho_a/1000*62.428; % kg/m^3 to lb/ft^3
V = V*3.28084; % m/s to  ft/s
W_l = W_l *132.277; % kg/s to lb/min
W_a = W_a *132.277; % kg/s to lb/min
A_a = A_a * 10.7639; % m^2 to ft^2


if W_a/W_l > 3
    q = -0.5;
else
    q = -1;
end

x =(249*sigma_l^0.41*mu_l^0.32)/((V^2*rho_a)^0.57*A_a^0.36*rho_l^0.16)+1260*(mu_l^2/(rho_l*sigma_l))^0.17*(1/(V^0.54))*(W_a/W_l)^(q); % directly from paper 

x = x*10^-6; %microns to m
end

