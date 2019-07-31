function [g,h] = con_pareto(x,f1_min,f2_min,a)
%constraint function

T_l = x(1);
d_1 = x(2); 
gap = x(3);
P_a = x(4);
v_l = x(5);
B = x(6);

[avg_drop,W_l,q,flame_temp,SCFM] = PerfCode_func(T_l,d_1,gap,P_a,v_l); % function solves for all of the needed values

% set min and max values
max_flame_temp = (2300+459.67)*5/9; %K
min_flame_temp = (1628+459.67)*5/9; %K
q_max = 70; % kW
max_SCFM = 2200;

g(1) = q/q_max -1;
g(2) = 1 - flame_temp/min_flame_temp;
g(3) = flame_temp/max_flame_temp -1;
g(4) = SCFM/max_SCFM -1;

f1 = avg_drop;
f2 = -W_l;

% calculate phi values based on min values
phi1 = (f1-f1_min)/abs(f1_min);
phi2 = (f2-f2_min)/abs(f2_min);

% calculate new constraints
g(5) = a(1)*phi1-B;
g(6) = a(2)*phi2-B;


h = [];

end

