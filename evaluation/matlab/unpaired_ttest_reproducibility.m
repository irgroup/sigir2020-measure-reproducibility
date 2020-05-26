function p_value_results = unpaired_ttest_reproducibility(measure_results_original, measure_results_reproduced)
    % Function to compute a paired t-test between the original run score 
    % and the replicated runs
    % - measure_results matrix where the columns are the runs and the rows
    % are the topics, the first column represent the original run
    % - p_value_results, vector where each element represents the p_value
    % between the replicated and the original run
    
    % Generate a matrix with the first colum, i.e. the original run scores
    % repmat(measure_results(:, 1), [1, size(measure_results, 2) - 1]) 
    % create a matrix with the first column, i.e. the original scores
    
    % Compute the paired ttest and returns the p_values
    % Remove row names
    % measure_results_original.Properties.RowNames = {};
    % measure_results_reproduced.Properties.RowNames = {};
    [~, p_value] = ttest2(repmat(measure_results_original{:, :}, [1, size(measure_results_reproduced, 2)]), measure_results_reproduced{:, :});
    
    p_value_results = array2table(p_value, 'VariableNames', measure_results_reproduced.Properties.VariableNames);

end