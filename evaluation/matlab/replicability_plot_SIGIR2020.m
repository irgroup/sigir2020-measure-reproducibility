% This script:
% 1) Imports the original and replicated nDCG and RBO scores
% 2) Computes RMSE, and average RBO
% 3) Plot a figure with the cut-off values on the the x-axis and measures
% scores on the y-axis

close all;
clear all;

% Parameters
% It can be wcrobust04 or wcrobust0405
original_run_name = 'wcrobust04';
% Measures names, i.e. the measures to be used to compute RMSE
measures = {'ndcg5' 'ndcg10' 'ndcg20' 'ndcg50' 'ndcg100' 'ndcg1000'};
% measures = {'p5' 'p10' 'p20' 'p50' 'p100' 'p1000'};
% Runs to use for the plot
% Run names mapping
run_numbers_print = [45, 46, 47, 48, 49; ...
    14, 15, 16, 17, 18; ...
    39, 38, 37, 36, 35; ...
    44, 43, 42, 41, 40];

if strcmp(original_run_name, 'wcrobust04')

    new_run_names = {{'rpl_wcr04_tf_1' 'rpl_wcr04_tf_2' 'rpl_wcr04_tf_3' 'rpl_wcr04_tf_4' 'rpl_wcr04_tf_5'} ...
        {'rpl_wcr04_df_1' 'rpl_wcr04_df_2' 'rpl_wcr04_df_3' 'rpl_wcr04_df_4' 'rpl_wcr04_df_5'} ...
        {'rpl_wcr04_tol_1' 'rpl_wcr04_tol_2' 'rpl_wcr04_tol_3' 'rpl_wcr04_tol_4' 'rpl_wcr04_tol_5'} ...
        {'rpl_wcr04_C_1' 'rpl_wcr04_C_2' 'rpl_wcr04_C_3' 'rpl_wcr04_C_4' 'rpl_wcr04_C_5'}};

elseif strcmp(original_run_name, 'wcrobust0405')

    new_run_names = {{'rpl_wcr0405_tf_1' 'rpl_wcr0405_tf_2' 'rpl_wcr0405_tf_3' 'rpl_wcr0405_tf_4' 'rpl_wcr0405_tf_5'} ...
        {'rpl_wcr0405_df_1' 'rpl_wcr0405_df_2' 'rpl_wcr0405_df_3' 'rpl_wcr0405_df_4' 'rpl_wcr0405_df_5'} ...
        {'rpl_wcr0405_tol_1' 'rpl_wcr0405_tol_2' 'rpl_wcr0405_tol_3' 'rpl_wcr0405_tol_4' 'rpl_wcr0405_tol_5'} ...
        {'rpl_wcr0405_C_1' 'rpl_wcr0405_C_2' 'rpl_wcr0405_C_3' 'rpl_wcr0405_C_4' 'rpl_wcr0405_C_5'}};
    
end

% Font size for legend and labels
legend_font_size = 22;
xtick_fontsize = 20;

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
corr_measures = {'rbo_5_p08' 'rbo_10_p08' 'rbo_20_p08' 'rbo_50_p08' 'rbo_100_p08' 'rbo_1000_p08' ...
    'kendalls_tau_5' 'kendalls_tau_10' 'kendalls_tau_20' 'kendalls_tau_50' 'kendalls_tau_100' 'kendalls_tau_1000'};


% Import the correlation values
for m = corr_measures
    
    % Path to the input file
    file_path = sprintf('%srpl_%s_%s.csv', inputh_path, original_run_name, m{:});
    % Create the table with the results
    % The first column represents the input run
    eval(sprintf('results_%s = readtable(file_path, ''Delimiter'', '','' , ''ReadVariableNames'', true, ''ReadRowNames'', true);', m{:}));
    
end

% Number of figures and number of runs that we need to generate
[num_figures, num_runs] = size(run_numbers_print);

% cut-off values
cut_off_values = [5 10 20 50 100 1000];

