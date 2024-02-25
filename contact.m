function [gstop, isterminal, direction] = contact(t,q,walkerDim)

    theta1 = q(1);
    theta2 = q(3);

    gstop = theta2 + 2*theta1;
    %[gstop, theta1]
    if (theta1 > -0.1)
        isterminal = 0;
    else
        isterminal = 1;
    end
    direction = 0;
end