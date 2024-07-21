function [] = WriteRelAreaAndDistance(path_repeat, Lectin, relAreaGreen, relAreaBlue, distCentroidGreen, distCentroidBlue)
    % WriteRelAreaAndDistance - Writes relative area and distance data to CSV files.
    %
    % Inputs:
    %   path_repeat - Path to the directory where data is stored.
    %   Lectin - Table containing information about the lectins.
    %   relAreaGreen - Table containing relative area data for green.
    %   relAreaBlue - Table containing relative area data for blue.
    %   distCentroidGreen - Table containing distance centroid data for green.
    %   distCentroidBlue - Table containing distance centroid data for blue.

    % Define paths for storing data
    relAreaGreenPath = fullfile(replace(path_repeat, "Image Data", "RelAreaGreen Data"));
    relAreaBluePath = fullfile(replace(path_repeat, "Image Data", "RelAreaBlue Data"));
    distCentroidGreenPath = fullfile(replace(path_repeat, "Image Data", "DistanceGreen Data"));
    distCentroidBluePath = fullfile(replace(path_repeat, "Image Data", "DistanceBlue Data"));

    % Create directories if they do not exist
    if ~exist(relAreaGreenPath, 'dir')
        mkdir(relAreaGreenPath);
    end

    if ~exist(relAreaBluePath, 'dir')
        mkdir(relAreaBluePath);
    end

    if ~exist(distCentroidGreenPath, 'dir')
        mkdir(distCentroidGreenPath);
    end

    if ~exist(distCentroidBluePath, 'dir')
        mkdir(distCentroidBluePath);
    end

    % Write the data to CSV files if relAreaGreen is not empty
    if ~isempty(relAreaGreen)
        for ll = 1:size(Lectin, 1)
            % Filter and write relative area data for green
            temp = relAreaGreen(relAreaGreen{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, :);
            writetable(temp, fullfile(relAreaGreenPath, strcat(Lectin{ll,"Sign"}, ".csv")));

            % Filter and write relative area data for blue
            temp = relAreaBlue(relAreaBlue{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, :);
            writetable(temp, fullfile(relAreaBluePath, strcat(Lectin{ll,"Sign"}, ".csv")));

            % Filter and write distance centroid data for green
            temp = distCentroidGreen(distCentroidGreen{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, :);
            writetable(temp, fullfile(distCentroidGreenPath, strcat(Lectin{ll,"Sign"}, ".csv")));

            % Filter and write distance centroid data for blue
            temp = distCentroidBlue(distCentroidBlue{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, :);
            writetable(temp, fullfile(distCentroidBluePath, strcat(Lectin{ll,"Sign"}, ".csv")));
        end % for ll
    end % if
end % function
