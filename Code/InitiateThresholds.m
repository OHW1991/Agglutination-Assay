function [sizeThresh, threshR, threshG, threshB] = InitiateThresholds()
    % This function initializes and returns threshold values used for image processing.
    % Thresholds are specified for different color channels and size criteria.
    % Outputs:
    %   sizeThresh - Threshold for minimum size in pixels
    %   threshR - Array of red channel thresholds for different proteins
    %   threshG - Threshold for the green channel
    %   threshB - Threshold for the blue channel
    
    % Define the minimum size threshold for objects in pixels
    sizeThresh = 8; % Minimum size in pixels
    
    % Define thresholds for the red channel for various proteins
    threshR = [...
        4;... % ACE2
        4;... % Fetuin
        4;... % GYPA
        5;... % LAMP1
        4;... % NXST-b.V1x1
        4;... % NXST-m.V1x1
        4;... % NXST-m.V1x2
        4;... % NXST-m.V2x1
        3;... % tdPP7-b
        3;... % tdPP7-m
        ] * 10^3; % Multiplying by 10^3 to adjust the threshold scale
    
    % Define threshold values for the green and blue channels
    threshG = 5 * 10^3; % Threshold for the green channel
    threshB = 3 * 10^3; % Threshold for the blue channel

end % function
