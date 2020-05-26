function effect_ratio_tbl = effect_ratio_replicability(results_advanced, results_baseline)
    % Function to compute the effect ratio between an advanced and a
    % baseline run
    % - results_advanced matrix where the columns are the runs and the rows
    % are the topics, the first column represent the original run, the
    % element are the measure scores (replicated advanced runs)
    % - results_baseline matrix where the columns are the runs and the rows
    % are the topics, the first column represent the original run, the
    % element are the measure scores (replicated baseline runs)
    
    % effect_ratio_tbl table which contains the effect ratio score for each
    % pair of runs
    
    % Compute delta scores: the difference between the score of the advanced 
    % and the baseline run
    % Modify the run names, this is needed to get the same columns when
    % computing the differences
    run_names_advanced = strrep(erase(results_advanced.Properties.VariableNames(1:end),'_wcrobust0405'), 'WCrobust0405', 'original');
    results_advanced.Properties.VariableNames = run_names_advanced;
    run_names_baseline = strrep(erase(results_baseline.Properties.VariableNames(1:end),'_wcrobust04'), 'WCrobust04', 'original');
    results_baseline.Properties.VariableNames = run_names_baseline;
    % Get the topic ids
    topic_id = results_advanced.Properties.RowNames(:);
    % Get the delta scores
    delta = results_advanced{topic_id, run_names_advanced} - results_baseline{topic_id, run_names_advanced};
    % Compute the average for each topic
    mean_delta = mean(delta, 1);
    % Compute the effect ratio, the mean improvement of the replicated runs
    % divided by the mean improvement of the original run
    effect_ratio = mean_delta(2:end) / mean_delta(1);
    % Save the results in a table
    effect_ratio_tbl = array2table(effect_ratio, 'VariableNames', run_names_advanced(2:end));
    
end