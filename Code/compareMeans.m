function [areMeansDifferent,pValue] = compareMeans(array1, array2)
    % Input: array1 and array2 are two 2D arrays with distances in column 1
    % and categories in column 2 (not used in the code).

    % Extract distances from the input arrays
    distances1 = array1(:, 1);
    distances2 = array2(:, 1);

    % Perform a two-sample t-test
    [~, pValue, ~, stats] = ttest2(distances1, distances2);

    % Set a significance level (e.g., 0.05)
    alpha = 0.05;

    % Check if the p-value is less than the significance level
    areMeansDifferent = pValue < alpha;

    % Display the results
    disp(['p-value: ', num2str(pValue)]);
    disp(['t-statistic: ', num2str(stats.tstat)]);
    disp(['Degrees of freedom: ', num2str(stats.df)]);
    disp(['Means are statistically different: ', num2str(areMeansDifferent)]);
end