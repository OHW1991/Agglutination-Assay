function [] = WriteEventsProfile(path_data, path_file, file_name, color, eventsProfile)
    % WriteEventsProfile - Writes the events profile to a CSV file.
    %
    % Inputs:
    %   path_data - Path to the main data directory.
    %   path_file - Path to the specific file directory.
    %   file_name - Name of the file to write.
    %   color - String indicating the color associated with the event profile.
    %   eventsProfile - Table containing the events profile data.
    
    % Construct the path for saving the CSV file
    save_path = fullfile(replace(path_data, "Image Data", "FoVs Data"), file_name);
    
    % Check if the directory exists, if not, create it
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    
    % Construct the full file path including the file name and color
    full_file_name = fullfile(save_path, strcat(" Events Profile ", color, ".csv"));
    
    % Write the events profile table to a CSV file
    writetable(eventsProfile, full_file_name);
end
