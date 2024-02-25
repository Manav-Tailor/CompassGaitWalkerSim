function [q, t] = onestep(t0, q0, walkerDim)

    %q0
    dt = 8;
    options = odeset('AbsTol',1e-13, 'RelTol',1e-13, 'Events', @contact);
    
    [t,q] = ode45(@swingODE,[t0, t0+dt], q0, options, walkerDim);

    qminus = q(end,:);
    qplus = foot_strike(qminus, walkerDim);

    if nargout == 1
        q = qplus;
    end

end