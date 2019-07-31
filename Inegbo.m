function [x] = Inegbo (D_l,rho_a,a_a,mu_l,sigma_l,rho_l,v_rms,mu_a)
We_Re = (D_l^2*rho_a^2*a_a^3)/(mu_l*sigma_l);

D0_D32 = (4.33*10^-11)*(We_Re*rho_a/rho_l)^0.44*(rho_l*v_rms^3/(9.81*mu_a))^0.75;
x = D_l/D0_D32;

end

