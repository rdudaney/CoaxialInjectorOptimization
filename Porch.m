function [L] = Porch(d_1,rho_a,rho_l,On,MMF)

L = d_1*2.85*(rho_a/rho_l)^-0.38*On^0.34*MMF^-0.13;

end

