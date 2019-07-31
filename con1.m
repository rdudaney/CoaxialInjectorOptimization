function [g,h] = con1(x)
%Constraint function for finding f1_min and f2_min

T_l = x(1);
d_1 = x(2); 
gap = x(3);
P_a = x(4);
v_l = x(5);

[~,~,q,flame_temp,SCFM] = PerfCode_func(T_l,d_1,gap,P_a,v_l);

max_flame_temp = (2300+459.67)*5/9; %K
min_flame_temp = (1628+459.67)*5/9; %K
q_max = 70; % kW
max_SCFM = 2200;

g(1) = q/q_max -1;
g(2) = 1 - flame_temp/min_flame_temp;
g(3) = flame_temp/max_flame_temp -1;
g(4) = SCFM/max_SCFM -1;


h = [];
end

