function effect_ratio_tbl = effect_ratio_reproducibility(results_advanced_original, results_advanced_reproduced, results_baseline_original, results_baseline_reproduced)
    % Function to compute the effect ratio between an advanced and a
    % baseline run for the reproducibility case
    % - results_advanced_original table with one column, the original run 
    % and the rows are the topics, the elements are the measure scores 
    % (original advanced run)
    % - results_advanced_reproduced table where the columns are the runs 
    % and the rows are the topics, the elements are the measure scores 
    % (reproduced advanced runs)
    % - results_baseline_original table with one column, the original run 
    % and the rows are the topics, the elements are the measure scores 
    % (original baseline run)
    % - results_baseline_reproduced table where the columns are the runs 
    % and the rows are the topics, the elements are the measure scores 
    % (reproduced baseline runs)
    
    % effect_ratio_tbl table which contains the effect ratio score for each
    % pair of runs
    
    % Compute delta scores: the difference between the score of the advanced 
    % and the baseline run
    % Modify the run names, this is needed to get the same columns when
    % computing the differences
    run_names_advanced = strrep(erase(results_advanced_reproduced.Properties.VariableNames(1:end),'_wcrobust0405'), 'WCrobust0405', 'original');
    results_advanced_reproduced.Properties.VariableNames = run_names_advanced;
    run_names_baseline = strrep(erase(results_baseline_reproduced.Properties.VariableNames(1:end),'_wcrobust04'), 'WCrobust04', 'original');
    results_baseline_reproduced.Properties.VariableNames = run_names_baseline;
    % Get the topic ids
    reproduced_topic_id = results_advanced_reproduced.Properties.RowNames(:);
    % Get the delta scores
    reproduced_delta = results_advanced_reproduced{reproduced_topic_id, run_names_advanced} - results_baseline_reproduced{reproduced_topic_id, run_names_advanced};
    % Compute the average for each topic
    reproduced_mean_delta = mean(reproduced_delta, 1);
    
    % Get the delta scores for the original runs
    % Get the topic ids
    original_topic_id = results_advanced_original.Properties.RowNames(:);
    % Get the delta scores
    original_delta = results_advanced_original{original_topic_id, :} - results_baseline_original{original_topic_id, :};
    % Compute the average delta for each topic
    original_mean_delta = mean(original_delta, 1);
    
    % Compute the effect ratio, the mean improvement of the replicated runs
    % divided by the mean improvement of the original run
    effect_ratio = reproduced_mean_delta / original_mean_delta;
    % Save the results in a table
    effect_ratio_tbl = array2table(effect_ratio, 'VariableNames', run_names_advanced);
    
end