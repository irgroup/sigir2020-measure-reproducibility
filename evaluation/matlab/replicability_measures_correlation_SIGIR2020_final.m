% This script:
% 1) Imports the original and replicated scores and kendall's tau values
% 2) Computes RMSE, average kendall's tau, average RBO, and p-values
% 3) Compute the correlation among different measures

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

% Compute the absolute difference with repsect to the average score
for m = measures
    % For each measure compute the difference between the original average
    % score and the replicated average score
    % rmse_<measure_name>
    eval(sprintf('avg_%1$s = array2table(avg_replicability(results_%1$s{:, :}), ''VariableNames'', results_%1$s.Properties.VariableNames(2:end));', m{:}));

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
    % Compute the mean Kendall's tau or RBO
    eval(sprintf('results_avg_%1$s = array2table(abs(ones(1, size(results_%1$s, 2)) - mean(results_%1$s{:, :}, 1)), ''VariableNames'', results_%1$s.Properties.VariableNames);', m{:}));
    
end

% Compute p-value between the original and replicated runs
% We use a paired t-test
for m = measures
    % For each measure compute the p_value and save them in a table 
    % p_value_<measure_name>
    eval(sprintf('p_value_%1$s = array2table(paired_ttest_replicability(results_%1$s{:, :}), ''VariableNames'', results_%1$s.Properties.VariableNames(2:end));', m{:}));

end

% Get the run names
run_names = results_ap.Properties.VariableNames(2:end);

clearvars -except original_run_name run_names avg_p10 avg_ap avg_ndcg1000 results_avg_kendalls_tau_1000 results_avg_rbo_1000_p08 rmse_p10 rmse_ap rmse_ndcg1000 p_value_p10 p_value_ap p_value_ndcg1000

% Compute Effect Ratio
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
    
    % Compute abs(1 - ER), to use them with correlation analysis
    eval(sprintf('abs_er_%1$s = array2table(abs(ones(1, size(er_%1$s, 2)) - er_%1$s{1, :}), ''VariableNames'', er_%1$s.Properties.VariableNames);', m{:}));

end

% Convert the original names to effect ratio names
er_run_names = erase(run_names, sprintf('_%s', original_run_name));

% Compute the correlation among different measures
correlation = corr([avg_p10{1,run_names}' avg_ap{1,run_names}' avg_ndcg1000{1,run_names}' ...
    results_avg_kendalls_tau_1000{1,run_names}' results_avg_rbo_1000_p08{1,run_names}' ...
    rmse_p10{1,run_names}' rmse_ap{1,run_names}' rmse_ndcg1000{1,run_names}' ...
    -p_value_p10{1,run_names}' -p_value_ap{1,run_names}' -p_value_ndcg1000{1,run_names}' ...
    abs_er_p10{1,er_run_names}' abs_er_ap{1,er_run_names}' abs_er_ndcg1000{1,er_run_names}'], ...
    'Type', 'Kendall');

% Print correlation table
header = {'avg\_P@10' 'avg\_\ac{AP}' 'avg\_\ac{nDCG}' ...
    '$\tau$' '\ac{RBO}' ...
    '\ac{RMSE}\_P@10' '\ac{RMSE}\_\ac{AP}' '\ac{RMSE}\_\ac{nDCG}' ...
    'p\_value\_P@10' 'p\_value\_\ac{AP}' 'p\_value\_\ac{nDCG}' ...
    '\ac{ER}\_P@10' '\ac{ER}\_\ac{AP}' '\ac{ER}\_\ac{nDCG}'};

% Midrule lines position
midrule_line_pos = [3 5 8 11];


% Print the table header
header_string = join(header, '\t& ');
fprintf('%s \\\\\n', header_string{1, 1});
fprintf('\\midrule\n');

% Print the matrix content
[num_rows, num_columns] = size(correlation);
% for each row
for i = 1:num_rows
    % Print the header
    fprintf('%s', header{1, i});
    % Print the rest of the row
    if strcmp(original_run_name, 'wcrobust04')
        fprintf('\t& $%.4f$', correlation(i, :))
    elseif strcmp(original_run_name, 'wcrobust0405')
        fprintf('\t& \\cellcolor{pt}$%.4f$', correlation(i, :))
    end
    % Print the end of the row
    fprintf('\\\\\n')
    
    % Check if we need to print a midrule line
    if ismember(i, midrule_line_pos)
        fprintf('\\midrule\n')
    end   
end

