function pixelsData = CompileMPP(repeat_date, lectin_conc, FoV, eventsPixels)
    % This function compiles a table 'pixelsData' based on input parameters
    % and the 'eventsPixels' data. It handles two cases depending on the
    % number of rows in 'eventsPixels'.

    % Define possible values for ColocTypeBinary
    coloc_types = ["NoColoc"; "ColocGreen"; "ColocBlue"; "ColocAll"];
    
    % Define column labels for the output table
    % Include 'N_Pixels' and all 'coloc_types' as columns
    pixelsLabels = ["RepeatDate", "LectinConcentration", "FoV", "EventID", "N_Pixels", coloc_types'];

    % Check if 'eventsPixels' has more than one row
    if (size(eventsPixels, 1) > 1)
        % Create a table with the specified columns and labels
        pixelsData = table(...
            repmat(string(repeat_date), size(eventsPixels, 1), 1),... % Repeat 'repeat_date' for each row
            repmat(lectin_conc, size(eventsPixels, 1), 1),... % Repeat 'lectin_conc' for each row
            repmat(FoV, size(eventsPixels, 1), 1),... % Repeat 'FoV' for each row
            eventsPixels(:, 1),... % Event ID from the first column of 'eventsPixels'
            eventsPixels(:, 2),... % N_Pixels from the second column of 'eventsPixels'
            eventsPixels(:, end-3),... % ColocTypeBinary value from the fourth last column
            eventsPixels(:, end-2),... % ColocTypeBinary value from the third last column
            eventsPixels(:, end-1),... % ColocTypeBinary value from the second last column
            eventsPixels(:, end),... % ColocTypeBinary value from the last column
            'VariableNames', pixelsLabels); % Set column names
    
    else % Handle case where 'eventsPixels' has only one row
        pixelsData = table(...
            repmat(string(repeat_date), 2 * size(eventsPixels, 1), 1),... % Repeat 'repeat_date' twice for each row
            repmat(lectin_conc, 2 * size(eventsPixels, 1), 1),... % Repeat 'lectin_conc' twice for each row
            repmat(FoV, 2 * size(eventsPixels, 1), 1),... % Repeat 'FoV' twice for each row
            eventsPixels(:, 1) * ones(2, 1),... % Duplicate Event ID for each row
            eventsPixels(:, 2) * ones(2, 1),... % Duplicate N_Pixels for each row
            eventsPixels(:, end-3) * ones(2, 1),... % Duplicate ColocTypeBinary value for each row
            eventsPixels(:, end-2) * ones(2, 1),... % Duplicate ColocTypeBinary value for each row
            eventsPixels(:, end-1) * ones(2, 1),... % Duplicate ColocTypeBinary value for each row
            eventsPixels(:, end) * ones(2, 1),... % Duplicate ColocTypeBinary value for each row
            'VariableNames', pixelsLabels); % Set column names
        
        % Remove the last row from the table
        pixelsData(end, :) = [];
    end
end
