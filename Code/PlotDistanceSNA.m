function D_SNA = PlotDistanceSNA(D_SNA, Protein, Lectin, distCentroidGreen, mean_dist)
    % This function plots the SNA distance for different lectin concentrations
    % Inputs:
    %   D_SNA - Figure handle ID
    %   Protein - Name of the protein for the title
    %   Lectin - Table containing lectin concentration data
    %   distCentroidGreen - Table containing distance data for each lectin concentration
    %   mean_dist - Array of mean distances for each lectin concentration
    % Output:
    %   D_SNA - Updated figure handle

    % Create a new figure and maximize the window
    D_SNA = figure(D_SNA);
    t = nexttile;
    box on
    
    % Ensure each concentration in Lectin has a corresponding distance in distCentroidGreen
    for ll = 1:size(Lectin, 1)
        temp = distCentroidGreen{distCentroidGreen{:,"LectinConcentration"} == Lectin{ll, "Concentration"}, "Distance"};
        temp = temp(~isinf(temp));
        if isempty(temp)
            temp = NaN;
            distCentroidGreen{end+1, 1} = NaN;
            distCentroidGreen{end, 2} = Lectin{ll, "Concentration"};
        end
    end

    % Create a box plot with rounded lectin concentrations
    b = boxplot(distCentroidGreen{:,1}, round(distCentroidGreen{:,2} * 1.9 / 17.9, 4));
    ylabel("D_S_N_A [um]");
    yticks(0:1:65);
    title(Protein);
    xlabel("Lectin Conc. [mg/ml]");
    ylim([0,15]);

    % Plot exponential decay fit for mean distances
    plotExponentialDecayFit(Lectin{:,"Concentration"} * 1.9 / 17.9, mean_dist);
    legend('show', 'Location', 'northeast');
    
    % Highlight the region where no SNA is detected
    hold on
    ind = find(~isnan(mean_dist));
    ind = ind(1) - 1;
    rectangle('Position', [0+0.5, 0, ind, 15], 'FaceColor', [238/255, 238/255, 238/255])
    h = text(ind/2 + 0.5, 0.3, ["No SNA", "Detected"]);
    set(h, 'Rotation', 90);
    hold off

    % Set font properties
    set(gca, 'FontName', 'times new roman');

end % function
