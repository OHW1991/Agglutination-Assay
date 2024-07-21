function relArea = CompileRelArea(relArea)
    % This function takes a cell array 'relArea', concatenates its contents,
    % and converts the result into a table with specific column names.

    % Initialize an empty array to hold concatenated data
    temp = [];
    
    % Loop over each element in the cell array 'relArea'
    for ii = 1:numel(relArea)
        % Concatenate the contents of each cell into the 'temp' array
        temp = [temp; relArea{ii, :}];
    end % for ii
    
    % Convert the concatenated array into a table with specified column names
    relArea = array2table(temp, 'VariableNames', ["RelativeArea"; "LectinConcentration"]);
end % function
