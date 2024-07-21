function [f, valsPix, valsTch] = ddG(f_id, ddG_type, Protein, Kd_pixels, Kd_intervals_pixels, Kd_touch, Kd_intervals_touch)
    % This function generates plots for delta delta G values from pixel and touch data.
    % It also calculates error metrics and Pearson correlation coefficients.
    % Inputs:
    %   f_id - Figure ID for the plot
    %   ddG_type - Type of data (e.g., 'SNA', 'RNA') for coloring
    %   Protein - Table with protein information
    %   Kd_pixels - Data related to pixel Kd values
    %   Kd_intervals_pixels - Intervals for pixel Kd values
    %   Kd_touch - Data related to touch Kd values
    %   Kd_intervals_touch - Intervals for touch Kd values
    % Outputs:
    %   f - Handle to the figure created
    %   valsPix - Calculated delta delta G values for pixel data
    %   valsTch - Calculated delta delta G values for touch data

    % Calculate delta delta G values for pixel data
    valsPix = log(Kd_pixels(1, 9) ./ Kd_pixels(1, :));
    
    % Calculate relative changes for pixel data
    relPix = abs((Kd_intervals_pixels(:, 2) - Kd_intervals_pixels(:, 1)) ./ valsPix');
    
    % Calculate error for pixel data (sqrt of sum of squared errors)
    errorPix = sqrt(relPix(9)^2 + relPix.^2);
    
    % Calculate delta delta G values for touch data
    valsTch = log(Kd_touch(1, 9) ./ Kd_touch(1, :));
    
    % Calculate relative changes for touch data
    relTch = abs(log(Kd_intervals_touch(:, 2) - Kd_intervals_touch(:, 1)));
    
    % Calculate error for touch data (sqrt of sum of squared errors)
    errorTch = sqrt(relTch(9)^2 + relTch.^2);
    
    % Extract possible sialylated sites from the Protein table
    PossibleSialylatedSites = Protein{:,"PossibleSialylatedSites"};
    
    % Create or maximize the figure specified by f_id
    f = figure(f_id);
    set(f, 'WindowState', 'maximized');

    % Define color based on the ddG_type
    switch ddG_type
        case "SNA"
            color = [0.4660 0.6740 0.1880]; % Green color for SNA
        case "RNA"
            color = [0 0.4470 0.7410]; % Blue color for RNA
    end % switch

    % Plot pixel data
    subplot(121)
    scatter(PossibleSialylatedSites, valsPix, 'MarkerFaceColor', color);
    xlabel("Possible Sialylated Sites");
    ylabel("\Delta\DeltaG");
    title("MPP - SNA Binding");
    xticks(min(PossibleSialylatedSites):2:max(PossibleSialylatedSites)+4);
    xlim([min(PossibleSialylatedSites)-0.5, max(PossibleSialylatedSites)+4]);
    ylim(round([floor(min([valsPix, valsTch]))-0.25, ceil(max([valsPix, valsTch]+1))],1));
    yticks(floor(min([valsPix, valsTch])):0.5:ceil(max([valsPix, valsTch])+1));
    
    % Annotate each point with protein name
    for pp = 1:size(Protein, 1)
        text(PossibleSialylatedSites(pp) + 0.1, valsPix(pp), Protein{pp, "Name"}, 'FontSize', 13, 'FontName', 'times new roman');
    end % for pp
    
    % Add Pearson correlation coefficient text
    [pearsonCorrelation, sem] = calculateAveragedPearsonCorrelation([PossibleSialylatedSites, valsPix']);
    text(10.5, 0, strcat("Pearson Coef. = ", num2str(round(pearsonCorrelation, 2)), char(177), num2str(round(sem, 2))), 'FontSize', 17, 'FontName', 'times new roman');
    
    % Set plot appearance
    set(gca, 'FontSize', 17, 'FontName', 'times new roman');
    hold off

    % Plot touch data
    subplot(122)
    scatter(PossibleSialylatedSites, valsTch, 'MarkerFaceColor', color);
    xlabel("Possible Sialylated Sites");
    ylabel("\Delta\DeltaG");
    title("MPE - SNA Binding");
    xticks(min(PossibleSialylatedSites):2:max(PossibleSialylatedSites)+4);
    xlim([min(PossibleSialylatedSites)-0.5, max(PossibleSialylatedSites)+4]);
    ylim(round([floor(min([valsPix, valsTch]))-0.25, ceil(max([valsPix, valsTch])+1))], 1));
    yticks(floor(min([valsPix, valsTch])):0.5:ceil(max([valsPix, valsTch])+1));
    
    % Annotate each point with protein name
    for pp = 1:size(Protein, 1)
        text(PossibleSialylatedSites(pp) + 0.1, valsTch(pp), Protein{pp, "Name"}, 'FontSize', 13, 'FontName', 'times new roman');
    end % for pp
    
    % Add Pearson correlation coefficient text
    [pearsonCorrelation, sem] = calculateAveragedPearsonCorrelation([PossibleSialylatedSites, valsTch']);
    text(10.5, 0, strcat("Pearson Coef. = ", num2str(round(pearsonCorrelation, 2)), char(177), num2str(round(sem, 2))), 'FontSize', 17, 'FontName', 'times new roman');
    
    % Set plot appearance
    set(gca, 'FontSize', 17, 'FontName', 'times new roman');
    hold off
end % function
