function f = DebugFoV(cols, thresholds, img, imgLogical, L, nEvents)
    % This function creates a series of plots to debug and visualize image data.
    % It includes histograms, heatmaps, and labeled images.
    % Inputs:
    %   cols - Cell array of colors to be used for different plots
    %   thresholds - Threshold values for each channel
    %   img - Cell array of images to be plotted
    %   imgLogical - Cell array of binary images (logical arrays) for boundary detection
    %   L - Cell array of labeled images
    %   nEvents - Number of events (boundaries) for each image
    % Output:
    %   f - Handle to the created figure

    % Define panel types and bin edges for histograms
    debug_panels = ["Histogram"; "Heatmap"; "Labels"];
    binEdges = 0:10^2:7*10^4;

    % Create and maximize the figure window
    f = figure('Visible', 'on');
    set(f, 'WindowState', 'maximized');
    
    % Arrange subplots in a tiled layout
    tiledlayout(numel(cols), numel(debug_panels));
    
    % Initialize cell array to hold boundaries for each image
    boundaries = repmat({}, numel(cols), 1);

    % Loop through each column (image) for plotting
    for cc = 1:numel(cols)
        % Fill holes in the logical image and find boundaries
        BW_filled = imfill(imgLogical{cc}, 'holes');
        boundaries{cc} = bwboundaries(BW_filled);

        % Loop through each debug panel type
        for tt = 1:numel(debug_panels)
            t = nexttile; % Get next subplot tile

            % Switch case to handle different types of panels
            switch(debug_panels(tt))
                case "Histogram"
                    % Plot histogram of the image intensities
                    histogram(img{cc}, binEdges, 'FaceColor', cols(cc), 'Normalization', "probability");
                    hold on
                    % Add vertical line for the threshold
                    xline(thresholds(cc), strcat("--", cols(cc)), 'LineWidth', 2);
                    xlim([min(binEdges), max(binEdges)]);
                    % Set logarithmic scale for x and y axes
                    set(t, 'xscale', 'log');
                    set(t, 'yscale', 'log');
                    xlabel("Intensity [A.U.]");
                    ylabel("Pixels Frequency");

                case "Heatmap"
                    % Plot heatmap of the image
                    imagesc(img{cc});
                    title(strcat("Color=", cols(cc)));
                    colorbar;
                    hold on
                    % Overlay boundaries on the heatmap
                    for ii = 1:nEvents(cc)
                        b = boundaries{cc}{ii};
                        plot(b(:, 2), b(:, 1), 'g', 'LineWidth', 3);
                    end % for ii
                    hold off
                    axis off
                    axis equal

                case "Labels"
                    % Plot labeled image
                    imagesc(L{cc});
                    title(strcat("N=", num2str(numel(unique(L{cc})) - 1))); % Exclude background (value 0)
                    hold on
                    % Overlay boundaries on the labeled image
                    for ii = 1:nEvents(cc)
                        b = boundaries{cc}{ii};
                        plot(b(:, 2), b(:, 1), 'g', 'LineWidth', 3);
                    end % for ii
                    hold off
                    axis off
                    axis equal
            end % switch
        end % for tt
    end % for cc

    % Save figure as .jpg or .pdf (commented out for now)
    % saveas(f, strcat(replace(path_file, "Image Data", "FoVs Data"), file_name, ".jpg"));
    % saveas(f, strcat(replace(path_file, "Image Data", "FoVs Data"), file_name, ".pdf"));
end % function
