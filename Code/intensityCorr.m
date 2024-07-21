function [Rsquared_adj_rb, meanRB] = intensityCorr(img, L_red)
    % This function calculates the adjusted R-squared values for the linear 
    % correlation between intensities in different color channels and 
    % computes the mean values of the red and blue channels within a region.
    % Inputs:
    %   img - A cell array containing the image matrices for different color channels
    %   L_red - Label matrix for the red channel
    % Outputs:
    %   Rsquared_adj_rb - Adjusted R-squared values for the correlation between
    %                     red and blue channels
    %   meanRB - Mean intensity values of the red and blue channels
    
    % Extract color channels from the cell array
    ch_r = img{1}; % Red channel image
    ch_g = img{2}; % Green channel image
    ch_b = img{3}; % Blue channel image

    % List of unique labels in the red channel image, excluding zero
    RedList = unique(L_red);
    RedList = RedList(2:end); % Remove label 0 (background)

    % Initialize arrays to store adjusted R-squared values and mean intensities
    Rsquared_adj_rg = [];
    Rsquared_adj_rb = [];
    Rsquared_adj_gb = [];
    meanRB = [];

    % Check if RedList is not empty
    if ~isempty(RedList)
        % Preallocate arrays for efficiency
        Rsquared_adj_rg = zeros(numel(RedList), 1);
        Rsquared_adj_rb = zeros(numel(RedList), 1);
        Rsquared_adj_gb = zeros(numel(RedList), 1);
        meanRB = zeros(numel(RedList), 2);

        % Iterate through each label in RedList
        for rr = 1:numel(RedList)
            % Find coordinates of the current label in the red channel image
            [x, y] = find(L_red == RedList(rr));
            kk = 0;
            r = [];
            g = [];
            b = [];

            % Extract intensity values from a region around the label
            for ii = max([min(x)-7, 1]):min([max(x)+7, 512])
                for jj = max([min(y)-7, 1]):min([max(y)+7, 512])
                    kk = kk + 1;
                    r(kk) = ch_r(ii, jj);
                    g(kk) = ch_g(ii, jj);
                    b(kk) = ch_b(ii, jj);
                end
            end

            % Perform linear regression and compute adjusted R-squared values
            mdl_rg = fitlm(r, g);
            Rsquared_adj_rg(rr) = mdl_rg.Rsquared.Adjusted;
            mdl_rb = fitlm(r, b);
            Rsquared_adj_rb(rr) = mdl_rb.Rsquared.Adjusted;
            mdl_gb = fitlm(g, b);
            Rsquared_adj_gb(rr) = mdl_gb.Rsquared.Adjusted;

            % Calculate mean intensities for red and blue channels
            meanRB(rr, :) = [mean(r), mean(b)];

            % Optionally, uncomment to visualize results (currently commented out)
            % f = figure;
            % subplot(1, 3, 1);
            % scatter(r, g, 'g');
            % xlabel("mCherry Intensity [A.U.]");
            % ylabel("FITC Intensity [A.U.]");
            % hold on;
            % plot([0, 0], [10^5, 10^5], 'r', 'LineWidth', 2);
            % hold off;
            % legend(["Data", strcat("y=x Adj. R^2=", num2str(Rsquared_adj_rg))]);
            % xlim([0, max(max([r, g, b]))]);
            % ylim([0, max(max([r, g, b]))]);
            % subplot(1, 3, 2);
            % scatter(r, b, 'b');
            % xlabel("mCherry Intensity [A.U.]");
            % ylabel("AF405 Intensity [A.U.]");
            % hold on;
            % plot([0, 0], [10^5, 10^5], 'r', 'LineWidth', 2);
            % hold off;
            % legend(["Data", strcat("y=x Adj. R^2=", num2str(Rsquared_adj_rb))]);
            % xlim([0, max(max([r, g, b]))]);
            % ylim([0, max(max([r, g, b]))]);
            % subplot(1, 3, 3);
            % scatter(g, b, 'k');
            % xlabel("FITC Intensity [A.U.]");
            % ylabel("AF405 Intensity [A.U.]");
            % hold on;
            % plot([0, 0], [10^5, 10^5], 'r', 'LineWidth', 2);
            % hold off;
            % legend(["Data", strcat("y=x Adj. R^2=", num2str(Rsquared_adj_gb))]);
            % xlim([0, max(max([r, g, b]))]);
            % ylim([0, max(max([r, g, b]))]);
        end
        % Remove NaN values from the results
        Rsquared_adj_rg = Rsquared_adj_rg(~isnan(Rsquared_adj_rg));
        Rsquared_adj_rb = Rsquared_adj_rb(~isnan(Rsquared_adj_rb));
        Rsquared_adj_gb = Rsquared_adj_gb(~isnan(Rsquared_adj_gb));
    end

end % function
