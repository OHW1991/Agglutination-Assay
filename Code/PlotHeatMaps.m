function fitHeat = PlotHeatMaps(fitData, KdData, Lectin, Protein)
    % This function plots heat maps for SNA binding and RNA exclusion data
    % Inputs:
    %   fitData - Cell array containing fitting data
    %   KdData - Cell array containing Kd data
    %   Lectin - Table containing lectin concentration data
    %   Protein - Table containing protein data
    % Output:
    %   fitHeat - Figure handle for the heat map

    % Load colormaps
    load SNA_Cmap.mat
    load RNA_Cmap.mat

    % Define new order for proteins
    new_order = [9 5 10 2 6 8 1 7 3 4];

    % Create a new figure and maximize the window
    fitHeat = figure(1000013);
    set(fitHeat, 'WindowState', 'maximized');
    box on

    % Loop through each type of data and plot heat maps
    ii = 0;
    for ff = [1, 3, 2, 4]
        ii = ii + 1;
        % Select colormap based on data type
        if ff == 1 || ff == 3
            cmap = SNA_Cmap;
        elseif ff == 2 || ff == 4
            cmap = RNA_Cmap;
        end

        % Get fitting data and Kd data for current data type
        dat = fitData{ff};
        Kd = KdData{ff};

        % Create a subplot for the heat map
        subplot(2, 2, ii);

        % Normalize data and create heat map
        h = heatmap(dat(new_order, 2:end) ./ max(dat(new_order, 2:end), [], 2), 'CellLabelColor', 'none');
        h.XData = num2str(round(Lectin{2:end, "Concentration"} * 1.9 / 17.9, 4));
        xlabel("SNA Concentration [mg/ml]");
        ylabel("[#SA] Protein (K_d)");

        % Set Y-axis labels with protein information
        h.YData = strcat(...
            repmat("[", size(Protein, 1), 1), ...
            num2str(Protein{new_order, "PossibleSialylatedSites"}), ...
            repmat("] ", size(Protein, 1), 1), ...
            Protein{new_order, "Name"}, ...
            repmat(" (", size(Protein, 1), 1), ...
            num2str(round((Kd(1, new_order))', 3)), ...
            repmat(")", size(Protein, 1), 1) ...
        );

        % Set colormap and color limits
        colormap(h, cmap);
        colorbar;
        clim([0, 1]);

        % Set title based on data type
        switch ff
            case 1
                ttl = "SNA Binding (MPP)";
            case 2
                ttl = "RNA Exclusion (MPP)";
            case 3
                ttl = "SNA Binding (MPE)";
            case 4
                ttl = "RNA Exclusion (MPE)";
        end
        title(ttl);

        % Set font properties
        set(gca, 'FontName', 'times new roman');
    end
end
