close all
clear all

%% General Assignments

% Flags
debugFlag = 0; % For raw data visualization
figFlag = 1; % For figures visualization
acquireFlag = 1; % For data acquisition
saveFlag = 0; % For saving data

% Parameters
cols = ["r", "g", "b"]; % Colors: red, green, blue
[Protein, RNA, Lectin] = InitiateSpecies(); % Initialize species data
[sizeThresh, threshR, threshG, threshB] = InitiateThresholds(); % Initialize thresholds
thresholds = [NaN, threshG, threshB]; % Thresholds for green and blue

%% Data Acquisition

% If figures visualization is enabled
if(figFlag)
    % Initialize figures for different data visualizations
    pix = InitiateFigure(1000001);
    tch = InitiateFigure(1000002);
    pixFit = InitiateFigure(1000003);
    tchFit = InitiateFigure(1000004);
    areaSNA = InitiateFigure(1000008);
    areaRNA = InitiateFigure(1000009);
    D_SNA = InitiateFigure(1000010);
    D_RNA = InitiateFigure(1000011);
    AbsolutePix = InitiateFigure(1000014);
    AbsoluteTch = InitiateFigure(1000015);
end

% Setup for figures
f = figure(345344);
set(f, 'WindowState', 'maximized');
tiledlayout(2, 5, 'TileIndexing', 'columnmajor'); % Layout for 10 proteins
f = figure(345345);
set(f, 'WindowState', 'maximized');
tiledlayout(2, 5, 'TileIndexing', 'columnmajor'); % Layout for 10 proteins

% Get data folders
path = 'Image Data';
[dirs_protein, path_protein] = GetFolders(path, "");

% Initialize variables for data storage and analysis
Kd_pixels = zeros(3, size(Protein, 1));
Kd_intervals_pixels = zeros(size(Protein, 1), 3, 2);
Kd_touch = zeros(3, size(Protein, 1));
Kd_intervals_touch = zeros(size(Protein, 1), 3, 2);
delMean = zeros(size(Protein, 1), 1);
SDMean = zeros(size(Protein, 1), 1);
pValue = zeros(size(Protein, 1), 1);

% Initialize data arrays for plotting
yDataPix_g = zeros(size(Protein, 1), size(Lectin, 1));
yDataPix_b = zeros(size(Protein, 1), size(Lectin, 1));
yDataTch_g = zeros(size(Protein, 1), size(Lectin, 1));
yDataTch_b = zeros(size(Protein, 1), size(Lectin, 1));

corrRB = repmat({[]}, 10, 1);
meanRB = repmat({[]}, 10, 1);

