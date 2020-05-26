% This script:
% 1) Imports the original and replicated scores and kendall's tau values
% 2) Computes RMSE, average kendall's tau, average RBO, and p-values
% 3) Print the results as a latex table

close all;
clear all;

% Parameters
% It can be wcrobust04 or wcrobust0405
original_run_name = 'wcrobust0405';
% Measures names, i.e. the measures to be used to compute RMSE
measures = {'p10' 'ap' 'ndcg1000'};

% Path to the folder which contains the results
inputh_path = './results/measures/';

% For each measure read the corresponding results
for m = measures
    
    % Path to the input file
    file_path = sprintf('%srpl_%s_%s.csv', inputh_path, original_run_name, m{:});
    % Create the table with the results
    % The first column represents the input run
    eval(sprintf('results_%s = readtable(file_path, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));

end

% Compute RMSE between the original and replicated runs
for m = measures
    % For each measure compute the RMSE score and save them in a table 
    % rmse_<measure_name>
    eval(sprintf('rmse_%1$s = array2table(rmse_replicability(results_%1$s{:, :}), ''VariableNames'', results_%1$s.Properties.VariableNames(2:end));', m{:}));

end

% Read the kendall's tau results
% Correlation measures
corr_measures = {'kendalls_tau_1000', 'rbo_1000_p08'};

% Import the correlation values
for m = corr_measures
    
    % Path to the input file
    file_path = sprintf('%srpl_%s_%s.csv', inputh_path, original_run_name, m{:});
    % Create the table with the results
    % The first column represents the input run
    eval(sprintf('results_%s = readtable(file_path, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    
end

% Compute p-value between the original and replicated runs
% We use a paired t-test
for m = measures
    % For each measure compute the p_value and save them in a table 
    % p_value_<measure_name>
    eval(sprintf('p_value_%1$s = array2table(paired_ttest_replicability(results_%1$s{:, :}), ''VariableNames'', results_%1$s.Properties.VariableNames(2:end));', m{:}));

end

% Sort the run names alphabetically to print them in the result table
% Get the list of run names
% run_names = results_ap.Properties.VariableNames(2:end);
% % Remove the originalrun name
% new_run_names = erase(run_names, sprintf('rpl_%s_', original_run_name));
% % Convert the names to int
% int_run_names = cellfun(@str2num, new_run_names);
% % Sort the run names and get the sorted indexes
% [~, idx] = sort(int_run_names);
% % Sort the run names alphabetically
% run_names = run_names(idx);

% Get the mean score for the original run
capitalized_original_run_name = strrep(original_run_name, 'wc', 'WC');
mean_p10 = mean(results_p10{:, capitalized_original_run_name}, 1);
mean_ap = mean(results_ap{:, capitalized_original_run_name}, 1);
mean_ndcg1000 = mean(results_ndcg1000{:, capitalized_original_run_name}, 1);

% Print the original run line
fprintf('\\texttt{%s}\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $1$\t& $1$\t& $0$\t& $0$\t& $0$\t& $1$\t& $1$\t& $1$ \\\\\n', ...
    capitalized_original_run_name, ...
    mean_p10, mean_ap, mean_ndcg1000);
fprintf('\\midrule\n');

% Run names mapping
run_numbers_print = [45, 46, 47, 48, 49, ...
    14, 15, 16, 17, 18, ...
    39, 38, 37, 36, 35, ...
    44, 43, 42, 41, 40];

if strcmp(original_run_name, 'wcrobust04')

    new_run_names = {'rpl_wcr04_tf_1' 'rpl_wcr04_tf_2' 'rpl_wcr04_tf_3' 'rpl_wcr04_tf_4' 'rpl_wcr04_tf_5' ...
        'rpl_wcr04_df_1' 'rpl_wcr04_df_2' 'rpl_wcr04_df_3' 'rpl_wcr04_df_4' 'rpl_wcr04_df_5' ...
        'rpl_wcr04_tol_1' 'rpl_wcr04_tol_2' 'rpl_wcr04_tol_3' 'rpl_wcr04_tol_4' 'rpl_wcr04_tol_5' ...
        'rpl_wcr04_C_1' 'rpl_wcr04_C_2' 'rpl_wcr04_C_3' 'rpl_wcr04_C_4' 'rpl_wcr04_C_5'};

elseif strcmp(original_run_name, 'wcrobust0405')

    new_run_names = {'rpl_wcr0405_tf_1' 'rpl_wcr0405_tf_2' 'rpl_wcr0405_tf_3' 'rpl_wcr0405_tf_4' 'rpl_wcr0405_tf_5' ...
        'rpl_wcr0405_df_1' 'rpl_wcr0405_df_2' 'rpl_wcr0405_df_3' 'rpl_wcr0405_df_4' 'rpl_wcr0405_df_5' ...
        'rpl_wcr0405_tol_1' 'rpl_wcr0405_tol_2' 'rpl_wcr0405_tol_3' 'rpl_wcr0405_tol_4' 'rpl_wcr0405_tol_5' ...
        'rpl_wcr0405_C_1' 'rpl_wcr0405_C_2' 'rpl_wcr0405_C_3' 'rpl_wcr0405_C_4' 'rpl_wcr0405_C_5'};
    
end

% Print the results in a latex table
for r = 1:length(run_numbers_print)
    % Get the complete run name
    run_name = sprintf('rpl_%s_%i', original_run_name, run_numbers_print(r));
    % Get the new name
    new_name = new_run_names{r};
    
    % Get average scores
    mean_p10 = mean(results_p10{:, run_name}, 1);
    mean_ap = mean(results_ap{:, run_name}, 1);
    mean_ndcg1000 = mean(results_ndcg1000{:, run_name}, 1);
    
    % Get correlation scores
    mean_tau_1000 = mean(results_kendalls_tau_1000{:, run_name});
    mean_rbo_1000 = mean(results_rbo_1000_p08{:, run_name});
    
    % Get the RMSE scores
    p10_rmse_run = rmse_p10{1, run_name};
    ap_rmse_run = rmse_ap{1, run_name};
    ndcg1000_rmse_run = rmse_ndcg1000{1, run_name};
    
    % Get p-values
    p10_pvalue_run = p_value_p10{1, run_name};
    ap_pvalue_run = p_value_ap{1, run_name};
    ndcg1000_pvalue_run = p_value_ndcg1000{1, run_name};
    
    % Print the result line
    fprintf('\\texttt{%s}\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4f$\t& $%.4E$\t& $%.4E$\t& $%.4E$ \\\\\n', ...
        strrep(new_name, '_', '\_'), ...
        mean_p10, mean_ap, mean_ndcg1000, ...
        mean_tau_1000, mean_rbo_1000, ...
        p10_rmse_run, ap_rmse_run, ndcg1000_rmse_run, ...
        p10_pvalue_run, ap_pvalue_run, ndcg1000_pvalue_run);
end