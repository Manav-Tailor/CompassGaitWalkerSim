function [q, t] = onestep(t0, q0, u, walkerDim)

    dt = 8;
    options = odeset('AbsTol',1e-8, 'RelTol',1e-8, 'Events', @contact);
    
    [t,q] = ode45(@swingODE,[t0, t0+dt], q0, options, u, walkerDim);

    qminus = q(end,:);
    qplus = foot_strike(qminus, walkerDim);

    if nargout == 1
        q = qplus;
    end

end