function plotExponentialDecayFit(xData, yData)
    % Input: xData and yData (may contain NaN values)

    % Remove NaN values from the data
    validIndices = ~isnan(yData);
    xDat = xData(validIndices);
    yDat = yData(validIndices);

    % Fit an exponential decay model
    model = fit(xDat, yDat, 'exp1');

    % Display the fit parameters
    disp(model);

    % Plot the original data and the fitted curve
    %figure;
    hold on
    scatter(1:numel(xData), yData,100,'x','MarkerEdgeColor','k', 'DisplayName', 'Mean');
    yFit=model.a.*exp(model.b.*xDat);
    ind=find(~isnan(yData));
    ind=ind(1);
    plot(ind:numel(xData),yFit,'LineWidth',2,'Color',[0.4660 0.6740 0.1880], 'DisplayName', 'Fit');
    hold off;

    % Add labels and legend
    %legend('show');
end