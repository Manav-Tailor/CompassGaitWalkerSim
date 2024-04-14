clear

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
addpath( fullfile( pathstr, 'passive_CGW' ) );

tic

n = 1000;

walkerDim_limits.gamma = linspace(0,0.2,n);

walkerDim.M = 1;
walkerDim.m = 0.5;
walkerDim.I = 0.02;
walkerDim.l = 1.0;
walkerDim.c = 0.5;
walkerDim.g = 1.0;
walkerDim.gamma = walkerDim_limits.gamma(1);      

theta_1 = 0.19;
theta_2 = -2*theta_1;
omega_1 = -0.25;
omega_2 = 0.1;
q0 = [theta_1, omega_1, theta_2, omega_2];

qstar_all = {};
exitflag_all = {};
walkerDim_all = {};

tic
[qstar,exitflag, walkerDims] = genRange(walkerDim_limits.gamma,q0,walkerDim);
qstar_all = [qstar_all, qstar];
exitflag_all = [exitflag_all, exitflag];
walkerDim_all = [walkerDim_all, walkerDims];

parfor i = 1:length(cell2mat(exitflag_all))
    [eigJ{i}, stable{i}] = eigFind(@onestep, cell2mat(qstar_all(i)), cell2mat(walkerDim_all(i)));
end
toc

save("./data4/test_n"+ n + ".mat", "exitflag_all", "qstar_all", "walkerDim_all", "eigJ", "stable", "walkerDim_limits")

% data formatting before saving
dataset = zeros(length(walkerDim_all), 7);
for i = 1:length(walkerDim_all)
    dataset(i,:) = [walkerDim_all{i}.M; walkerDim_all{i}.m; walkerDim_all{i}.I; walkerDim_all{i}.l; walkerDim_all{i}.c; walkerDim_all{i}.g; walkerDim_all{i}.gamma];
end

T = array2table(dataset);
T.Properties.VariableNames = {'gamma', 'g', 'c', 'l', 'I', 'm', 'M'};
T = addvars(T, stable', 'NewVariableNames', 'stable');
qstar_all_matrix = cell2mat(qstar_all');
for i = 1:size(qstar_all_matrix, 2)
    T.(['qstar_' num2str(i)]) = qstar_all_matrix(:, i);
end

writetable(T, './data4/unpackedwalkerDim_all.csv');

%%
qstar_first_values = cellfun(@(x) x(1), qstar_all);
qstar_second_values = cellfun(@(x) x(2), qstar_all);
stability_values = cell2mat(stable);
stable_indices = find(stability_values == 1);
unstable_indices = find(stability_values == 0);

figure;
hold on;


scatter(walkerDim_limits.gamma(stable_indices), qstar_first_values(stable_indices), 'g', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);

scatter(walkerDim_limits.gamma(unstable_indices), qstar_first_values(unstable_indices), 'r', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);

xlabel('($\gamma$)', 'Interpreter', 'latex');
ylabel('First Value of q* ($\theta$)', 'Interpreter', 'latex');
title('Stability of CGW with varying Gamma');
legend('Stable', 'Unstable');

hold off;

figure;
hold on;

% Plot stable points in green
scatter3(walkerDim_limits.gamma(stable_indices), qstar_first_values(stable_indices), qstar_second_values(stable_indices), 'g', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);

% Plot unstable points in red
scatter3(walkerDim_limits.gamma(unstable_indices), qstar_first_values(unstable_indices), qstar_second_values(unstable_indices), 'r', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);

xlabel('($\gamma$)', 'Interpreter', 'latex');
ylabel('First Value of q* ($\theta$)', 'Interpreter', 'latex');
zlabel('Second Value of q* ($\omega$)', 'Interpreter', 'latex');
title('Stability of CGW with varying Gamma');
legend('Stable', 'Unstable');
view(-40,45);

hold off;

%%
function [qstar, exitflag, walkerDims] = genRange(gammaArr, q0, walkerDim)
    parfor i = 1:length(gammaArr)
        walkerDimTemp = walkerDim; % creates temp memory
        walkerDimTemp.gamma = gammaArr(1,i);
        options = optimoptions('fsolve', 'Display', 'final', 'TolFun', 1e-8);
        walkerDims{i} = (walkerDimTemp);
        [qstar{i}, ~, exitflag{i}] = fsolve(@(x) fixedpt(x,walkerDimTemp), q0, options);
    end
end