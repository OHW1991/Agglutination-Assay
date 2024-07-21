function [score, fig_score] = CombinedScore(final)
    % CombinedScore calculates a combined score based on normalized distances and ddG values.
    % It also generates a scatter plot of the scores.
    %
    % Inputs:
    %   final - Table containing the columns "DeltaDistance", "ddGSNATch", "ddGRNATch", "PSS", and "Name".
    %
    % Outputs:
    %   score - Combined score calculated as the sum of normalized distance, ddG SNA, and ddG RNA.
    %   fig_score - Handle to the generated figure.

    % Normalize the distance and ddG values by dividing by their respective maximum values
    norm_distance = final{:,"DeltaDistance"} ./ max(final{:,"DeltaDistance"});
    norm_ddG_SNA = final{:,"ddGSNATch"} ./ max(final{:,"ddGSNATch"});
    norm_ddG_RNA = final{:,"ddGRNATch"} ./ max(final{:,"ddGRNATch"});
    
    % Calculate the combined score as the sum of the normalized values
    score = norm_distance + norm_ddG_SNA + norm_ddG_RNA;

    % Create a figure for the scatter plot and maximize the window
    fig_score = figure(1000016);
    set(fig_score, 'WindowState', 'maximized');
    
    % Generate a scatter plot of PSS vs. the combined score
    scatter(final{:,"PSS"}, score, 50, 'filled');
    xlabel("Possible Sialylated Sites");
    ylabel("Combined Score");
    
    % Set the x and y limits and tick marks
    xlim([-0.5, max(final{:,"PSS"}) + 4 - 0.5]);
    xticks(0:max(final{:,"PSS"}) + 4);
    yticks(0:0.5:3);
    
    % Add text labels for each data point
    for pp = 1:size(final, 1)
        text(final{pp,"PSS"} + 0.2, score(pp), final{pp,"Name"});
    end % for pp
    
    % Calculate and display the Pearson correlation coefficient and its standard error
    [pearsonCorrelation, sem] = calculateAveragedPearsonCorrelation([final{:,"PSS"}, score]);
    text(20, 0.425, strcat("Pearson Coef. = ", num2str(round(pearsonCorrelation, 2)), char(177), num2str(round(sem, 2))), 'FontSize', 13, 'FontName', 'Times New Roman');
    
    % Set the font size and font name for the axes
    set(gca, 'FontSize', 17, 'FontName', 'Times New Roman');
    box on

end % function
