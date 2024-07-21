function [averagedCorrelation, sem] = calculateAveragedPearsonCorrelation(data)
    % Check if input matrix has at least 10 rows
    if size(data, 1) < 10
        error('Input matrix must have at least 10 rows.');
    end

    % Initialize variables
    numPairs = 10;
    numCombinations = factorial(numPairs) / (factorial(8) * factorial(numPairs - 8));
    correlationCoefficients = zeros(numCombinations, 1);

    % Generate all combinations of 8 out of 10 pairs
    combinations = nchoosek(1:numPairs, 8);

    % Loop through each combination
    for i = 1:numCombinations
        % Get the indices of the current combination
        indices = combinations(i, :);

        % Check for repeated combinations in a different order
        if ~any(all(ismember(nchoosek(indices, 8), combinations(1:i-1, :)), 2))
            % Extract the corresponding data
            selectedData = data(indices, :);

            % Calculate the Pearson correlation coefficient
            correlationCoefficients(i) = corr(selectedData(:, 1), selectedData(:, 2));
        else
            % If repeated combination in a different order, set the coefficient to NaN
            correlationCoefficients(i) = NaN;
        end
    end

    % Remove NaN values and calculate the mean and standard error of the mean
    validCoefficients = correlationCoefficients(~isnan(correlationCoefficients));
    averagedCorrelation = mean(validCoefficients);
    sem = std(validCoefficients) / sqrt(length(validCoefficients));
end
