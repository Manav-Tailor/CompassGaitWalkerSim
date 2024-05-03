function animation(t_all, q_all, walkerDim)
    l = walkerDim.l;

    tstart = t_all(1);
    tend = t_all(end);
    tinterp = linspace(tstart,tend,walkerDim.movieFPS*(tend-tstart));
    [~,n] = size(q_all);
    qinterp = zeros(length(tinterp), n);
    for i=1:n
        [t_unique, ~, ic] = unique(t_all);
        q_unique = accumarray(ic, q_all(:,i), [], @mean);
        qinterp(:,i) = interp1(t_unique, q_unique, tinterp);
    end

    theta1 = qinterp(:,1);
    theta2 = qinterp(:,3);
    xh = qinterp(:,5);
    yh = qinterp(:,6);

    % Set up the figure
    h = figure;
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'walkerAnimation.mp4'; % Name of the MP4 file

    % Set up the video writer object
    writerObj = VideoWriter(filename, 'MPEG-4');
    writerObj.FrameRate = walkerDim.movieFPS; % Set the frame rate
    open(writerObj);

    for i = 1:length(tinterp)
        % Draw the walker
        x_C1 = xh(i) + l*sin(theta1(i));
        y_C1 = yh(i) - l*cos(theta1(i));
        x_C2 = xh(i) + l*sin(theta1(i) + theta2(i));
        y_C2 = yh(i) - l*cos(theta1(i) + theta2(i));
        plot([-2, 2], [0,0],'Linewidth', 1, 'color', 'k'); hold on;
        h0 = plot(xh(i),yh(i),'ko',"MarkerFaceColor","k", 'MarkerSize',10);
        h1 = line([xh(i) x_C1],[yh(i), y_C1],'color', 'r', 'Linewidth', 2);
        h2 = line([xh(i) x_C2],[yh(i), y_C2],'color', 'b', 'Linewidth', 2);
        axis([-2 2 -2 2]);

        % Capture the frame
        drawnow;
        frame = getframe(h);
        writeVideo(writerObj, frame);

        % Remove the previous plot
        if (i<length(tinterp))
            delete(h0);
            delete(h1);
            delete(h2);
        end
    end

    % Close the video writer object
    close(writerObj);
    close(h); % Close the figure window
end
