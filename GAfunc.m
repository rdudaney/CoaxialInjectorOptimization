function phi = GAfunc(x)


T_l = x(1);
d_1 = x(2); 
gap = x(3);
P_a = x(4);
v_l = x(5);

[avg_drop,W_l,q,flame_temp,SCFM] = PerfCode_func(T_l,d_1,gap,P_a,v_l);


f = -W_l;

max_flame_temp = (2300+459.67)*5/9; %K
min_flame_temp = (1628+459.67)*5/9; %K
q_max = 70; % kW
max_SCFM = 2200;

g(1) = q/q_max -1;
g(2) = 1 - flame_temp/min_flame_temp;
g(3) = flame_temp/max_flame_temp -1;
g(4) = SCFM/max_SCFM -1;



P = 0.0;    % initialize penalty function
for i = 1:length(g)
    P = P + 100 * max(0,g(i));  % use c_j = 10 for all bounds
end
phi = f + P;