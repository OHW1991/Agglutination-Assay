function [] = WriteMPPAndMPEData(path_repeat, Lectin, pixelsData, touchData)
    % WriteMPPAndMPEData - Writes the pixel and touch data to CSV files.
    %
    % Inputs:
    %   path_repeat - Path to the directory where data is stored.
    %   Lectin - Table containing information about the lectins.
    %   pixelsData - Cell array containing tables of pixel data for each lectin.
    %   touchData - Cell array containing tables of touch data for each lectin.

    % Define paths for Pixels Data and Touch Data
    pixelsPath = fullfile(replace(path_repeat, "Image Data", "Pixels Data"));
    touchPath = fullfile(replace(path_repeat, "Image Data", "Touch Data"));

    % Check if the directories exist, if not, create them
    if ~exist(pixelsPath, 'dir')
        mkdir(pixelsPath);
    end

    if ~exist(touchPath, 'dir')
        mkdir(touchPath);
    end

    % Write the pixel and touch data tables to CSV files if pixelsData is not empty
    if ~isempty(pixelsData)
        for ll = 1:size(Lectin, 1)
            % Extract pixel data for the current lectin
            tempPixels = pixelsData{ll};
            % Construct the file name and path for pixel data
            pixelFileName = fullfile(pixelsPath, strcat(Lectin{ll, "Sign"}, ".csv"));
            % Write the pixel data table to a CSV file
            writetable(tempPixels, pixelFileName);

            % Extract touch data for the current lectin
            tempTouch = touchData{ll};
            % Construct the file name and path for touch data
            touchFileName = fullfile(touchPath, strcat(Lectin{ll, "Sign"}, ".csv"));
            % Write the touch data table to a CSV file
            writetable(tempTouch, touchFileName);
        end % for ll
    end % if
end % function
