% This script computes the Effect Ratio for replicability runs

close all;
clear all;

% Parameters
% Names of the runs, wcrobust04 is the baseline and wcrobust0405 is the
% advanced run
original_run_baseline = 'wcrobust04';
original_run_advanced = 'wcrobust0405';
% Measures names, i.e. the measures to be used to compute the Effect Ratio
measures = {'p10' 'ap' 'ndcg1000'};

% Path to the folder which contains the results
inputh_path = './results/measures/';

% For each measure read the corresponding results
for m = measures
    
    % Baseline run
    % Path to the input file
    file_path_baseline = sprintf('%srpl_%s_%s.csv', inputh_path, original_run_baseline, m{:});
    % Create the table with the results
    % The first column represents the original run
    eval(sprintf('results_b_%s = readtable(file_path_baseline, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    
    % Advanced run
    % Path to the input file
    file_path_advanced = sprintf('%srpl_%s_%s.csv', inputh_path, original_run_advanced, m{:});
    % Create the table with the results
    % The first column represents the original run
    eval(sprintf('results_a_%s = readtable(file_path_advanced, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));

end

% For each measure compute the effect ratio
for m = measures
    
    % Compute the effect ratio
    eval(sprintf('er_%1$s = effect_ratio_replicability(results_a_%1$s, results_b_%1$s);', m{:}));

end


% Run names mapping
run_numbers_print = [45, 46, 47, 48, 49, ...
    14, 15, 16, 17, 18, ...
    39, 38, 37, 36, 35, ...
    44, 43, 42, 41, 40];

new_run_names = {'rpl_tf_1' 'rpl_tf_2' 'rpl_tf_3' 'rpl_tf_4' 'rpl_tf_5' ...
    'rpl_df_1' 'rpl_df_2' 'rpl_df_3' 'rpl_df_4' 'rpl_df_5' ...
    'rpl_tol_1' 'rpl_tol_2' 'rpl_tol_3' 'rpl_tol_4' 'rpl_tol_5' ...
    'rpl_C_1' 'rpl_C_2' 'rpl_C_3' 'rpl_C_4' 'rpl_C_5'};

% Print the results in a latex table
for r = 1:length(run_numbers_print)
    % Get the complete run name
    run_name = sprintf('rpl_%i', run_numbers_print(r));
    % Get the new name
    new_name = new_run_names{r};
    
    % Get the Effect ratio scores
    % Effect ratio are printd as 1 - ER to ease interpretability
    p10_er_run = er_p10{1, run_name};
    ap_er_run = er_ap{1, run_name};
    ndcg1000_er_run = er_ndcg1000{1, run_name};
    
    % Replace the underscore otherwise we will have latex errorrs
    % Print the result line
    fprintf('\\texttt{%s}\t& $%.4f$\t& $%.4f$\t& $%.4f$ \\\\\n', ...
        strrep(new_name, '_', '\_'), p10_er_run, ap_er_run, ndcg1000_er_run);
end