% Loop over each protein directory
for pp = 1:size(dirs_protein, 1)
    thresholds(cols == 'r') = threshR(pp); % Set threshold for red
    protein_species = dirs_protein(pp).name;
    [dirs_RNA, path_RNA] = GetFolders(path_protein, protein_species);
    dirs_RNA = dirs_RNA(2); % Ignore 'no cassette' directories

    % Loop over each RNA directory
    for rr = 1:size(dirs_RNA, 1)
        RNA_species = dirs_RNA(rr).name;
        [dirs_date, path_repeat] = GetFolders(path_RNA, RNA_species);
        pixelsData = repmat({{}}, size(Lectin, 1), 1);
        touchData = repmat({{}}, size(Lectin, 1), 1);
        distCentroidBlue = {};
        distCentroidGreen = {};
        relAreaBlue = {};
        relAreaGreen = {};

        % If data acquisition is enabled
        if(acquireFlag)
            % Loop over each date directory
            for dd = 1:size(dirs_date, 1)
                repeat_date = dirs_date(dd).name;
                [dirs_data, path_data] = GetFolders(path_repeat, repeat_date);

                % Loop over each data file
                for ff = 1:size(dirs_data, 1)
                    file_name = dirs_data(ff).name;
                    path_file = strcat(path_data, file_name, "\");
                    dir_content = dir(path_file);
                    colors = ~[dir_content.isdir];
                    colors = dir_content(colors);

                    % Break file name into components
                    [ind, lectin_symbol, lectin_conc, FoV] = BreakFileName(file_name, Lectin);

                    % Initialize image variables
                    [img, imgLogical, L, nEvents] = InitiateImageVariables(cols);
                    for cc = 1:numel(cols)
                        [img{cc}, imgLogical{cc}, L{cc}, nEvents(cc)] = ImageProfiling(path_file, colors(cc).name, thresholds(cc));
                    end

                    % Debugging: visualize raw data
                    if(debugFlag)
                        f = DebugFoV(cols, thresholds, img, imgLogical, L, nEvents);
                    end

                    % Profile events in images
                    eventsProfile = repmat({}, size(colors, 1), 1);
                    for cc = 1:numel(cols)
                        [eventsProfile{cc}, img{cc}, imgLogical{cc}, L{cc}, nEvents(cc)] = CleanAndProfileFoV(sizeThresh, img{cc}, imgLogical{cc}, L{cc}, nEvents(cc));
                        WriteEventsProfile(path_data, path_file, file_name, cols(cc), eventsProfile{cc});
                    end

                    % Debugging: visualize cleaned data
                    if(debugFlag)
                        f = DebugFoV(cols, thresholds, img, imgLogical, L, nEvents);
                    end

                    % Calculate intensity correlations and distances
                    [tempCorr, tempMean] = intensityCorr(img, L{cols == 'r'});
                    corrRB{pp, rr} = [corrRB{pp, rr}; [tempCorr, lectin_conc * 1.9 / 17.9 * ones(numel(tempCorr), 1)]];
                    meanRB{pp, rr} = [meanRB{pp, rr}; tempMean];

                    distCentroidBlue = [distCentroidBlue; DistanceAnalysis(lectin_conc, L{cols == 'r'}, imgLogical{cols == 'r'}, imgLogical{cols == 'b'})];
                    distCentroidGreen = [distCentroidGreen; DistanceAnalysis(lectin_conc, L{cols == 'r'}, imgLogical{cols == 'r'}, imgLogical{cols == 'g'})];
                    relAreaBlue = [relAreaBlue; RelativeAreaAnalysis(lectin_conc, L{cols == 'r'}, imgLogical{cols == 'r'}, imgLogical{cols == 'b'})];
                    relAreaGreen = [relAreaGreen; RelativeAreaAnalysis(lectin_conc, L{cols == 'r'}, imgLogical{cols == 'r'}, imgLogical{cols == 'g'})];

                    % Analyze events if multiple objects are detected
                    if(~(numel(unique(L{cols == 'r'})) == 1))
                        eventsPixels = MPP(L{cols == 'r'}, imgLogical{cols == 'g'}, imgLogical{cols == 'b'});
                        pixelsData{ind} = [pixelsData{ind}; CompileMPP(repeat_date, lectin_conc, FoV, eventsPixels)];
                        eventsTouch=MPE2(L,sizeThresh);
                        touchData{ind} = [touchData{ind}; CompileMPE(repeat_date, lectin_conc, FoV, eventsTouch)];
                    end
                end % End of file loop
            end % End of date loop

            % Compile distance and relative area data
            distCentroidGreen = CompileDist(distCentroidGreen);
            distCentroidBlue = CompileDist(distCentroidBlue);
            relAreaGreen = CompileRelArea(relAreaGreen);
            relAreaBlue = CompileRelArea(relAreaBlue);

            % Save data if saveFlag is enabled
            if(saveFlag)
                WriteMPPAndMPEData(path_repeat, Lectin, pixelsData, touchData);
                WriteRelAreaAndDistance(path_repeat, Lectin, relAreaGreen, relAreaBlue, distCentroidGreen, distCentroidBlue);
            end
        end

        %% Plotting
        % Code for plotting data (commented out for brevity)

        % Process data if acquisition is enabled
        if(acquireFlag)
            [data, xData, yData, error, yFit, Kd_pixels(:, pp), Kd_intervals_pixels(pp, :, :)] = CompileData(pixelsData, "MPP", path_repeat, Lectin);
            if(figFlag)
                AbsolutePix = Absolutes(AbsolutePix, data, "MPP", Lectin, Protein{pp, "Name"});
                [pix, pixFit] = PlotData(pix, pixFit, "MPP", xData, yData, error, yFit, Kd_pixels(:, pp), Protein{pp, "Name"});
            end
            yDataPix_g(pp, :) = yFit(1, :);
            yDataPix_b(pp, :) = yFit(2, :);

            [data, xData, yData, error, yFit, Kd_touch(:, pp), Kd_intervals_touch(pp, :, :)] = CompileData(touchData, "MPE", path_repeat, Lectin);
            if(figFlag)
                AbsoluteTch = Absolutes(AbsoluteTch, data, "MPE", Lectin, Protein{pp, "Name"});
                [tch, tchFit] = PlotData(tch, tchFit, "MPE", xData, yData, error, yFit, Kd_touch(:, pp), Protein{pp, "Name"});
            end
            yDataTch_g(pp, :) = yFit(1, :);
            yDataTch_b(pp, :) = yFit(2, :);
        end
    end % End of RNA loop
end % End of protein loop

% Check if figure flag is enabled
if(figFlag)
    % Create figure windows
    pix_v_tch = figure(1000007);  % Figure for comparing pixel and touch data
    pValDelD = figure(1000012);   % Figure for plotting p-values and delta distances

    % Generate ddG values for SNA
    [ddG_SNA, valsPixG, valsTchG] = ddG(1000005, "SNA", Protein, Kd_pixels(1,:), squeeze(Kd_intervals_pixels(:,1,:)), Kd_touch(1,:), squeeze(Kd_intervals_touch(:,1,:)));
    pix_v_tch = ComparePixAndTch(pix_v_tch, Protein{:,"Name"}, valsPixG, valsTchG, 1);  % Compare pixel and touch data for SNA

    % Generate ddG values for RNA
    [ddG_RNA, valsPixB, valsTchB] = ddG(1000006, "RNA", Protein, Kd_pixels(2,:), Kd_intervals_pixels(:,2,:), Kd_touch(2,:), Kd_intervals_touch(:,2,:));
    pix_v_tch = ComparePixAndTch(pix_v_tch, Protein{:,"Name"}, valsPixB, valsTchB, 2);  % Compare pixel and touch data for RNA

    % Plot delta mean distances and p-values
    pValDelD = PlotDeltaMeanDistance(pValDelD, Protein, delMean, pValue, SDMean);

    % Plot heat maps for the data
    PlotHeatMaps({yDataPix_g, yDataPix_b, yDataTch_g, yDataTch_b}, {Kd_pixels(1,:), Kd_pixels(2,:), Kd_touch(1,:), Kd_touch(2,:)}, Lectin, Protein);

    % Create a new figure for box plots and swarm charts
    f = figure;
    subplot(2, 2, 1);
    lows_tdPCP_b(:,2) = 9;
    lows_tdPCP_m(:,2) = 10;
    temp = [lows_tdPCP_b(lows_tdPCP_b(:,1) ~= 0 & ~isnan(lows_tdPCP_b(:,1)), :); lows_tdPCP_m(lows_tdPCP_m(:,1) ~= 0 & ~isnan(lows_tdPCP_m(:,1)), :)];
    boxplot(temp(:,1), temp(:,2));
    [areMeansDifferentX, pValueX] = compareMeans(temp(temp(:,2) == 9, :), temp(temp(:,2) == 10, :));
    hold on;
    swarmchart(ones(size(temp(temp(:,2) == 9, 1), 1), 1), temp(temp(:,2) == 9, 1), '.k');
    swarmchart(2*ones(size(temp(temp(:,2) == 10, 1), 1), 1), temp(temp(:,2) == 10, 1), '.k');
    scatter([1, 2], [mean(temp(temp(:,2) == 9, 1)), mean(temp(temp(:,2) == 10, 1))], 50, 'r', 'filled');
    hold off;
    set(gca, 'yscale', 'log');
    set(gca, 'XTickLabels', ["Bacterial", "Mammalian"]);
    text(1, 50, strcat("p-value=", num2str(pValueX)));
    ylim([10^-3, 10^2]);
    title("tdPCP, Low SNA Conc.");

    % Repeat the above plotting process for different datasets
    subplot(2, 2, 2);
    highs_tdPCP_b(:,2) = 9;
    highs_tdPCP_m(:,2) = 10;
    temp = [highs_tdPCP_b(highs_tdPCP_b(:,1) ~= 0 & ~isnan(highs_tdPCP_b(:,1)), :); highs_tdPCP_m(highs_tdPCP_m(:,1) ~= 0 & ~isnan(highs_tdPCP_m(:,1)), :)];
    boxplot(temp(:,1), temp(:,2));
    [areMeansDifferentX, pValueX] = compareMeans(temp(temp(:,2) == 9, :), temp(temp(:,2) == 10, :));
    hold on;
    swarmchart(ones(size(temp(temp(:,2) == 9, 1), 1), 1), temp(temp(:,2) == 9, 1), '.k');
    swarmchart(2*ones(size(temp(temp(:,2) == 10, 1), 1), 1), temp(temp(:,2) == 10, 1), '.k');
    scatter([1, 2], [mean(temp(temp(:,2) == 9, 1)), mean(temp(temp(:,2) == 10, 1))], 50, 'r', 'filled');
    hold off;
    set(gca, 'yscale', 'log');
    set(gca, 'XTickLabels', ["Bacterial", "Mammalian"]);
    text(1, 50, strcat("p-value=", num2str(pValueX)));
    ylim([10^-3, 10^2]);
    title("tdPCP, High SNA Conc.");

    subplot(2, 2, 3);
    lows_NXST_b(:,2) = 5;
    lows_NXST_m(:,2) = 6;
    temp = [lows_NXST_b(lows_NXST_b(:,1) ~= 0 & ~isnan(lows_NXST_b(:,1)), :); lows_NXST_m(lows_NXST_m(:,1) ~= 0 & ~isnan(lows_NXST_m(:,1)), :)];
    boxplot(temp(:,1), temp(:,2));
    [areMeansDifferentX, pValueX] = compareMeans(temp(temp(:,2) == 5, :), temp(temp(:,2) == 6, :));
    hold on;
    swarmchart(ones(size(temp(temp(:,2) == 5, 1), 1), 1), temp(temp(:,2) == 5, 1), '.k');
    swarmchart(2*ones(size(temp(temp(:,2) == 6, 1), 1), 1), temp(temp(:,2) == 6, 1), '.k');
    scatter([1, 2], [mean(temp(temp(:,2) == 5, 1)), mean(temp(temp(:,2) == 6, 1))], 50, 'r', 'filled');
    hold off;
    set(gca, 'yscale', 'log');
    set(gca, 'XTickLabels', ["Bacterial", "Mammalian"]);
    text(1, 50, strcat("p-value=", num2str(pValueX)));
    ylim([10^-3, 10^2]);
    title("NXST-V1x2, Low SNA Conc.");

    subplot(2, 2, 4);
    highs_NXST_b(:,2) = 5;
    highs_NXST_m(:,2) = 6;
    temp = [highs_NXST_b(highs_NXST_b(:,1) ~= 0 & ~isnan(highs_NXST_b(:,1)), :); highs_NXST_m(highs_NXST_m(:,1) ~= 0 & ~isnan(highs_NXST_m(:,1)), :)];
    boxplot(temp(:,1), temp(:,2));
    [areMeansDifferentX, pValueX] = compareMeans(temp(temp(:,2) == 5, :), temp(temp(:,2) == 6, :));
    hold on;
    swarmchart(ones(size(temp(temp(:,2) == 5, 1), 1), 1), temp(temp(:,2) == 5, 1), '.k');
    swarmchart(2*ones(size(temp(temp(:,2) == 6, 1), 1), 1), temp(temp(:,2) == 6, 1), '.k');
    scatter([1, 2], [mean(temp(temp(:,2) == 5, 1)), mean(temp(temp(:,2) == 6, 1))], 50, 'r', 'filled');
    hold off;
    set(gca, 'yscale', 'log');
    set(gca, 'XTickLabels', ["Bacterial", "Mammalian"]);
    text(1, 50, strcat("p-value=", num2str(pValueX)));
    ylim([10^-3, 10^2]);
    title("NXST-V1x2, High SNA Conc.");
end % if figFlag

% Compile data into a final table
final = table(Protein{:,"Name"}, Protein{:,"PossibleSialylatedSites"}, delMean, pValue, valsPixG', valsPixB', valsTchG', valsTchB', 'VariableNames', ["Name", "PSS", "DeltaDistance", "pValueDeltaDistance", "ddGSNAPix", "ddGRNAPix", "ddGSNATch", "ddGRNATch"]);

% Calculate combined score and generate figure
[score, fig_score] = CombinedScore(final);

% Save figures in different formats
for ff = 1000001:1000016
    temp = figure(ff);
    saveas(temp, strcat("Plots and Figures\Figure-", num2str(ff), ".pdf"));
    saveas(temp, strcat("Plots and Figures\Figure-", num2str(ff), ".jpg"));
    saveas(temp, strcat("Plots and Figures\Figure-", num2str(ff), ".fig"));
end % for ff