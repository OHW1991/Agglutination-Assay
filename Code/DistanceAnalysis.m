function distCentroid = DistanceAnalysis(lectin_conc, L_red, imgLogical_red, imgLogical_partner)
    % This function calculates the distance between centroids of overlapping regions
    % in two logical images and associates these distances with a lectin concentration.
    % Inputs:
    %   lectin_conc - Concentration of lectin
    %   L_red - Labeled image of red regions
    %   imgLogical_red - Logical image of red regions
    %   imgLogical_partner - Logical image of partner regions (for overlap analysis)
    % Output:
    %   distCentroid - Array of distances between centroids and associated lectin concentrations
    
    % Extract unique labels from L_red, excluding 0 (background)
    RedList = unique(L_red);
    RedList = RedList(2:end); % Remove background label (0)
    
    % Calculate coloc_lab by multiplying logical masks and extract unique labels
    coloc_lab = L_red .* (imgLogical_red .* imgLogical_partner);
    colocList = unique(coloc_lab);
    colocList = colocList(2:end); % Remove background label (0)
    
    % Find intersecting labels between RedList and colocList
    [~, indR, indRB] = intersect(RedList, colocList);
    distCentroid = nan(numel(indR), 2); % Initialize output matrix
    
    if ~isempty(indR) % Check if there are intersecting regions
        for ee = 1:numel(indR)
            % Find coordinates of the labeled regions in both images
            [xR, yR] = find(L_red == RedList(indR(ee)));
            [xRB, yRB] = find(coloc_lab == colocList(indRB(ee)));
            
            % Check if coordinates are valid and not collinear
            if ~isempty(xRB) && numel(xRB) >= 3 && ...
               ~checkIfVectorsFormLine(xRB, yRB) && ...
               ~checkIfVectorsFormLine(xR, yR)
               
                % Calculate the center of gravity (centroid) for both regions
                [xR, yR] = calculate_center_of_gravity([xR, yR]);
                [xRB, yRB] = calculate_center_of_gravity([xRB, yRB]);
                
                % Calculate the Euclidean distance between centroids
                distCentroid(ee, :) = [sqrt((xR - xRB)^2 + (yR - yRB)^2), lectin_conc];
                
                % Debug output if the distance is greater than 50
                if sqrt((xR - xRB)^2 + (yR - yRB)^2) > 50
                    ee
                end % if
            else
                % Assign NaN if the coordinates are invalid or collinear
                distCentroid(ee, :) = [NaN, lectin_conc];
            end % if
        end % for ee
    end % if
    
end % function
