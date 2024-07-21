function [dirs, path_new] = GetFolders(path_old, appendage)
    % This function retrieves directories from a specified path and excludes 
    % the '.' and '..' directories.
    % Inputs:
    %   path_old - Original path to append appendage to
    %   appendage - Subdirectory or string to append to the original path
    % Outputs:
    %   dirs - List of directories in the new path
    %   path_new - The new path created by appending the appendage to the original path
    
    % Create the new path by concatenating path_old with appendage and a trailing backslash
    path_new = strcat(path_old, appendage, "\");
    
    % Retrieve the contents of the new path
    dir_content = dir(path_new);
    
    % Filter out only directories from the contents
    dirs = [dir_content.isdir];
    dirs = dir_content(dirs);
    
    % Exclude '.' and '..' directories which are the first two entries
    dirs = dirs(3:end, :);
end % function
