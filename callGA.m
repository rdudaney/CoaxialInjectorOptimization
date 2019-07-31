% this file provides input variables to the genetic algorithm
% upper and lower bounds, and number of bits chosen for "egg-crate" problem
% Modified on 11/10/09 by Bill Crossley.

close all;
clear all;
clc
format long

% T_l = x(1);
% d_1 = x(2); 
% gap = x(3);
% P_a = x(4);
% v_l = x(5);


vlb = [(621+459.67)*5/9 , 0.15*0.0254 , 0        , 14.7*6894.76, 5*30.48/100];
vub = [(900+459.67)*5/9 , 1*0.0254    , 1*0.0254 , 100*6894.76, 100*30.48/100];
bits =[20, 20, 20,20,20];	%number of bits describing each gene - all variables

l = 0;

for i = 1:length(bits)
    l = l + bits(i);
end

N_pop = 4*l
P_c = 0.5
P_m = (l+1)/(2*N_pop*l)

option_vect = zeros(1,14)-1;
option_vect(11) = N_pop;
option_vect(12) = P_c;
option_vect(13) = P_m;
option_vect(14) = 500;

options = goptions(option_vect);


[x,fbest,stats,nfit,fgen,lgen,lfit]= GA550('GAfunc',[ ],options,vlb,vub,bits);
x
fbest
nfit

x_imp = [(x(1)*9/5-459.67) ; x(2)/0.0254 ; x(3)/0.0254; x(4)/6894.76 ; x(5)/30.48*100]

[avg_drop,W_l,q,flame_temp,SCFM] = PerfCode_func(x(1),x(2),x(3),x(4),x(5));


max_flame_temp = (2300+459.67)*5/9; %K
min_flame_temp = (1628+459.67)*5/9; %K
q_max = 70; % kW
max_SCFM = 2200;

g(1) = q/q_max -1;
g(2) = 1 - flame_temp/min_flame_temp;
g(3) = flame_temp/max_flame_temp -1;
g(4) = SCFM/max_SCFM -1;

q
flame_temp*9/5-459.67
SCFM


