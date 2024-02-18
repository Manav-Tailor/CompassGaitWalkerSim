% Pre-run Cleanup
clc
clear
close all
format long

% Set Dimensions
walkerDim.M = 1.0;
walkerDim.m = 0.5;
walkerDim.I = 0.02;
walkerDim.l = 1.0;
walkerDim.c = 0.5;
walkerDim.g = 1.0;
walkerDim.gamma = 0.1;

% Set Initial State
theta_1 = 0.4;
theta_2 = -0.4;
omega_1 = -0.25;
omega_2 = 0.2;

q0 = [theta_1, omega_1, theta_2, omega_2];

tspan = [0 2.5];

[t, q, te, qe, ie] = step(tspan, q0, walkerDim);
plot(t,q, te, qe, '-o')
title("System States vs. Time")
ylabel("States")
xlabel("Time")
legend("\theta_1", "\omega_1", "\theta_2", "\omega_2", Location="northwest")
animation(t,q,walkerDim)



function [t, q, te, qe, ie] = step(tspan, q0, walkerDim)
    options = odeset('Abstol',1e-13,'Reltol',1e-13,'Events',@contact);
    [t, q, te, qe, ie] = ode45(@(t,y) swingODE(t, y, walkerDim), tspan, q0, options);
    q_minus = q(end,:);
end

function [value, isterminal, direction] = contact(~,q)
    theta_1 = q(1);
    theta_2 = q(3);
    value = theta_2 + 2*theta_1;
    if theta_1 > -0.1
        isterminal = 0;
    else
        isterminal = 1;
    end
    direction = [];
end

