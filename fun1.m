function [f] = fun1(x)
%Function file with f1 as the objective function

T_l = x(1);
d_1 = x(2); 
gap = x(3);
P_a = x(4);
v_l = x(5);

[avg_drop,~,~,~,~] = PerfCode_func(T_l,d_1,gap,P_a,v_l);


f = avg_drop;

end

