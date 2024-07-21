function [ind, lectin_symbol, lectin_conc, FoV] = BreakFileName(file_name, Lectin)
    % BreakFileName extracts information from the file name.
    % 
    % Inputs:
    %   file_name - The name of the file containing relevant data.
    %   Lectin - A table containing lectin data with columns 'Sign' and 'Concentration'.
    %
    % Outputs:
    %   ind - Index of the lectin in the Lectin table.
    %   lectin_symbol - The symbol representing the lectin.
    %   lectin_conc - The concentration of the lectin.
    %   FoV - Field of View extracted from the file name.

    % Find the position of the first space in the file name to locate the lectin symbol
    lectin_symbol = strfind(file_name, " ");
    % Extract the lectin symbol from the file name
    lectin_symbol = file_name(lectin_symbol(1) + 1);
    % Find the index of the lectin symbol in the Lectin table
    ind = find(strcmp(Lectin{:,"Sign"}, lectin_symbol));
    % Retrieve the concentration of the lectin from the Lectin table
    lectin_conc = Lectin{ind, "Concentration"};
    % Find the position of "FoV" in the file name to locate the Field of View
    FoV = strfind(file_name, "FoV");
    % Extract the Field of View number from the file name
    FoV = file_name(FoV + 3);

end % function