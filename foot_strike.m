function qplus = foot_strike(qminus, walkerDim)

    theta1_n = qminus(1);
    omega1_n = qminus(2);
    theta2_n = qminus(3);
    omega2_n = qminus(4);

    M = walkerDim.M;
    m = walkerDim.m;
    I = walkerDim.I;
    l = walkerDim.l;
    c = walkerDim.c;

    J = [1, 0, l*(cos(theta1_n + theta2_n) - cos(theta1_n)), l*cos(theta1_n + theta2_n);
        0, 1, l*(sin(theta1_n + theta2_n) - sin(theta1_n)), l*sin(theta1_n + theta2_n)];
     
    A11 = M + 2*m;
    A12 = 0;
    A13 = (m*(2*c*cos(theta1_n + theta2_n) - 2*l*cos(theta1_n)))/2 + m*cos(theta1_n)*(c - l) - M*l*cos(theta1_n);
    A14 = c*m*cos(theta1_n + theta2_n);
    A21 = 0;
    A22 = M + 2*m;
    A23 = (m*(2*c*sin(theta1_n + theta2_n) - 2*l*sin(theta1_n)))/2 - M*l*sin(theta1_n) + m*sin(theta1_n)*(c - l);
    A24 = c*m*sin(theta1_n + theta2_n);
    A31 = (m*(2*c*cos(theta1_n + theta2_n) - 2*l*cos(theta1_n)))/2 + m*cos(theta1_n)*(c - l) - M*l*cos(theta1_n);
    A32 = (m*(2*c*sin(theta1_n + theta2_n) - 2*l*sin(theta1_n)))/2 - M*l*sin(theta1_n) + m*sin(theta1_n)*(c - l);
    A33 = 2*I + M*l^2 + 2*c^2*m + 2*l^2*m - 2*c*l*m - 2*c*l*m*cos(theta2_n);
    A34 = I + c^2*m - c*l*m*cos(theta2_n);
    A41 = c*m*cos(theta1_n + theta2_n);
    A42 = c*m*sin(theta1_n + theta2_n);
    A43 = I + c^2*m - c*l*m*cos(theta2_n);
    A44 = I + c^2*m;
    A_n_hs = [A11 A12 A13 A14; A21 A22 A23 A24; A31 A32 A33 A34; A41 A42 A43 A44];
     
    X_n_hs = [0 0 omega1_n omega2_n]';
    b_hs = [A_n_hs*X_n_hs; 0; 0];
    A_hs = [A_n_hs -J' ; J zeros(2,2)];
    X_hs = A_hs\b_hs;
    omega(1) = X_hs(3)+X_hs(4); omega(2) = -X_hs(4);

    theta1 = theta1_n + theta2_n;
    theta2 = -theta2_n;
    qplus = [theta1, omega(1), theta2, omega(2)];

end