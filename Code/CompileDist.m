function distCentroid = CompileDist(distCentroid)
    % CompileDist compiles and consolidates centroid distance data.
    %
    % Input:
    %   distCentroid - Cell array of centroid distance data.
    %
    % Output:
    %   distCentroid - Consolidated table of centroid distances and lectin concentrations.

    % Initialize an empty array to store consolidated data
    temp = [];
    
    % Iterate through each cell in distCentroid
    for ii = 1:numel(distCentroid)
        % Concatenate the current cell's data to temp
        temp = [temp; distCentroid{ii, :}];
    end % for ii
    
    % Convert the consolidated array to a table with appropriate variable names
    distCentroid = array2table(temp, 'VariableNames', ["Distance", "LectinConcentration"]);
    
end % function
