function rmse_results = rmse_replicability(measure_results)
    % Function to compute RMSE between the original run score and the
    % replicated runs
    % - measure_results matrix where the columns are the runs and the rows
    % are the topics, the first column represent the original run
    % - rmse_results, vector where each element represents the RMSE score
    % between the replicated and the original run
    
    % Subtract to each column the first column which corresponds to the
    % original score
    % repmat(measure_results(:, 1), [1, size(measure_results, 2) - 1]) 
    % create a matrix with the first column, i.e. the original scores
    
    % measure_results(:, 2:end) - repmat(measure_results(:, 1), [1, size(measure_results, 2) - 1])
    % Perform the subtraction column by column
    rmse_results = rms(measure_results(:, 2:end) - repmat(measure_results(:, 1), [1, size(measure_results, 2) - 1]), 1);

end