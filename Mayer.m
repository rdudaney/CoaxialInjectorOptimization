function [d] = Mayer(mu_l,sigma_l,rho_g,v_g,rho_l)
B = 0.30;
d = 9*pi*B*(16)^(1/3)*(mu_l*sqrt(sigma_l)/(rho_g*v_g^2*sqrt(rho_l)))^(2/3);

end

