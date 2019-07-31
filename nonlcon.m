function [g, h] = nonlcon(x)
%  SQP non linear constraints - Rohan Dudaney
% inequality constraints
g(1) = -3+5*(x(1)-2)^3+x(2);
g(2) = -4.25-2*(x(2)-x(1)+0.6)^2+x(1)+x(2);

f1 = (x(1)+x(2)-8)^2+0.75*(x(2)-x(1)+3)^2;
f2 = 0.65*(x(1)-1)^2+0.75*(x(2)-4)^2;

fg = [22.5804;0];
w = [0.9 0.1];

g(3) = (f1-w(1)*x(3))/fg(1)-1;
g(4) = f2-w(2)*x(3)-fg(2);


% equality constraints - none in this problem
h = [];

end