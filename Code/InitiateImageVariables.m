function [img, imgLogical, L, nEvents] = InitiateImageVariables(colors)
    % This function initializes cell arrays and a numeric array for storing image data,
    % binary masks, labeled images, and event counts. The sizes of these variables are 
    % determined by the number of colors specified.
    % Inputs:
    %   colors - Array or cell array containing color information, where the number of 
    %            entries determines the size of the output variables
    % Outputs:
    %   img - Cell array for storing images
    %   imgLogical - Cell array for storing binary logical images
    %   L - Cell array for storing labeled images
    %   nEvents - Numeric array for storing the number of events (connected components)
    
    % Initialize cell arrays for image storage with the same size as colors
    img = repmat({{}}, size(colors, 1), 1);
    imgLogical = repmat({{}}, size(colors, 1), 1);
    L = repmat({{}}, size(colors, 1), 1);
    
    % Initialize numeric array for storing event counts
    nEvents = zeros(size(colors, 1), 1);
    
end % function
