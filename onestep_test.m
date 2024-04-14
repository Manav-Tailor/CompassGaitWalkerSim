% Pre-run Cleanup
clc
clear
close all
format long

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
addpath( fullfile( pathstr, 'passive_CGW' ) );

tic
% Set Dimensions
walkerDim.M = 1.0;          
walkerDim.m = 0.5;
walkerDim.I = 0.02;
walkerDim.l = 1.0;
walkerDim.c = 0.5;
walkerDim.g = 1.0;
walkerDim.gamma = 0.10;
walkerDim.movieFPS = 60;

% Set Initial State
theta_1 = 0.19;
theta_2 = -2*theta_1;
omega_1 = -0.25;
omega_2 = 0.1;

q0 = [theta_1, omega_1, theta_2, omega_2];

%Root Finding
options = optimoptions('fsolve', 'Display', 'iter', 'TolFun', 1e-8);
[qstar, fval, exitflag] = fsolve(@(x) fixedpt(x,walkerDim), q0, options);

toc
t0 = 0;

[q, t] = onestep(t0,qstar,walkerDim);
xh = -1*walkerDim.l*sin(q(:,1));
yh = walkerDim.l*cos(q(:,1));
q_all = [q, xh, yh];

figure;
animation(t, q_all, walkerDim)

figure;
plot(q_all(:,1:4));
title("All States ($\gamma$ = " + walkerDim.gamma + ")", 'Interpreter', 'latex');
xlabel("Time")
ylabel("States")
legend('$\theta_1$', '$\omega_1$', '$\theta_2$', '$\omega_2$', 'Interpreter', 'latex')

figure;
plot(q_all(:,1), q_all(:,2), '-r', q_all(:,3), q_all(:,4), '-b');
title("Angle v.s. Anglular Velocity")
xlabel('Angle')
ylabel("Angular Velocity")
legend("Stance Leg $\theta_1$", "Swing Leg $\theta_2$", 'Interpreter', 'latex')
toc