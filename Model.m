% Finding mf, rf, Yfs, Tf, Ts
Zf = 1; 
rs = 1;
nu = 1;
Cpg = 1;
qi_l = 1;
hfg = 1;
Zt = 1;
deltah = 1;
Tinf = 1;
A = 1;
B = 1;
MWf = 1;
MWpr = 1;
P = 1;

% x(1) = mf
% x(2) = rf
% x(3) = Yfs
% x(4) = Tf
% x(5) = Ts

F(1) = 1 - exp(-Zf*x(1)/rs)/exp(-Zf*x(1)/x(2))-x(3);
F(2) = (nu+1)/nu - exp(-Zf*x(1)/x(2));
F(3) = -Cpg*(x(4)-x(5))/(qi_l+hfg)*exp(-Zt*x(1)/rs)/(exp(-Zt*x(1)/rs)-exp(-Zt*x(1)/x(2)))-1;
F(4) = 1 - Cpg/deltah*((x(5)-x(4))*exp(-Zt*x(1)/x(2))/(exp(-Zt*x(1)/rs)-exp(-Zt*x(1)/x(2)))-(Tinf-x(4))*exp(-Zt*x(1)/x(2))/(1-exp(-Zt*x(1)/x(2))));
F(5) = A*exp(-B/x(5))*MWf/(A*exp(-B/x(5))*MWf+MWpr*(P-A*exp(-B/x(5))));