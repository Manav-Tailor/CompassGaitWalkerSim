function [] = animation(t, y, walkerDim)
    
    l = walkerDim.l;

    figure;
    axis([-2*l 2*l -2*l 2*l]);
    hold on;
    walkerPlot = plot(0, 0, 'ro', 'MarkerSize', 20, 'LineWidth', 2, 'DisplayName', 'Walker');
    link1Plot = plot([0, 0], [0, 0], 'b', 'LineWidth', 2, 'DisplayName', 'Link 1');
    link2Plot = plot([0, 0], [0, 0], 'g', 'LineWidth', 2, 'DisplayName', 'Link 2');
    xlabel('X');
    ylabel('Y');
    title('Compass Gait Walker Animation');
    legend;
    grid on;

    for i = 1:length(t)
        theta1 = y(i, 1);
        theta2 = y(i, 3);
        x_walker = l*sin(theta1);
        y_walker = -l*cos(theta1);
        x_link1 = [0, l*sin(theta1)];
        y_link1 = [0, -l*cos(theta1)];
        x_link2 = [l*sin(theta1), l*sin(theta1) + l*sin(theta1 + theta2)];
        y_link2 = [-l*cos(theta1), -l*cos(theta1) - l*cos(theta1 + theta2)];

        set(walkerPlot, 'XData', x_walker, 'YData', y_walker);
        set(link1Plot, 'XData', x_link1, 'YData', y_link1);
        set(link2Plot, 'XData', x_link2, 'YData', y_link2);

        drawnow;
        %pause(0.01);
    end
end