% Generates the plots
for i = 1:num_figures
        
    % Initialize a vector to store the scores for each cut-off
    rmse_scores = NaN(num_runs, length(cut_off_values));
    rbo_mean_scores = NaN(num_runs, length(cut_off_values));
    kendall_mean_scores = NaN(num_runs, length(cut_off_values));
    
    for j = 1:num_runs
        
        % Get the complete run name
        run_name = sprintf('rpl_%s_%i', original_run_name, run_numbers_print(i, j));
        
        % Get RMSE score
        rmse_scores(j, 1) = rmse_ndcg5{1, run_name};
        rmse_scores(j, 2) = rmse_ndcg10{1, run_name};
        rmse_scores(j, 3) = rmse_ndcg20{1, run_name};
        rmse_scores(j, 4) = rmse_ndcg50{1, run_name};
        rmse_scores(j, 5) = rmse_ndcg100{1, run_name};
        rmse_scores(j, 6) = rmse_ndcg1000{1, run_name};
        
%         rmse_scores(j, 1) = rmse_p5{1, run_name};
%         rmse_scores(j, 2) = rmse_p10{1, run_name};
%         rmse_scores(j, 3) = rmse_p20{1, run_name};
%         rmse_scores(j, 4) = rmse_p50{1, run_name};
%         rmse_scores(j, 5) = rmse_p100{1, run_name};
%         rmse_scores(j, 6) = rmse_p1000{1, run_name};
        
        % Get RBO mean scores
        rbo_mean_scores(j, 1) = mean(results_rbo_5_p08{:, run_name});
        rbo_mean_scores(j, 2) = mean(results_rbo_10_p08{:, run_name});
        rbo_mean_scores(j, 3) = mean(results_rbo_20_p08{:, run_name});
        rbo_mean_scores(j, 4) = mean(results_rbo_50_p08{:, run_name});
        rbo_mean_scores(j, 5) = mean(results_rbo_100_p08{:, run_name});
        rbo_mean_scores(j, 6) = mean(results_rbo_1000_p08{:, run_name});
        
        % Get Kendall's tau mean scores
        tau_mean_scores(j, 1) = mean(results_kendalls_tau_5{:, run_name});
        tau_mean_scores(j, 2) = mean(results_kendalls_tau_10{:, run_name});
        tau_mean_scores(j, 3) = mean(results_kendalls_tau_20{:, run_name});
        tau_mean_scores(j, 4) = mean(results_kendalls_tau_50{:, run_name});
        tau_mean_scores(j, 5) = mean(results_kendalls_tau_100{:, run_name});
        tau_mean_scores(j, 6) = mean(results_kendalls_tau_1000{:, run_name});

    end
    
    % RMSE Figure
    figure(i)
    hold on
    % for each run
    for k = 1:num_runs
        plot(1:length(cut_off_values), rmse_scores(k ,:), '-x', 'LineWidth', 2,  'MarkerSize', 10);
    end
    hold off
    xlabel('Cut-off values', 'FontSize', legend_font_size);
    xticks(1:length(cut_off_values))
    xticklabels({'5' '10' '20' '50' '100' '1000'});
    set(gca, 'fontsize', xtick_fontsize);
    ylabel('RMSE', 'FontSize', legend_font_size)
    legend(new_run_names{1, i}, 'Interpreter', 'none', 'Location', 'southeast', 'FontSize', legend_font_size)
    
    % RBO Figure
    figure(i + num_figures)
    hold on
    for k = 1:num_runs
        plot(1:length(cut_off_values), rbo_mean_scores(k ,:), '-x', 'LineWidth', 2, 'MarkerSize', 10);
    end
    hold off
    xlabel('Cut-off values', 'FontSize', legend_font_size);
    xticks(1:length(cut_off_values))
    xticklabels({'5' '10' '20' '50' '100' '1000'});
    set(gca, 'fontsize', xtick_fontsize);
    ylabel('RBO', 'FontSize', legend_font_size)
    legend(new_run_names{1, i}, 'Interpreter', 'none', 'Location', 'northeast', 'FontSize', legend_font_size)
    
    % Kendall's tau Figure
    figure(i + 2 * num_figures)
    hold on
    for k = 1:num_runs
        plot(1:length(cut_off_values), tau_mean_scores(k ,:), '-x', 'LineWidth', 2, 'MarkerSize', 10);
    end
    hold off
    xlabel('Cut-off values', 'FontSize', legend_font_size);
    xticks(1:length(cut_off_values))
    xticklabels({'5' '10' '20' '50' '100' '1000'});
    set(gca, 'fontsize', xtick_fontsize);
    ylabel('Kendall''s \tau', 'FontSize', legend_font_size)
    legend(new_run_names{1, i}, 'Interpreter', 'none', 'Location', 'northeast', 'FontSize', legend_font_size)
    
end