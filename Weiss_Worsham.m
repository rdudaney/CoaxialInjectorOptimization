function [d] = Weiss_Worsham(sigma_l,mu_l,rho_l,W_l,rho_a,mu_a,V)

d = (sigma_l/(rho_a*V^2))*0.61*(V*mu_l/sigma_l)^(2/3)*(1+10^3*rho_a/rho_l)*(W_l*rho_l*sigma_l*mu_a/(mu_l^4))^(1/12);

end

