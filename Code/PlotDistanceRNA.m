function D_RNA = PlotDistanceRNA(D_RNA, lows, highs, pValue, Protein)
    % This function plots the RNA distance for low and high lectin concentrations
    % Inputs:
    %   D_RNA - Figure handle ID
    %   lows - Matrix containing low lectin concentration distances and group labels
    %   highs - Matrix containing high lectin concentration distances and group labels
    %   pValue - P-value for the comparison between low and high concentrations
    %   Protein - Name of the protein for the title
    % Output:
    %   D_RNA - Updated figure handle

    % Create a new figure and maximize the window
    D_RNA = figure(D_RNA);
    t = nexttile;
    box on

    % Prepare data for box plot
    dat = [lows(lows(:,1) ~= 0 & ~isnan(lows(:,1)), 1); highs(highs(:,1) ~= 0 & ~isnan(highs(:,1)), 1)];
    grp = [lows(lows(:,1) ~= 0 & ~isnan(lows(:,1)), 2); highs(highs(:,1) ~= 0 & ~isnan(highs(:,1)), 2)];

    % Create the box plot with labels
    b = boxplot(dat, grp, "Labels", strcat(["Low (N="; "High (N="], num2str([sum(lows(:,1) ~= 0 & ~isnan(lows(:,1))); sum(highs(:,1) ~= 0 & ~isnan(highs(:,1)))]), [")"; ")"]));

    % Display the p-value on the plot
    text(0.75, 50, strcat("p-value=", num2str(pValue)), 'FontName', 'helvetica');

    % Determine and display the significance level
    if (pValue < 0.0001)
        sig = "****";
    elseif (pValue < 0.001)
        sig = "***";
    elseif (pValue < 0.01)
        sig = "**";
    elseif (pValue < 0.05)
        sig = "*";
    else
        sig = "NS";
    end
    text(0.75, 10, sig, 'FontName', 'helvetica');

    % Set y-axis to logarithmic scale and adjust limits and labels
    set(t, 'yscale', 'log');
    ylim([10^-3, 10^2]);
    ylabel("D_R_N_A [um]");
    yticks(10.^(-3:2));
    xlabel("Lectin Conc.");
    title(Protein);

    % Overlay swarm plot and scatter plot for means
    hold on
    swarmchart(1 * ones(numel(dat(grp == 1)), 1), dat(grp == 1), '.k');
    swarmchart(2 * ones(numel(dat(grp == 2)), 1), dat(grp == 2), '.k');
    scatter([1, 2], [mean(lows(lows(:,1) ~= 0 & ~isnan(lows(:,1)), 1)), mean(highs(highs(:,1) ~= 0 & ~isnan(highs(:,1)), 1))], 'r', 'filled');
    hold off

    % Set font properties
    set(gca, 'FontName', 'helvetica');

end % function
