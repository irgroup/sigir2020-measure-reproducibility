% This script computes the Effect Ratio for reproducibility runs
% 1) Import the results from each evaluation measures
% 2) Computes unpaired ttest
% 3) Print the results as a latex table

% Note, you should first run reproducibility_eval_SIGIR2020 to compute the
% measure score for each run

close all;
clear all;

% Parameters
% It can be wcrobust04 or wcrobust0405
original_run_names = {'wcrobust04' 'wcrobust0405'};
% Measures names, i.e. the measures to be used to compute the Effect Ratio
measures = {'p10' 'ap' 'ndcg1000'};

% Path to the folder which contains the results
inputh_path = './results/measures_rpd/';
% Path to the original replicated runs
original_inputh_path = './results/measures/';

% For each run
for o_r_n = original_run_names

    % For each measure read the corresponding results
    for m = measures

        % Baseline run
        % Path to the input file
        file_path_original_run = sprintf('%srpl_%s_%s.csv', original_inputh_path, o_r_n{:}, m{:});
        file_path_reproduced_run = sprintf('%srpd_%s_%s.csv', inputh_path, o_r_n{:}, m{:});
        % Create the tables with the results
        % There is one table for the original run and one table for the
        % reproduced runs
        eval(sprintf('results_original_%s_%s = readtable(file_path_original_run, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', o_r_n{:}, m{:}));
        eval(sprintf('results_reproduced_%s_%s = readtable(file_path_reproduced_run, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', o_r_n{:}, m{:}));
    end

    % For each measure compute the effect ratio
%     for m = measures
% 
%         % Compute the effect ratio
%         eval(sprintf('pvalue_%1$s_%2$s = unpaired_ttest_reproducibility(results_original_%1$s_%2$s, results_reproduced_%1$s_%2$s);', o_r_n{:}, m{:}));
% 
%     end
end


% % Write the results as a latex table
% % First get the run names to sort them alphabetically
% run_names = pvalue_ap.Properties.VariableNames;
% % Remove the originalrun name
% new_run_names = erase(run_names, sprintf('rpd_%s_', original_run_name));
% % Convert the names to int
% int_run_names = cellfun(@str2num, new_run_names);
% % Sort the run names and get the sorted indexes
% [~, idx] = sort(int_run_names);
% % Sort the run names alphabetically
% run_names = run_names(idx);

% Compute p-values
% Define the run names
run_numbers_print = 1:50;

run_rpl_name04 = cell(1, length(run_numbers_print));
run_rpd_name04 = cell(1, length(run_numbers_print));

% Get the complete run name wcrobust0405
run_rpl_name0405 = cell(1, length(run_numbers_print));
run_rpd_name0405 = cell(1, length(run_numbers_print));
   
for r = 1:length(run_numbers_print)

    % Get the complete run name wcrobust04
    run_rpl_name04{1, r} = sprintf('rpl_wcrobust04_%i', run_numbers_print(r));
    run_rpd_name04{1, r} = sprintf('rpd_wcrobust04_%i', run_numbers_print(r));

    % Get the complete run name wcrobust0405
    run_rpl_name0405{1, r} = sprintf('rpl_wcrobust0405_%i', run_numbers_print(r));
    run_rpd_name0405{1, r} = sprintf('rpd_wcrobust0405_%i', run_numbers_print(r));

end

% Compute p_values
for m = measures

    % Compute t-test
    eval(sprintf('[~, p_value] = ttest2(results_original_wcrobust04_%1$s{:, run_rpl_name04}, results_reproduced_wcrobust04_%1$s{:, run_rpd_name04});', m{:}));
    % Store p-values in a matlab table
    eval(sprintf('pvalue_wcrobust04_%1$s = array2table(p_value, ''VariableNames'', run_rpd_name04);', m{:}));
    
    clear p_value
    
    % Compute t-test
    eval(sprintf('[~, p_value] = ttest2(results_original_wcrobust0405_%1$s{:, run_rpl_name0405}, results_reproduced_wcrobust0405_%1$s{:, run_rpd_name0405});', m{:}));
    % Store p-values in a matlab table
    eval(sprintf('pvalue_wcrobust0405_%1$s = array2table(p_value, ''VariableNames'', run_rpd_name0405);', m{:}));
    
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

% Midrule lines position
midrule_line_pos = [5 10 15];

% Print the results in a latex table
for r = 1:length(run_numbers_print)
    
    % Get the complete run name
    run_name04 = sprintf('rpd_wcrobust04_%i', run_numbers_print(r));
    run_name0405 = sprintf('rpd_wcrobust0405_%i', run_numbers_print(r));
    % Get the new name
    new_name = new_run_names{r};
    
    % Get the retrieval scores
%     p10_wcrobust04_run = mean(results_reproduced_wcrobust04_p10{:, run_name04}, 1);
%     ap_wcrobust04_run = mean(results_reproduced_wcrobust04_ap{:, run_name04}, 1);
%     ndcg1000_wcrobust04_run = mean(results_reproduced_wcrobust04_ndcg1000{:, run_name04}, 1);
%     
%     p10_wcrobust0405_run = mean(results_reproduced_wcrobust0405_p10{:, run_name0405}, 1);
%     ap_wcrobust0405_run = mean(results_reproduced_wcrobust0405_ap{:, run_name0405}, 1);
%     ndcg1000_wcrobust0405_run = mean(results_reproduced_wcrobust0405_ndcg1000{:, run_name0405}, 1);
        
    % Get the p-values scores
    p10_pvalue_wcrobust04_run = pvalue_wcrobust04_p10{1, run_name04};
    ap_pvalue_wcrobust04_run = pvalue_wcrobust04_ap{1, run_name04};
    ndcg1000_pvalue_wcrobust04_run = pvalue_wcrobust04_ndcg1000{1, run_name04};
    
    p10_pvalue_wcrobust0405_run = pvalue_wcrobust0405_p10{1, run_name0405};
    ap_pvalue_wcrobust0405_run = pvalue_wcrobust0405_ap{1, run_name0405};
    ndcg1000_pvalue_wcrobust0405_run = pvalue_wcrobust0405_ndcg1000{1, run_name0405};
    
    % Replace the undescore otherwise we will get a latex errorr
    % run_name = strrep(r{:}, sprintf('_%s_', original_run_name), '\_');

    % Print the result line
    fprintf('\\texttt{%s}\t& $%.4E$\t& $%.4E$\t& $%.4E$\t& $%.4E$\t& $%.4E$\t& $%.4E$ \\\\\n', ...
        strrep(new_name, '_', '\_'), ...
        p10_pvalue_wcrobust04_run, ap_pvalue_wcrobust04_run, ndcg1000_pvalue_wcrobust04_run, ...
        p10_pvalue_wcrobust0405_run, ap_pvalue_wcrobust0405_run, ndcg1000_pvalue_wcrobust0405_run);
    
    % Check if we need to print a midrule line
    if ismember(r, midrule_line_pos)
        fprintf('\\midrule\n')
    end   
end
