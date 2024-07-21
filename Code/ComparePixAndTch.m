function pix_v_tch = ComparePixAndTch(pix_v_tch, ProteinList, valsPix, valsTch, ss)
    % ComparePixAndTch compares pixel-based ddG values and touch-based ddG values
    % by creating a scatter plot.
    %
    % Inputs:
    %   pix_v_tch - Figure handle for the comparison plot.
    %   ProteinList - List of protein names corresponding to the values.
    %   valsPix - Vector of pixel-based ddG values.
    %   valsTch - Vector of touch-based ddG values.
    %   ss - Subplot index (1 or 2) to determine subplot position and color.
    %
    % Outputs:
    %   pix_v_tch - Updated figure handle for the comparison plot.

    % Create or select the figure for the comparison plot
    pix_v_tch = figure(pix_v_tch);
    set(pix_v_tch, 'WindowState', 'maximized');

    % Set the color based on the subplot index
    switch(ss)
        case 1
            color = [0.4660 0.6740 0.1880]; % Green color for subplot 1
        case 2
            color = [0 0.4470 0.7410]; % Blue color for subplot 2
    end % switch
    
    % Create a subplot and scatter plot of the pixel-based vs touch-based ddG values
    s = subplot(1, 2, ss);
    scatter(valsPix, valsTch, 'MarkerFaceColor', color);
    xlabel("ddG_p_i_x = ln(Kd b.tdPP7/Kd protein)");
    ylabel("ddG_e_v_t = ln(Kd b.tdPP7/Kd protein)");
    title("Lectin Binding");
    
    % Add a reference line with a slope of 1
    hold on
    plot(-100:100, -100:100);
    hold off
    
    % Set the x and y limits and tick marks
    xlim(round([floor(min([valsPix, valsTch])), ceil(max([valsPix, valsTch]))], 1));
    xticks(floor(min([valsPix, valsTch])):0.5:ceil(max([valsPix, valsTch])));
    ylim(round([floor(min([valsPix, valsTch])), ceil(max([valsPix, valsTch]))], 1));
    yticks(floor(min([valsPix, valsTch])):0.5:ceil(max([valsPix, valsTch])));
    
    % Fit a linear model to the data and calculate the adjusted R-squared value
    mdl = fitlm(valsPix, valsTch);
    Rsquared_adj_green = mdl.Rsquared.Adjusted;
    
    % Add a legend with the adjusted R-squared value
    legend(strcat(...
        "Granules Binding (R^2=",...
        num2str(Rsquared_adj_green),...
        ")"),...
        'Location', 'Northwest');
    box on
    
    % Add text labels for each data point with the corresponding protein names
    for pp = 1:size(ProteinList, 1)
        text(valsPix(pp) + 0.1, valsTch(pp), ProteinList{pp});
    end % for pp

end % function
