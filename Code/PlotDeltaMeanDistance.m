function f = PlotDeltaMeanDistance(f_id, Protein, delMean, pValue, SDMean)
    % This function plots the change in mean distance (ΔD_avg) against the
    % number of possible sialylated sites for a set of proteins.
    % Inputs:
    %   f_id - Figure ID
    %   Protein - Table containing protein names and the number of possible sialylated sites
    %   delMean - Array of change in mean distances (ΔD_avg)
    %   pValue - Array of p-values for the ΔD_avg values
    %   SDMean - Array of standard deviations for the ΔD_avg values
    % Output:
    %   f - Figure handle

    f = figure(f_id);
    set(f, 'WindowState', 'maximized');
    PossibleSialylatedSites = Protein{:,"PossibleSialylatedSites"};
    
    % Scatter plot with color and size based on -log10(pValue)
    s = scatter(PossibleSialylatedSites, delMean, -log10(pValue) * 50, -log10(pValue), 'filled');
    
    % Set labels and plot properties
    xlabel("#Possible Sialylated Sites");
    ylabel("\DeltaD_a_v_g[\mum]");
    
    % Add text labels to each point
    for pp = 1:size(Protein, 1)
        text(PossibleSialylatedSites(pp) + (-log10(pValue(pp))) * 0.02 + 0.2, delMean(pp), Protein{pp, "Name"}, 'FontName', 'times new roman');
    end
    
    % Set axis limits and ticks
    xlim([-1, 25]);
    xticks(0:24);
    yticks(0:0.05:0.5);
    
    % Add color bar
    cb = colorbar;
    colormap('jet');
    ylabel(cb, '-log_1_0(p-value)', 'FontSize', 16, 'Rotation', 270, 'FontName', 'times new roman');
    
    % Calculate and display Pearson correlation coefficient and SEM
    [pearsonCorrelation, sem] = calculateAveragedPearsonCorrelation([PossibleSialylatedSites, delMean]);
    text(20, 0.425, strcat("Pearson Coef. = ", num2str(round(pearsonCorrelation, 2)), char(177), num2str(round(sem, 2))), 'FontSize', 13, 'FontName', 'david');
    
    % Set font and box properties
    set(gca, 'FontSize', 17, 'FontName', 'times new roman');
    box on

end %function
