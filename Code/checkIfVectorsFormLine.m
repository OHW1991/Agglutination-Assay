function isLine = checkIfVectorsFormLine(x, y)
    % Check if vectors x and y form a line
    
    % Ensure both vectors have the same length
    if length(x) ~= length(y)
        error('Vectors must have the same length.');
    end
    
    % Calculate differences between consecutive points
    dx = diff(x);
    dy = diff(y);
    
    % Check if the differences have a constant ratio (slope)
    if(all(isnan(abs(dy./dx - dy(1)/dx(1)))))
        isLine=1;
    else
        isLine = all(abs(dy./dx - dy(1)/dx(1)) < eps);
    end %if
    
    % Display the result
    if isLine
        disp('The vectors form a line.');
    % else
    %     disp('The vectors do not form a line.');
    end
end