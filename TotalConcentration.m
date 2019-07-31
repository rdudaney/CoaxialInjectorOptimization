clear
close all
clc


% Inputs
T_l = 750;% F
T_a_0 = 600;% F
T_l = (T_l+459.67)*5/9;% F to K
T_a_0 = (T_a_0+459.67)*5/9; % F to K

% P_l = 65*6894.76; %(Pa)
P_b = 14.7*6894.76; %(Pa)

MW_pb = 0.2072; % kg/mole
Na = 6.022e23; %Avogadros nummber

d_1 = 3/8*0.0254; % Diameter of liquid tube (m)
thk = 0.02*0.0254;
d_2 = d_1 + 2*thk; %  (m)
gap = 0.784053* 0.0254; % d_1 = 3/8, thk = 0.02", P = 14.7/0.5283 psia
% gap = 0.5928755* 0.0254; % d_1 = 3/8, thk = 0.02", P = 50 psia
% gap = 0.432187* 0.0254; % d_1 = 0.21, thk = 0.02", P = 14.7/0.5283 psia
% gap = 0.325572* 0.0254; % d_1 = 0.21, thk = 0.02", P = 50 psia
% gap = 0.327191* 0.0254; % d_1 = 0.211, thk = 0.02", P = 50 psia
d_3 = d_2 + 2*gap;

P_a = 14.7/0.528282.*6894.76; %(Pa)
v_l = 5*30.48/100;

[OF,MMF,MMR,We,Re_l,d_ww,d_m,d_km,d_in,L_er,L_en,L_l,L_p,L_le,L_lh,v_a,Q_a,Q_l,A_l,rho_l,W_l,P_ratio,MACH,T_ratio,T_a,rho_a,A_a,W_a,A_ratio,A_throat,d_throat,MACH_sub,v_sub,d_sub,A_sub] = PerfCode_func(T_l,T_a_0,P_b,d_1,d_2,d_3,P_a,v_l); 

%% Extra Calculations
CFM =  Q_a.*2118.88;
SCFM = Q_a.*2118.88*(288.7/T_a);
h_l = (0.5*rho_l*v_l^2)/(9.8*rho_l);
v_avg = W_a/(W_l+W_a)*v_a+W_l/(W_l+W_a)*v_l;

%% Heater calculations
q_max = 70; %kW

Tf_Pb = 650; %F
Tii_Air = 70; %F % Initial Air temp before heating

Tf_Pb = (Tf_Pb+459.67)*5/9; % F to K
Tii_Air = (Tii_Air+459.67)*5/9; % F to K

Cp_Pb = (176.2-4.923e-2*T_l + 1.544e-5*T_l^2- 1.524e6 * T_l^-2)/1000; % kJ/(kg-K)
Cp_Air = 1.02; % kJ/(kg-K)

% Ti_Air and W_a_hot are dependent on eachother, q_max and Ti_Air are also
% constrained, use optimization code to maximize W_a_hot, with q_max and
% Ti_Air constrained, or make two separate eq, hitting the other boundary,
% and see wchi is max.

T_air_max = 650; %F %Max temperature the air can be brought to (570)
T_air_max = (T_air_max+459.67)*5/9; % F to K

% 
% 
% T_ratio_heater = T_ratio;
% 
% % Case 1: Hit T_max before q_max
% W_a_hot_1 = (-W_l*Cp_Pb*(T_l-Tf_Pb))/(Cp_Air*(T_ratio_heater*T_air_max-Tf_Pb))
% T_air_1 = T_air_max;
% q_1 = W_a_hot_1*Cp_Air*(T_air_max - Tii_Air);
% 
% % Case 2: Hit q_max before T_air_max
% W_a_hot_2 = (-W_l*Cp_Pb*(T_l-Tf_Pb)-T_ratio_heater*q_max)/(Cp_Air*(T_ratio_heater*Tii_Air-Tf_Pb))
% T_air_2 = q_max/(W_a_hot_2*Cp_Air)+Tii_Air;
% q_2 = q_max;
% 
% if T_air_2 <= T_air_max
%     Ti_Air = T_air_2;
%     W_a_hot = W_a_hot_2
%     q = q_2;
% else
%     Ti_Air = T_air_1;
%     W_a_hot = W_a_hot_1
%     q = q_1;
% end
% 
% % Plot function and constraints (Want T_air as low as possible for max
% % W_air, while meeting q constraint)
% x2 = linspace((300+459.67)*5/9,T_air_max,2^14);
% x1_func = (-W_l*Cp_Pb*(T_l-Tf_Pb))./(Cp_Air.*(T_ratio_heater*x2-Tf_Pb));
% x1_cons = q_max./(Cp_Air*(x2-Tii_Air));
% x2_cons = linspace(T_air_max,T_air_max,2^14);
% 
% figure(1)
% hold on
% plot(x2,x1_func)
% plot(x2,x1_cons,'r')
% plot(x2_cons,linspace(0,1,2^14),'k')
% legend('Objective Function','q_{max} (less than)','T_{air max} (less than)')
% xlabel('T_{air} (K)')
% ylabel('Air Mass Flowrate (kg/s)')
% ylim([0 W_a])
% hold off

