function animation(t_all, q_all, walkerDim)
    l = walkerDim.l;

    tstart = t_all(1);
    tend = t_all(end);
    tinterp = linspace(tstart,tend,walkerDim.movieFPS*(tend-tstart));
    [~,n] = size(q_all);
    for i=1:n
        qinterp(:,i) = interp1(t_all,q_all(:,i),tinterp);
    end

    theta1 = qinterp(:,1);
    theta2 = qinterp(:,3);
    xh = qinterp(:,5);
    yh = qinterp(:,6);

    line([-2, 2], [0,0],'Linewidth', 1, 'color', 'k'); hold on
    for i = 1:length(tinterp) 
        x_C1 = xh(i,1) + l*sin(theta1(i,1));
        y_C1 = yh(i,1) - l*cos(theta1(i,1));
        x_C2 = xh(i,1) + l*sin(theta1(i,1) + theta2(i,1));
        y_C2 = yh(i,1) - l*cos(theta1(i,1) + theta2(i,1));
        h0 = plot(xh(i,1),yh(i,1),'ko',"MarkerFaceColor","k", 'MarkerSize',10);
        h1 = line([xh(i,1) x_C1],[yh(i,1), y_C1],'color', 'r', 'Linewidth', 2);
        h2 = line([xh(i,1) x_C2],[yh(i,1), y_C2],'color', 'b', 'Linewidth', 2);

        axis([-2 2 -2 2]);
        pause(0.01);
        if (i<length(tinterp))
            delete(h0)
            delete(h1)
            delete(h2)
        end
    end
end