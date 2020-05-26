% This script:
% 1) Imports the original and replicated P@10, AP, nDCG scores
% 2) Computes Effect Ratio (ER), and Delta Relative Improvement (DRI)
% 3) Plot a figure with ER values on the the x-axis and DRI on the y-axis

close all;
clear all;

% Parameters
% Names of the runs, wcrobust04 is the baseline and wcrobust0405 is the
% advanced run
original_run_baseline = 'wcrobust04';
original_run_baseline_name = 'WCrobust04';
original_run_advanced = 'wcrobust0405';
original_run_advanced_name = 'WCrobust0405';
% Measures names, i.e. the measures to be used to compute the Effect Ratio
measures = {'p10' 'ap' 'ndcg1000'};

% Path to the folder which contains the results
inputh_path = './results/measures/';

% Run names mapping
run_numbers_print = [45, 46, 47, 48, 49; ...
    14, 15, 16, 17, 18; ...
    39, 38, 37, 36, 35; ...
    44, 43, 42, 41, 40];

new_run_names = {{'rpl_tf_1' 'rpl_tf_2' 'rpl_tf_3' 'rpl_tf_4' 'rpl_tf_5'} ...
    {'rpl_df_1' 'rpl_df_2' 'rpl_df_3' 'rpl_df_4' 'rpl_df_5'} ...
    {'rpl_tol_1' 'rpl_tol_2' 'rpl_tol_3' 'rpl_tol_4' 'rpl_tol_5'} ...
    {'rpl_C_1' 'rpl_C_2' 'rpl_C_3' 'rpl_C_4' 'rpl_C_5'}};

% Set colors
p10_color = [0 0.4470 0.7410];
ap_color = [0.4660 0.6740 0.1880];
ndcg1000_color = [0.6350 0.0780 0.1840];

grey_color = [96 96 96] / 255;

% Font size for legend and labels
legend_font_size = 22;
xtick_fontsize = 20;

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

% Number of figures and number of runs that we need to generate
[num_figures, num_runs] = size(run_numbers_print);

% effect_ratio_p10 = effect_ratio_replicability(results_a_p10, results_b_p10);
% effect_ratio_ap = effect_ratio_replicability(results_a_ap, results_b_ap);
% effect_ratio_ndcg1000 = effect_ratio_replicability(results_a_ndcg1000, results_b_ndcg1000);

% Generates the plots
for i = 1:num_figures

    % Initialize a vector to store ER and DRI scores
    er_scores_p10 = NaN(1, num_runs);
    dri_scores_p10 = NaN(1, num_runs);
    er_scores_ap = NaN(1, num_runs);
    dri_scores_ap = NaN(1, num_runs);
    er_scores_ndcg1000 = NaN(1, num_runs);
    dri_scores_ndcg1000 = NaN(1, num_runs);
    
    for j = 1:num_runs
        
        % Get the scores for the originals runs
        original_a_p10 = results_a_p10{:, original_run_advanced_name};
        original_a_ap = results_a_ap{:, original_run_advanced_name};
        original_a_ndcg1000 = results_a_ndcg1000{:, original_run_advanced_name};
        
        original_b_p10 = results_b_p10{:, original_run_baseline_name};
        original_b_ap = results_b_ap{:, original_run_baseline_name};
        original_b_ndcg1000 = results_b_ndcg1000{:, original_run_baseline_name};
        
        % Get the complete run name
        a_run_name = sprintf('rpl_%s_%i', original_run_advanced, run_numbers_print(i, j));
        b_run_name = sprintf('rpl_%s_%i', original_run_baseline, run_numbers_print(i, j));
        
        % Get the scores for the advanced and baselines replicated runs
        replicated_a_p10 = results_a_p10{:, a_run_name};
        replicated_a_ap = results_a_ap{:, a_run_name};
        replicated_a_ndcg1000 = results_a_ndcg1000{:, a_run_name};
        
        replicated_b_p10 = results_b_p10{:, b_run_name};
        replicated_b_ap = results_b_ap{:, b_run_name};
        replicated_b_ndcg1000 = results_b_ndcg1000{:, b_run_name};
        
        % Compute ER
        er_scores_p10(j) = mean(replicated_a_p10 - replicated_b_p10, 1) / mean(original_a_p10 - original_b_p10, 1);
        er_scores_ap(j) = mean(replicated_a_ap - replicated_b_ap, 1) / mean(original_a_ap - original_b_ap, 1);
        er_scores_ndcg1000(j) = mean(replicated_a_ndcg1000 - replicated_b_ndcg1000, 1) / mean(original_a_ndcg1000 - original_b_ndcg1000, 1);
        
        % Compute DRI
        dri_scores_p10(j) = (mean(original_a_p10, 1) - mean(original_b_p10, 1)) / mean(original_b_p10, 1) - (mean(replicated_a_p10, 1) - mean(replicated_b_p10, 1)) / mean(replicated_b_p10, 1);
        dri_scores_ap(j) = (mean(original_a_ap, 1) - mean(original_b_ap, 1)) / mean(original_b_ap, 1) - (mean(replicated_a_ap, 1) - mean(replicated_b_ap, 1)) / mean(replicated_b_ap, 1);
        dri_scores_ndcg1000(j) = (mean(original_a_ndcg1000, 1) - mean(original_b_ndcg1000, 1)) / mean(original_b_ndcg1000, 1) - (mean(replicated_a_ndcg1000, 1) - mean(replicated_b_ndcg1000, 1)) / mean(replicated_b_ndcg1000, 1);
    
    end
    
    figure(i)
    % Get the minimum and maximum values to plot axis
%     min_x = min([er_scores_p10, er_scores_ap, er_scores_ndcg1000]);
%     max_x = max([er_scores_p10, er_scores_ap, er_scores_ndcg1000]);
%     min_y = min([dri_scores_p10, dri_scores_ap, dri_scores_ndcg1000]);
%     max_y = min([dri_scores_p10, dri_scores_ap, dri_scores_ndcg1000]);
    
    hold on
    % for each run
    grid on
    l1 = plot(er_scores_p10, dri_scores_p10, 'x', 'LineWidth', 2,  'MarkerSize', 15, 'Color', p10_color);
    l2 = plot(er_scores_ap, dri_scores_ap, 'o', 'LineWidth', 2,  'MarkerSize', 15, 'Color', ap_color, 'MarkerFaceColor', ap_color);
    l3 = plot(er_scores_ndcg1000, dri_scores_ndcg1000, '^', 'LineWidth', 2,  'MarkerSize', 15, 'Color', ndcg1000_color, 'MarkerFaceColor', ndcg1000_color);
    hold off
    % Plot horizontal and vertical axis
    min_max_y = ylim;
    line([0 0], [min_max_y(1) min_max_y(2)], 'LineWidth', 2, 'Color', grey_color);
    %min_max_y = ylim;
    line([1 1], [min_max_y(1) min_max_y(2)], 'LineWidth', 2, 'Color', grey_color);
    min_max_x = xlim;
    line([min_max_x(1) min_max_x(2)], [0 0], 'LineWidth', 2, 'Color', grey_color);
    xlim([min_max_x(1) min_max_x(2)])
    ylim([min_max_y(1) min_max_y(2)])
    xlabel('Effect Ratio (ER)', 'FontSize', legend_font_size);
    set(gca, 'fontsize', xtick_fontsize);
    ylabel('Delta Relative Improvement (\DeltaRI)', 'FontSize', legend_font_size)
    legend([l1, l2, l3], {'P@10' 'AP' 'nDCG'}, 'FontSize', legend_font_size);
end