function eventsTouch = MPE2(L, sizeThresh)
    % This function classifies touch events in the image based on the presence
    % of colocalization in different color channels (red, green, and blue).
    % Inputs:
    %   L - A cell array containing label matrices for red, green, and blue channels
    %   sizeThresh - Minimum number of pixels to consider a valid event
    % Outputs:
    %   eventsTouch - A matrix with event IDs and their corresponding touch event types
    
    % Extract label matrices for each color channel
    L_red = L{1}; % Red channel label matrix
    L_green = L{2}; % Green channel label matrix
    L_blue = L{3}; % Blue channel label matrix

    % Define the possible types of colocalization
    coloc_types = ["No Coloc"; "Coloc Green"; "Coloc Blue"; "Coloc All"];

    % Get the unique labels in the red channel image (excluding zero)
    RedList = unique(L_red);
    RedList = RedList(2:end); % Remove label 0 (background)
    
    % Initialize arrays to store results
    if ~isempty(RedList)
        ID = zeros(numel(RedList), 1);
        eventsTouch = zeros(numel(RedList), 1);
        for ee = 1:numel(RedList)
            % Current red label ID
            ID(ee) = RedList(ee);
            
            % Find coordinates of the current label in the red channel image
            [xr, yr] = find(L_red == RedList(ee));
            eventXY = zeros(size(L_red));
            for ii = 1:numel(xr)
                eventXY(xr(ii), yr(ii)) = 1;
            end
            
            % Check for colocalization with green channel
            rGreen = L_green .* eventXY;
            rGreen = unique(rGreen);
            rGreen = rGreen(2:end); % Remove label 0 (background)
            flagG = 0;
            factorG = 0.2;
            for gg = 1:numel(rGreen)
                [xg, yg] = find(L_green == rGreen(gg));
                if numel(xg) >= sizeThresh
                    [~, ig, ir] = intersect([xg, yg], [xr, yr], 'rows');
                    if numel(ig) / numel(xr) > factorG
                        flagG = 1;
                    end
                end
            end
            
            % Check for colocalization with blue channel
            rBlue = L_blue .* eventXY;
            rBlue = unique(rBlue);
            rBlue = rBlue(2:end); % Remove label 0 (background)
            flagB = 0;
            for bb = 1:numel(rBlue)
                [xb, yb] = find(L_blue == rBlue(bb));
                if numel(xb) >= sizeThresh
                    flagB = flagB + 1;
                end
            end

            % Determine event type based on colocalization flags
            if flagG && flagB
                eventsTouch(ee) = 4; % Coloc Green and Blue
            elseif ~flagG && flagB
                eventsTouch(ee) = 3; % Coloc Blue only
            elseif flagG && ~flagB
                eventsTouch(ee) = 2; % Coloc Green only
            elseif ~flagG && ~flagB
                eventsTouch(ee) = 1; % No Coloc
            end
        end
        % Combine IDs with their corresponding touch event types
        eventsTouch = [ID, eventsTouch];
    end
end % function
