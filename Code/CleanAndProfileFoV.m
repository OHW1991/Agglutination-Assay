function [eventsProfile, img, imgLogical, L, nEvents] = CleanAndProfileFoV(sizeThresh, img, imgLogical, L, nEvents)
    % CleanAndProfileFoV processes the input images, removes small events, and profiles the remaining events.
    %
    % Inputs:
    %   sizeThresh - Threshold for the minimum size of events to be kept.
    %   img - Input image data.
    %   imgLogical - Binary mask of the input image.
    %   L - Labeled matrix of connected components in the image.
    %   nEvents - Number of detected events (connected components).
    %
    % Outputs:
    %   eventsProfile - Table containing the profile of the remaining events.
    %   img - Processed image data.
    %   imgLogical - Processed binary mask.
    %   L - Processed labeled matrix.
    %   nEvents - Updated number of detected events.

    % Labels for the event data columns
    eventDataLabels = ["ID", "Mean", "Median", "Max", "Min"];

    % Initialize an array to store event data
    events = zeros(nEvents, numel(eventDataLabels));

    % Loop over each event
    for ee = 1:size(events, 1)
        % Find the coordinates of the current event in the labeled matrix
        [x, y] = find(L == ee);

        % If the event size is less than the threshold, remove it
        if numel(x) < sizeThresh
            for ii = 1:numel(x)
                L(x(ii), y(ii)) = 0;
                imgLogical(x(ii), y(ii)) = 0;
            end % for ii
            % Update the number of events
            nEvents = max(nEvents - 1, 0);
        else
            % Profile the current event
            event = zeros(size(x));
            for ii = 1:numel(x)
                event(ii) = img(x(ii), y(ii));
            end % for ii
            events(ee, :) = [ee, mean(event), median(event), max(event), min(event)];
        end % if
    end % for ee

    % Remove empty rows (events that were removed)
    events(events(:, 1) == 0, :) = [];
    
    % Convert the events array to a table
    eventsProfile = array2table(events, 'VariableNames', eventDataLabels);

end % function
