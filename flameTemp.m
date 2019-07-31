function [T_ad_K] = flameTemp(OF,T_Pb,T_Air)
% Calulates the adiabatic flame temperature

%% Properties

% Molecular Weights
MW_Pb = 0.2072; % kg/mol
MW_PbO = 0.2232; % kg/mol
MW_Air =(32+3.76*28)/4.76/1000; % kg/mol

% Cp values
Cp_Pb = (176.2-4.923e-2*T_Pb + 1.544e-5*T_Pb^2- 1.524e6 * T_Pb^-2)/1000*MW_Pb ; % kJ/(mol K)
Cp_PbO = (65.00221 -0.003325*(1159/1000)+0.001718*(1159/1000)^2-0.000297*(1159/1000)^3-0.000306*(1159/1000)^(-2))/1000; % (kJ/mol-K) % {NIST Webbook}
Cp_O2 = 1.090 * 0.032; % (kJ/mol-K) @ 1000 K
Cp_N2 = 1.187 *0.028; % (kJ/mol-K) @ 1000 K
Cp_Air = Cp_O2/4.76+Cp_N2*3.76/4.76; % (kJ/mol-K)

% Heat of Fusions
H_fus_PbO = 6.57* 4.184; % kJ/mol {JANNAF Tables}
H_fus_Pb = 23.07 * MW_Pb; % kJ/mol % Properties source

% Heat of Formation
H_form_PbO = -219.41; % kJ/mol -219.41(solid) -202.25 (liquid) {NIST Webbook}


%% Calculations
% moles of each species
N_air = MW_Pb/MW_Air * OF;
N_O2 = N_air/4.76;
N_N2 = N_air-N_O2;

A = N_O2;

T_ad_K = (4.76*A*Cp_Air*(T_Air-298)+Cp_Pb*(T_Pb-298)+H_fus_Pb-H_form_PbO-H_fus_PbO)/(Cp_PbO+3.76*A*Cp_N2+(A-0.5)*Cp_O2)+298;

end

