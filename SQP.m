% SQP Method - Rohan Dudaney

clear all
close all
clc


format long
% T_l = x(1);
% d_1 = x(2); 
% gap = x(3);
% P_a = x(4);
% v_l = x(5);

% linear inequality constraints
A = [];
b = [];

% no linear equality constraints
Aeq = [];
beq = [];

% lower bounds
lb = [(621+459.67)*5/9 ; 0.15*0.0254 ; 0; 14.7*6894.76 ;5*30.48/100];

% upper bounds
ub = [(900+459.67)*5/9 ;Inf;Inf;100*6894.76;Inf];

options = optimoptions('fmincon','Algorithm','sqp', 'Display','iter');

% initial guess
x0 = [(700+459.67)*5/9 ; 0.15*0.0254 ; 0.4*0.0254 ; 100*6894.76 ;10*30.48/100];

% Find minimum values for f1 and f2
[x1,fval1,exitflag1,output1] = fmincon('fun1',x0,A,b,Aeq,beq,lb,ub,'con1',options);
fmin_1 = fval1;

[x2,fval2,exitflag2,output2] = fmincon('fun2',x0,A,b,Aeq,beq,lb,ub,'con1',options);
fmin_2 = fval2;



%% Pareto Evaluation
a1 = 0:0.1:1; % set a1 vector

a_vect = zeros(length(a1),2); % initialization of vector
f1 = zeros(length(a1),1); % initialization of vector
f2 = zeros(length(a1),1); % initialization of vector

% Bounds and initial guess for Pareto Evauluation
lb_pareto = [(621+459.67)*5/9 ; 0.15*0.0254 ; 0; 14.8*6894.76 ;5*30.48/100; -Inf];
ub_pareto = [(900+459.67)*5/9 ;Inf;Inf;100*6894.76;Inf; Inf];
x0_pareto = [(700+459.67)*5/9 ; 0.15*0.0254 ; 0.4*0.0254 ; 100*6894.76 ;100*30.48/100 ; 10];

% Vary a1 and a2 and calculate f1 and f2
for i = 1:length(a1)
    a2 = 1 - a1(i); % calculate a2
    a = [a1(i),a2];
    a_vect(i,:) = [a1(i),a2];
    

    
    [x_pareto(i,:),fval_pareto,exitflag_pareto(i,:),output_pareto] = fmincon('fun_pareto',x0_pareto,A,b,Aeq,beq,lb_pareto,ub_pareto,@(x)con_pareto(x,fmin_1,fmin_2,a),options);
       
    % Calculate f1, f2. and constraints based on pareto x*
    [avg_drop,W_l,~,~,~] = PerfCode_func(x_pareto(i,1),x_pareto(i,2),x_pareto(i,3),x_pareto(i,4),x_pareto(i,5));
    [g(i,:),h] = con1(x_pareto(i,1:5));
    f1(i) = avg_drop;
    f2(i) = -W_l;
end

% Plot Pareto Front
figure(1)
hold on
scatter(f1,f2)
title('Pareto Front')
xlabel('Average Droplet Size (microns)')
ylabel('-Lead Mass Flowrate (kg/s)')
hold off

%convert to imperial units
x_imp = [(x_pareto(:,1)*9/5-459.67) , x_pareto(:,2)/0.0254 , x_pareto(:,3)/0.0254, x_pareto(:,4)/6894.76 , x_pareto(:,5)/30.48*100]