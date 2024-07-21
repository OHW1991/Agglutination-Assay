function [center_of_gravity_x, center_of_gravity_y] = calculate_center_of_gravity(data)
    % Extract X and Y coordinates from the data
    x = data(:, 1);
    y = data(:, 2);
    
    % Find convex hull
    k = convhull(x, y);
    hull_x = x(k);
    hull_y = y(k);
    
    % Create polyshape from convex hull
    poly = polyshape(hull_x, hull_y);
    
    % Calculate centroid of polyshape (perimeter)
    [center_of_gravity_x,center_of_gravity_y] = centroid(poly);
    
    % % Plotting
    % figure;
    % plot(data(:,1), data(:,2), 'bo'); % Plot input data points
    % hold on;
    % plot(hull_x, hull_y, 'r-', 'LineWidth', 2); % Plot convex hull perimeter
    % plot(center_of_gravity_x, center_of_gravity_y, 'gx', 'MarkerSize', 10, 'LineWidth', 2); % Plot center of gravity
    % hold off;
    % xlabel('X');
    % ylabel('Y');
    % title('Center of Gravity Calculation');
    % legend('Data Points', 'Convex Hull Perimeter', 'Center of Gravity');
    % grid on;
end