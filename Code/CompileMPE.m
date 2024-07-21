function touchData = CompileMPE(repeat_date, lectin_conc, FoV, eventsTouch)
    % This function compiles a table 'touchData' based on input parameters
    % and the 'eventsTouch' data. It handles two cases depending on the
    % number of rows in 'eventsTouch'.

    % Define possible values for ColocTypeBinary
    coloc_types = ["NoColoc"; "ColocGreen"; "ColocBlue"; "ColocAll"];
    
    % Define column labels for the output table
    touchLabels = ["RepeatDate", "LectinConcentration", "FoV", "EventID", "ColocTypeBinary"];

    % Check if 'eventsTouch' has more than one row
    if (size(eventsTouch, 1) > 1)
        % Create a table with the specified columns and labels
        touchData = table(...
            repmat(string(repeat_date), size(eventsTouch, 1), 1),... % Repeat 'repeat_date' for each row
            repmat(lectin_conc, size(eventsTouch, 1), 1),... % Repeat 'lectin_conc' for each row
            repmat(FoV, size(eventsTouch, 1), 1),... % Repeat 'FoV' for each row
            eventsTouch(:, 1),... % Event ID from the first column of 'eventsTouch'
            eventsTouch(:, end),... % ColocTypeBinary from the last column of 'eventsTouch'
            'VariableNames', touchLabels); % Set column names
    
    else % Handle case where 'eventsTouch' has only one row
        touchData = table(...
            repmat(string(repeat_date), 2 * size(eventsTouch, 1), 1),... % Repeat 'repeat_date' twice for each row
            repmat(lectin_conc, 2 * size(eventsTouch, 1), 1),... % Repeat 'lectin_conc' twice for each row
            repmat(FoV, 2 * size(eventsTouch, 1), 1),... % Repeat 'FoV' twice for each row
            eventsTouch(:, 1) * ones(2, 1),... % Duplicate Event ID for each row
            eventsTouch(:, end) * ones(2, 1),... % Duplicate ColocTypeBinary for each row
            'VariableNames', touchLabels); % Set column names
        
        % Remove the last row from the table
        touchData(end, :) = [];
    end

    % Create a temporary array to store ColocType as strings
    temp = repmat("", size(eventsTouch, 1), 1);
    
    % Convert numeric ColocTypeBinary to strings based on 'coloc_types'
    for ee = 1:size(eventsTouch, 1)
        temp(ee) = coloc_types(touchData{ee, "ColocTypeBinary"});
    end

    % Add the string ColocTypeBinary to the table
    touchData.ColocTypeBinary = temp;
end
