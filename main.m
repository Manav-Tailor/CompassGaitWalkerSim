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
walkerDim.gamma = 0.01;
walkerDim.movieFPS = 60;
steps = 3;

% Set Initial State
theta_1 = 0.19;
theta_2 = -2*theta_1;
omega_1 = -0.25;
omega_2 = 0.1;

q0 = [theta_1, omega_1, theta_2, omega_2];

%Root Finding
if 0
    options = optimoptions('fsolve', 'Display', 'iter', 'TolFun', 1e-12);
    [qstar, fval, exitflag] = fsolve(@(x) fixedpt(x,walkerDim), q0, options);
    exitflag
    qstar
    fval
else
    qstar = [0.162597833780050  -0.231869638058965  -0.325195667560114   0.037978468073736];
end

% options = optimoptions('fsolve', 'Display', 'off');
% f = @(x) fixedpt(x,walkerDim);
% future_results = cell(1, length(q0));
% for i = 1:length(q0)
%     future_results{i} = parfeval(@fsolve, 3, f, q0(i), options);
% end
% qstar = zeros(size(q0));
% fval = zeros(size(q0));
% exitflag = zeros(size(q0));
% for i = 1:length(future_results)
%     [qstar(i), fval(i), exitflag(i)] = fetchOutputs(future_results{i});
% end


% Simulation

t0 = 0;

[q, t] = onestep(t0,qstar,walkerDim);

xh = -1*walkerDim.l*sin(q(:,1));
yh = walkerDim.l*cos(q(:,1));
q_all = [q, xh, yh];
figure;
animation(t, q_all, walkerDim)

figure;
plot(q_all);
