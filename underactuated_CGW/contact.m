function [gstop, isterminal, direction] = contact(t,q,u,walkerDim)

    theta1 = q(1);
    theta2 = q(3);

%     xh = -1*walkerDim.l*sin(q(1));
%     yh = walkerDim.l*cos(q(1));
%      && xh <= 0 && yh <= 0
    gstop = theta2 + 2*theta1;
    if (theta1 > -0.1)
        isterminal = 0;
    else
        isterminal = 1;
    end
    direction = 0;
end