W_a_hot = q_max/(Cp_Air*(T_air_max-Tii_Air))
Ti_Air = T_air_max;

% Ti_Air = Tf_Pb - 1/OF*Cp_Pb*(T_l-Tf_Pb)/Cp_Air;
% W_a_hot = q_max/(Cp_Air*(Ti_Air-Tii_Air));

% T_q = [Tii_Air Ti_Air];
% I = 0.0004/3*T_q.^3-0.1717/2*T_q.^2+1024.6*T_q;
% W_a_hot = q_max / ((I(2)-I(1))/1000);


W_a_cold = W_a - W_a_hot;
rho_a_cold = P_b/((8314/28.97)*Tii_Air*T_ratio);
rho_a_hot = P_b/((8314/28.97)*Ti_Air*T_ratio);


A_a_hot = W_a_hot/(rho_a_hot*v_a);
A_a_cold = W_a_cold/(rho_a_cold*v_a);

d_hot_inner = (3/4)*0.0254;
d_hot_outer = sqrt(4/pi*A_a_hot+d_hot_inner^2);

d_cold_inner = (2*0.736)*0.0254;
d_cold_outer = sqrt(4/pi*A_a_cold+d_cold_inner^2);

num_fit_hot = A_a_hot/(pi/4*(0.844*0.0254)^2)
num_fit_cold = A_a_cold/(pi/4*(0.844*0.0254)^2)

[MACH_fit_hot, T_ratio_fit_hot, ~, ~, ~] = flowisentropic(1.4, 3*(pi/4*(0.844*0.0254)^2)/A_a_hot, 'sub')
v_fit_hot = MACH_fit_hot*sqrt(1.4*8314/28.97*Ti_Air*T_ratio_fit_hot)

[MACH_fit_cold, T_ratio_fit_cold, ~, ~, ~] = flowisentropic(1.4, 3*(pi/4*(0.844*0.0254)^2)/A_a_cold, 'sub')
v_fit_cold = MACH_fit_cold*sqrt(1.4*8314/28.97*Tii_Air*T_ratio_fit_cold)

SCFM_hot = W_a_hot/rho_a_hot.*2118.88*(288.7/(Ti_Air*T_ratio))
SCFM_cold = W_a_cold/rho_a_cold.*2118.88*(288.7/(Tii_Air*T_ratio))

W_a_hot_perc = W_a_hot/W_a *100


% AN 1/2" : 3/4" - 16, ID = 0.391
% AN 3/4" : 1-3/8" 1-1/16"- 12, ID = 0.609
% AN 1" : 1-5/6" - 12, ID = 0.844


%% Print

fprintf('Lead Velocity : %0.2f m/s | %0.2f ft/s\n',v_l,v_l/30.48*100)
fprintf('Lead Area : %0f * 10^-6 m^2 | %0f in^2\n',A_l*10^6,A_l*1550)
fprintf('Lead Density : %0.0f kg/m^3 | %0.0f lb/ft^3 \n',rho_l,rho_l*62.428/1000)
fprintf('Lead Mass Flowrate : %0f kg/s | %0f lb/s \n\n',W_l,W_l*2.20462)

fprintf('Air Pressure Ratio : %0f\n',P_ratio)
fprintf('Air Mach Number : %0f\n',MACH)
fprintf('Air Temperature Ratio : %0f\n',T_ratio)
fprintf('Air Stagnation Temperature : %0.2f K | %0.2f R | %0.2f F\n',T_a_0,T_a_0*9/5,T_a_0*9/5-459.67)
fprintf('Air Exit Temperature : %0.2f K | %0.2f R | %0.2f F\n',T_a,T_a*9/5,T_a*9/5-459.67)
fprintf('Air Exit Velocity : %0.2f m/s | %0.2f ft/s\n',v_a,v_a/30.48*100)
fprintf('Air Exit Density : %0f kg/m^3 | %0f lb/ft^3 \n',rho_a,rho_a*62.428/1000)
fprintf('Air Exit Area : %0f * 10^-6 m^2 | %0f in^2\n',A_a*10^6,A_a*1550)
fprintf('Air Mass Flowrate : %0f kg/s | %0f lb/s \n',W_a,W_a*2.20462)
fprintf('Air Mass Flowrate : %0f SCFM | %0f CFM \n\n',SCFM,CFM)

fprintf('O/F Ratio : %0f\n',OF)
fprintf('Volumetric Ratio: %0.0f \n\n',Q_a/Q_l)

fprintf('Mass Average Velocity : %0.0f m/s \n',v_avg)
fprintf('Droplet Diameter : %0.0f, %0.0f, %0.0f, %0.0f microns \n',d_ww*10^6,d_m*10^6,d_km*10^6,d_in*10^6)
fprintf('Core Length : %0.0f, %0.0f, %0.0f, %0.0f, %0.0f, %0.0f mm \n',L_er*10^3,L_en*10^3,L_l*10^3,L_p*10^3,L_le*10^3,L_lh*10^3)
fprintf('Throat Gap : %0f in \n\n',(d_3-d_throat)/(2*0.0254))