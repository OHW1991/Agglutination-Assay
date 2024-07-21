function f = InitiateFigure(f_id)
    % This function initializes a figure window, maximizes it, sets its visibility, 
    % and positions it on a specified monitor. It also sets up a tiled layout for plotting.
    % Inputs:
    %   f_id - Identifier for the figure window
    % Outputs:
    %   f - Handle to the created figure
    
    % Retrieve the positions of all monitors
    MP = get(0, 'MonitorPositions');
    monitor = size(MP, 1); % Number of monitors

    % Create the figure with the specified ID
    f = figure(f_id);
    
    % Maximize the figure window
    set(f, 'WindowState', 'maximized');
    
    % Set the figure window to be invisible initially
    set(f, 'Visible', 'off');
    
    % Position the figure on the first monitor (change to 'monitor' for different screens)
    f.Position = MP(1, :); % Position on the 1st screen
    
    % Set up a tiled layout with 2 rows and 5 columns, indexing by columns
    tiledlayout(2, 5, 'TileIndexing', 'columnmajor'); % Layout for 10 proteins

end % function
