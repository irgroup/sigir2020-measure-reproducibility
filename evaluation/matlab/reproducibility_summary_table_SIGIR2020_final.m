% This script computes the Effect Ratio for reproducibility runs
% 1) Import the results from each evaluation measures
% 2) Computes ER and unpaired ttest
% 3) Print the results as a latex table

% Note, you should first run reproducibility_eval_SIGIR2020 to compute the
% measure score for each run

close all;
clear all;

% Parameters
% Names of the runs, wcrobust04 is the baseline and wcrobust0405 is the
% advanced run
original_run_baseline = 'wcrobust04';
original_run_advanced = 'wcrobust0405';
% Measures names, i.e. the measures to be used to compute the Effect Ratio
measures = {'p10' 'ap' 'ndcg1000'};
% Decide wheter we want the effect ratio or its normalized version
normalized = false;

% Path to the folder which contains the results
inputh_path = './results/measures_rpd/';

% For each measure read the corresponding results
for m = measures
    
    % Baseline run
    % Path to the input file
    file_path_original_baseline = sprintf('%sorg_%s_%s.csv', inputh_path, original_run_baseline, m{:});
    file_path_reproduced_baseline = sprintf('%srpd_%s_%s.csv', inputh_path, original_run_baseline, m{:});
    % Create the tables with the results
    % There is one table for the original run and one table for the
    % reproduced runs
    eval(sprintf('results_b_original_%s = readtable(file_path_original_baseline, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    eval(sprintf('results_b_reproduced_%s = readtable(file_path_reproduced_baseline, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));

    % Advanced run
    % Path to the input file
    file_path_original_advanced = sprintf('%sorg_%s_%s.csv', inputh_path, original_run_advanced, m{:});
    file_path_reproduced_advanced = sprintf('%srpd_%s_%s.csv', inputh_path, original_run_advanced, m{:});

    % Create two tables with the results
    % There is one table for the original run and one table for the
    % reproduced runs
    eval(sprintf('results_a_original_%s = readtable(file_path_original_advanced, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    eval(sprintf('results_a_reproduced_%s = readtable(file_path_reproduced_advanced, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    
end

% For each measure compute the effect ratio
for m = measures
    
    % Compute the effect ratio
    eval(sprintf('er_%1$s = effect_ratio_reproducibility(results_a_original_%1$s, results_a_reproduced_%1$s, results_b_original_%1$s, results_b_reproduced_%1$s);', m{:}));

end

% Run names mapping
run_numbers_print = [45, 46, 47, 48, 49, ...
    14, 15, 16, 17, 18, ...
    39, 38, 37, 36, 35, ...
    44, 43, 42, 41, 40];

new_run_names = {'rpd_tf_1' 'rpd_tf_2' 'rpd_tf_3' 'rpd_tf_4' 'rpd_tf_5' ...
    'rpd_df_1' 'rpd_df_2' 'rpd_df_3' 'rpd_df_4' 'rpd_df_5' ...
    'rpd_tol_1' 'rpd_tol_2' 'rpd_tol_3' 'rpd_tol_4' 'rpd_tol_5' ...
    'rpd_C_1' 'rpd_C_2' 'rpd_C_3' 'rpd_C_4' 'rpd_C_5'};

% Print the results in a latex table
for r = 1:length(run_numbers_print)
    
    % Get the complete run name
    run_name = sprintf('rpd_%i', run_numbers_print(r));
    % Get the new name
    new_name = new_run_names{r};

    % Get the Effect ratio scores
    p10_er_run = er_p10{1, run_name};
    ap_er_run = er_ap{1, run_name};
    ndcg1000_er_run = er_ndcg1000{1, run_name};
    
    % Replace the undescore otherwise we will get a latex errorr
    % run_name = strrep(r{:}, '_', '\_');

    % Print the result line
    fprintf('\\texttt{%s}\t& $%.4f$\t& $%.4f$\t& $%.4f$ \\\\\n', ...
        strrep(new_name, '_', '\_'), p10_er_run, ap_er_run, ndcg1000_er_run);
end
