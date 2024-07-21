function [data, xData, yData, error, yFit, Kd, Kd_intervals] = CompileData(data, data_type, path_repeat, Lectin)
    % CompileData compiles and processes data for analysis of lectin binding.
    %
    % Inputs:
    %   data - Input data table (empty or already loaded).
    %   data_type - Type of data ('MPP' or 'MPE').
    %   path_repeat - Path to the repeated data.
    %   Lectin - Lectin data for concentration.
    %
    % Outputs:
    %   data - Compiled data table.
    %   xData - Unique lectin concentration values.
    %   yData - Processed y-values based on coloc types.
    %   error - Error values for yData.
    %   yFit - Fitted y-values based on models.
    %   Kd - Dissociation constant values for different colocation types.
    %   Kd_intervals - Confidence intervals for Kd values.

    % Define colocation types
    coloc_types = ["NoColoc"; "ColocGreen"; "ColocBlue"; "ColocAll"];

    % Load data if not provided
    if isempty(data)
        switch(data_type)
            case "MPP"
                temp = "Pixels Data";
            case "MPE"
                temp = "Touch Data";
        end % switch
        path = replace(path_repeat, "Image Data", temp);
        dir_content = dir(path);
        files = ~[dir_content.isdir];
        files = dir_content(files);
        for ll = 1:size(files, 1)
            fName = strcat(path, files(ll).name);
            opts = detectImportOptions(fName);
            opts = setvartype(opts, 'RepeatDate', 'string');
            data = [data; readtable(fName, opts)];
        end % for
    else
        temp = {};
        for ll = 1:size(data)
            temp = [temp; data{ll}];
        end % for
        data = temp;
    end % if
    
    % Select relevant columns based on data type
    switch(data_type)
        case "MPP"
            data = data(:, ["LectinConcentration", "N_Pixels", "NoColoc", "ColocGreen", "ColocBlue", "ColocAll"]);
        case "MPE"
            data = data(:, ["LectinConcentration", "ColocTypeBinary"]);
    end % switch

    % Sort data by lectin concentration
    data = sortrows(data, "LectinConcentration", "ascend");
    xData = unique(data{:,"LectinConcentration"}, 'stable') * 1.9 / 17.9;
    yData = zeros(numel(coloc_types), numel(xData));
    N = zeros(1, numel(xData));

    % Process yData based on data type
    switch(data_type)
        case "MPP"
            for ll = 1:size(Lectin, 1)
                yData(:, ll) = (mean(data{data{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, 3:end}))';
                N(1, ll) = sum(data{:,"LectinConcentration"} == Lectin{ll,"Concentration"});
            end % for
        case "MPE"
            for ll = 1:numel(xData)
                for tt = 1:numel(coloc_types)
                    yData(tt, ll) = sum(strcmp(char(data{data{:,"LectinConcentration"} == Lectin{ll,"Concentration"}, "ColocTypeBinary"}), coloc_types(tt)));
                end % for
                N(1, ll) = sum(yData(:, ll));
            end % for
            yData = yData ./ N;
    end % switch

    % Calculate error values
    error = (0.7655 ./ sqrt(yData .* N));

    % Initialize Kd, Kd_intervals, and yFit arrays
    Kd = zeros(3, 1); % Green, Blue, Purple
    Kd_intervals = zeros(3, 2); % Green, Blue, Purple
    yFit = zeros(3, size(yData, 2)); % Green, Blue, Purple

    % Fit models to data for each colocation type
    for tt = 1:numel(coloc_types)
        if ~(strcmp(coloc_types(tt), "NoColoc"))
            switch(coloc_types(tt))
                case "ColocGreen"
                    model = fittype('A.*(x./Kd)./(1+(x./Kd))+B', 'dependent', {'y'}, 'independent', {'x'}, 'coefficients', {'A', 'B', 'Kd'});
                    guess = [max(yData(tt, :)), 0, 0.05];
                case "ColocBlue"
                    model = fittype('A./(1+(x./Kd))+B', 'dependent', {'y'}, 'independent', {'x'}, 'coefficients', {'A', 'B', 'Kd'});
                    guess = [max(yData(tt, :)), max(yData(tt, :)), 0.05];
                case "ColocAll"
                    model = fittype('A.*(x./Kd)./(1+(x./Kd))+B', 'dependent', {'y'}, 'independent', {'x'}, 'coefficients', {'A', 'B', 'Kd'});
                    guess = [max(yData(tt, :)), 0, 0.05];
            end % switch
            fopts = fitoptions(model);
            lower = [0, 0, 0];
            upper = [1, 1, inf];
            fopts = fitoptions(fopts, 'StartPoint', guess, 'Lower', lower, 'Upper', upper);
            [fitRes, goodnessRes] = fit(xData, yData(tt, :)', model, fopts);
            intervals = confint(fitRes);
            switch(coloc_types(tt))
                case "ColocGreen"
                    yFit(1, :) = fitRes.A .* ((xData ./ fitRes.Kd)) ./ (1 + (xData ./ fitRes.Kd)) + fitRes.B;
                    Kd(1) = fitRes.Kd;
                    Kd_intervals(1, :) = intervals(:, 3);
                case "ColocBlue"
                    yFit(2, :) = fitRes.A ./ (1 + (xData ./ fitRes.Kd)) + fitRes.B;
                    Kd(2) = fitRes.Kd;
                    Kd_intervals(2, :) = intervals(:, 3);
                case "ColocAll"
                    yFit(3, :) = fitRes.A .* ((xData ./ fitRes.Kd)) ./ (1 + (xData ./ fitRes.Kd)) + fitRes.B;
                    Kd(3) = fitRes.Kd;
                    Kd_intervals(3, :) = intervals(:, 3);
            end % switch
        end % if
    end % for

end % function
