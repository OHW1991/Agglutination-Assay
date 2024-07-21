function [f, f_fit] = PlotData(f, f_fit, data_type, xData, yData, error, yFit, Kd, protein_name)
    % This function plots the experimental data and the fitted data on two separate figures.
    % Inputs:
    %   f - Figure handle for the data plot
    %   f_fit - Figure handle for the fitted plot
    %   data_type - Type of data being plotted (string)
    %   xData - X-axis data (lectin concentrations)
    %   yData - Y-axis data (experimental data)
    %   error - Error bars for the experimental data
    %   yFit - Fitted Y-axis data
    %   Kd - Dissociation constants
    %   protein_name - Name of the protein being analyzed
    % Outputs:
    %   f - Updated figure handle for the data plot
    %   f_fit - Updated figure handle for the fitted plot

    cols = ["r"; "g"; "b"; "m"];
    coloc_types = ["NoColoc"; "ColocGreen"; "ColocBlue"; "ColocAll"];

    % Plot the experimental data
    f = figure(f);
    t = nexttile;
    box on
    
    p = errorbar(xData, yData, error, '-o');
    for tt = 1:numel(coloc_types)
        p(tt).Color = cols(tt);
    end
    legend(coloc_types);
    set(t, 'xscale', 'log');
    title(protein_name);
    xlabel("Lectin Conc. [mg/ml]");
    xlim([0.8 * min(xData), 1.2 * max(xData)]);
    xticks([0.0001, 0.0002, 0.0005, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5]);
    ylabel(data_type);
    ylim([0, 1.1]);
    yticks(0:0.1:1);
    set(gca, 'FontName', 'times new roman');

    % Plot the fitted data
    f_fit = figure(f_fit);
    t = nexttile;
    box on

    for tt = 2:numel(coloc_types)
        switch coloc_types(tt)
            case "ColocGreen"
                fitColor = [0.4660, 0.6740, 0.1880];
            case "ColocBlue"
                fitColor = [0, 0.4470, 0.7410];
            case "ColocAll"
                fitColor = [102/255, 70/255, 137/255];
        end
        hold on
        plot(xData, yFit(tt-1, :), 'Color', fitColor, 'LineWidth', 3);
        xline(Kd(tt-1), ':', 'Color', fitColor, 'LineWidth', 2);
        scatter(xData, yData(tt, :), 'MarkerFaceColor', cols(tt));
        hold off
        xticks([0.0001, 0.0002, 0.0005, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5]);
        set(t, 'xscale', 'log');
        xlabel("Lectin Conc. [mg/ml]");
        xlim([0.8 * min(xData), 1.2 * max(xData)]);
        ylabel(data_type);
        ylim([0, 1.1]);
        yticks(0:0.1:1);
        title(protein_name);
        legend([
            "Fit Lectin-binding", ...
            strcat("Kd Lectin Binding=", num2str(round(Kd(1), 3))), ...
            "Lectin-binding Data", ...
            "Fit Granules Melting", ...
            strcat("Kd Granules Melting=", num2str(round(Kd(2), 3))), ...
            "Granules Melting Data", ...
            "Fit Granules Binding", ...
            strcat("Kd Granules Binding=", num2str(round(Kd(3), 3))), ...
            "Granules Binding Data"
        ]);
    end
    set(gca, 'FontName', 'times new roman');

end % function
