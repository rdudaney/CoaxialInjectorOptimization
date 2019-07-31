function [L] = Lash_Hop(d_1,MMF,sigma_l,mu_a,v_a)

L = 6*d_1/sqrt(MMF*(1-0.001*sigma_l/(mu_a*v_a)));

end

