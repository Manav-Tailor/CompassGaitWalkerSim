% Pre-run Cleanup
clc
clear
close all
format long

tic
% Set Dimensions
walkerDim.M = 1.0;          
walkerDim.m = 0.5;
walkerDim.I = 0.02;
walkerDim.l = 1.0;
walkerDim.c = 0.5;
walkerDim.g = 1.0;
walkerDim.gamma = 0.007;
walkerDim.movieFPS = 60;

% Set Initial State
theta_1 = 0.19;
theta_2 = -2*theta_1;
omega_1 = -0.25;
omega_2 = 0.1;

q0 = [theta_1, omega_1, theta_2, omega_2];

t_lin = linspace(0,4,4);

u = [0,-1;
    0,1;
    0, -1;
    0,1]';

t_all = [];
q_all = [];

dt = 1.333;
% options = odeset('AbsTol',1e-8, 'RelTol',1e-8, 'Events', @contact);
options = odeset('AbsTol',1e-8, 'RelTol',1e-8);
[t,q] = ode45(@swingODE,[t_lin(1), t_lin(1)+dt], q0, options, u(:,1), walkerDim);
t_all = [t_all; t];
q_all = [q_all; q];
for i = 2:length(t_lin)
    [t,q] = ode45(@swingODE,[t_lin(i), t_lin(i)+dt], q_all(end,:), options, u(:,i), walkerDim);
    t_all = [t_all; t];
    q_all = [q_all; q];
end


xh = -1*walkerDim.l*sin(q_all(:,1));
yh = walkerDim.l*cos(q_all(:,1));
q_all = [q_all, xh, yh];

figure;
animation(t_all, q_all, walkerDim)

figure;
yyaxis left
plot(t_all,q_all(:,1),'-b', t_all,q_all(:,2),'--b', t_all,q_all(:,3),'-m', t_all,q_all(:,4),'--m')
ylabel("States")
yyaxis right
plot(t_lin,u(2,:))
ylabel("Input")
legend('$\theta_1$', '$\omega_1$', '$\theta_2$', '$\omega_2$', 'Interpreter', 'latex')

toc