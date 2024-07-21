function [mean_dist, distCentroidGreen] = SNAAssociationAnalysis(path_repeat, distCentroidGreen, Lectin)
    % SNAAssociationAnalysis - Analyzes and calculates the mean distances of SNA association.
    %
    % Inputs:
    %   path_repeat - Path to the directory containing the distance data files.
    %   distCentroidGreen - Cell array or table containing pre-loaded distance data.
    %   Lectin - Table containing lectin concentrations and relevant data.
    %
    % Outputs:
    %   mean_dist - Vector containing the mean distances for each lectin concentration.
    %   distCentroidGreen - Updated table of distances and lectin concentrations.

    % Load distance data if distCentroidGreen is empty
    if isempty(distCentroidGreen)
        path = replace(path_repeat, "Image Data", "DistanceGreen Data");
        dir_content = dir(path);
        files = ~[dir_content.isdir];
        files = dir_content(files);
        for ll = 1:size(files, 1)
            fName = strcat(path, files(ll).name);
            opts = detectImportOptions(fName);
            temp = readtable(fName, opts);
            if ~isempty(temp)
                distCentroidGreen = [distCentroidGreen; temp];
            end
        end
    else
        % Consolidate existing distance data into a single table
        temp = [];
        for ii = 1:numel(distCentroidGreen)
            temp = [temp; distCentroidGreen{ii, 1}];
        end
        distCentroidGreen = temp;
        distCentroidGreen = array2table(distCentroidGreen, 'VariableNames', ["Distance", "LectinConcentration"]);
    end

    % Initialize mean distance vector
    mean_dist = zeros(size(Lectin, 1), 1);
    
    % Calculate mean distance for each lectin concentration
    for ll = 1:size(Lectin, 1)
        temp = distCentroidGreen{distCentroidGreen{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, "Distance"};
        temp = temp(~isinf(temp)); % Remove infinite values
        if isempty(temp)
            temp = NaN;
            distCentroidGreen{end+1, 1} = NaN;
            distCentroidGreen{end, 2} = Lectin{ll, "Concentration"};
        end
        % Calculate mean distance, excluding zero and NaN values
        mean_dist(ll) = mean(temp(temp ~= 0 & ~isnan(temp)));
        if numel(temp) == 1
            mean_dist(ll) = NaN;
        end
    end
end
