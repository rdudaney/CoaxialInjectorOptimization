function [avg_drop,W_l,q,flame_temp,SCFM] = PerfCode_func(T_l,d_1,gap,P_a,v_l)
% Function to calculate all necessary values for optimization code

%setting d1 = d2 since there is no thickness in this problem
d_2 = d_1;
d_3 = d_2 + 2*gap;

P_b = 14.7*6894.76; %Back pressure(Pa)

Tii_Air = 70; %F % Initial Air temp before heating
Tii_Air = (Tii_Air+459.67)*5/9; % F to K

T_a_0 = 600; %F % Air Temp after heating
T_a_0 = (T_a_0+459.67)*5/9; % F to K

% Properties of Air
MW = 28.97; %g/mol
gam = 1.4;
Cp_Air = 1.02; % kJ/(kg-K)

% Properties of the liquid
rho_l = 11441-1.2795*T_l; %kg/m^3
mu_l = 4.55*10^-4*exp(1069/T_l); %Pa * s
sigma_l  = (525.9-0.113*T_l)*10^-3; %N/m

%Initial calculations
A_l = pi/4*d_1^2; % m^2
A_a = pi/4*(d_3^2-d_2^2); % m^2

P_ratio = P_b/P_a;
[MACH, T_ratio, ~, ~, ~] = flowisentropic(gam, P_ratio, 'press');


T_a = T_ratio*T_a_0;
rho_a = P_b/((8314/MW)*T_a); % exit air density (kg/m^3)
v_a  = MACH*sqrt(1.4*8314/28.97*T_a); % exit air velocity (m/s)

V = v_a-v_l;% Relative air velocity (m/s)

% Additional air properties
mu_a = airProp2(T_a,{'my'}); % Viscosity of air at exit (kg/(m*s))

Q_a = A_a*v_a; % Volumetric Flowrate of Air (m^3/s)

W_l = rho_l*A_l*v_l; % mass flowrate of the liquid (kg/s)
W_a = rho_a*A_a*v_a; % mass flowrate of the air (kg/s)

OF = W_a/W_l; % Mass flux Ratio

%% Weiss & Worsham
d_ww = Weiss_Worsham(sigma_l,mu_l,rho_l,W_l,rho_a,mu_a,V);


%% Mayer
d_m = Mayer(mu_l,sigma_l,rho_a,v_a,rho_l);



%% Kim, Marshall
d_km = Kim_Marshall(sigma_l,mu_l,rho_l,rho_a,V,W_l,W_a,A_a);

avg_drop = mean([d_ww,d_m,d_km])*10^6;
q = W_a*(Cp_Air*(T_a_0-Tii_Air));
SCFM = Q_a.*2118.88*(288.7/T_a);
[flame_temp] = flameTemp(OF,T_l,T_a);

end

