function [q, t] = multistep(t0, q0, walkerDim, steps)

    dt = 8;
    t = t0;
    q = q0;
    options = odeset('AbsTol',1e-8, 'RelTol',1e-8, 'Events', @contact);

    for i = 1:steps
        [t_temp,q_temp] = ode45(@swingODE,[t0, t0+dt], q0, options, walkerDim);
        qminus = q_temp(end,:);
        q0 = foot_strike(qminus, walkerDim);
        t0 = t_temp(end);
        q = vertcat(q,q_temp);
        t = vertcat(t,t_temp);
    end
end