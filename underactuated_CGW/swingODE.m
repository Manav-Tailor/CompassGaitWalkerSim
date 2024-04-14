function dqdt = swingODE(t, q, u, walkerDim)

    M = walkerDim.M;
    m = walkerDim.m;
    I = walkerDim.I;
    l = walkerDim.l;
    c = walkerDim.c;
    g = walkerDim.g;
    gamma = walkerDim.gamma;

    theta_1 = q(1);
    theta_2 = q(3);
    omega_1 = q(2);
    omega_2 = q(4);

    A = [2*I + M*l^2 + 2*c^2*m + 2*l^2*m - 2*c*l*m - 2*c*l*m*cos(theta_2), m*c^2 - l*m*cos(theta_2)*c + I;
        m*c^2 - l*m*cos(theta_2)*c + I, m*c^2 + I];

    b = [- c*l*m*sin(theta_2)*omega_2^2 - 2*c*l*m*omega_1*sin(theta_2)*omega_2 - c*g*m*sin(theta_1 - gamma + theta_2) - M*g*l*sin(gamma - theta_1) + c*g*m*sin(gamma - theta_1) - 2*g*l*m*sin(gamma - theta_1);
        -c*m*(g*sin(theta_1 - gamma + theta_2) - l*omega_1^2*sin(theta_2))];

    B = [0,0;
        0,1];

    alpha = A \ (b + B*u);

    dqdt = [q(2); double(alpha(1)); q(4); double(alpha(2))];