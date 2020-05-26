% This script:
% 1) Imports the original and replicated runs
% 2) Computes the evaluation measures for each run and kendall's tau
% 3) Saves the results in csv format

close all;
clear all;

% Path to the library
addpath('/Users/tjz514/Documents/software/matters/base/core/io/')
addpath('/Users/tjz514/Documents/software/matters/base/core/measure/')
addpath('/Users/tjz514/Documents/software/matters/base/core/util/')

% Parameters
% It can be wcrobust04 or wcrobust0405
original_run_name = 'wcrobust0405';

% Path to the original runs, replicated runs, and qrels
if strcmp(original_run_name, 'wcrobust04')
    % Path to the original run
    % We removed from this run the extra topics which are not assessed
    original_run_path = '../runs/original/WCrobust04_replicability.txt';
    % Path to the folder with the replicated runs
    replica_run_path = '../runs/replicability_rename/wcrobust04/';
    
elseif strcmp(original_run_name, 'wcrobust0405')
    % Path to the original run
    % We removed from this run the extra topics which are not assessed
    original_run_path = '../runs/original/WCrobust0405_replicability.txt';
    % Path to the folder with the replicated runs
    replica_run_path = '../runs/replicability_rename/wcrobust0405/';
end

% Path to the qrels
qrels_path = '../qrels/qrels_common_core_2017.txt';

% Import the qrels
pool = importPoolFromFileTRECFormat('FileName', qrels_path, 'Identifier', 'pool', 'Delimiter', 'space', 'RelevanceGrades', 0:2, 'RelevanceDegrees', {'NotRelevant', 'Relevant', 'HighlyRelevant'});

% Import the original run, we use the same order as trec_eval
original_run = importRunFromFileTRECFormat('FileName', original_run_path, 'Identifier', 'original_run', 'Delimiter', 'tab', 'DocumentOrdering', 'TrecEvalLexDesc');

% Import the replicated runs
% Recall that they should be .txt files
% The run id should be different for each run even inside the text file
replicated_runSet = importRunsFromDirectoryTRECFormat('Path', replica_run_path, 'Identifier', 'replicated_runSet', 'Delimiter', 'tab', 'DocumentOrdering', 'TrecEvalLexDesc');

%%%%%%%%%%%%%%%%%% Precision

% Compute precision at 10 for the original run
original_p10 = precision(pool, original_run, 'ShortNameSuffix', 'p_original_10', 'MapToBinaryRelevance', 'Lenient', 'CutOffs', 10);
% Compute average precision for the replicated runset
replicated_p10 = precision(pool, replicated_runSet, 'ShortNameSuffix', 'p_replicated_10', 'MapToBinaryRelevance', 'Lenient', 'CutOffs', 10);

%%%%%%%%%%%%%%%%%% Average Precision

% Compute average precision for the original run
original_ap = averagePrecision(pool, original_run, 'ShortNameSuffix', 'ap_original', 'MapToBinaryRelevance', 'Lenient');
% Compute MAP for the original run
% original_map = mean(original_ap{:, :});
% Compute average precision for the replicated runset
replicated_ap = averagePrecision(pool, replicated_runSet, 'ShortNameSuffix', 'ap_replicated', 'MapToBinaryRelevance', 'Lenient');
% Compute MAP for the replicated run_set
% replicated_map = mean(replicated_ap{:, :}, 1);

%%%%%%%%%%%%%%%%%% nDCG

% Compute nDCG for the original run
% This is nDCG as in trec_eval: the discount is done by log2(i + 1), not
% log2(i)
% The default relevance weights are [0 5 10]
original_ndcg5 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_5', 'Normalize', true, 'LogBase', 2, 'CutOffs', 5);
original_ndcg10 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_10', 'Normalize', true, 'LogBase', 2, 'CutOffs', 10);
original_ndcg20 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_20', 'Normalize', true, 'LogBase', 2, 'CutOffs', 20);
original_ndcg50 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_50', 'Normalize', true, 'LogBase', 2, 'CutOffs', 50);
original_ndcg100 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_100', 'Normalize', true, 'LogBase', 2, 'CutOffs', 100);
original_ndcg1000 = discountedCumulatedGainTR(pool, original_run, 'ShortNameSuffix', 'ndcg_original_1000', 'Normalize', true, 'LogBase', 2, 'CutOffs', 1000);
% Compute Mean nDCG for the original run
% original_mndcg = mean(original_ndcg{:, :});
% Compute nDCG for the replicated runset
replicated_ndcg5 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_5', 'LogBase', 2, 'Normalize', true, 'CutOffs', 5);
replicated_ndcg10 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_10', 'LogBase', 2, 'Normalize', true, 'CutOffs', 10);
replicated_ndcg20 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_20', 'LogBase', 2, 'Normalize', true, 'CutOffs', 20);
replicated_ndcg50 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_50', 'LogBase', 2, 'Normalize', true, 'CutOffs', 50);
replicated_ndcg100 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_100', 'LogBase', 2, 'Normalize', true, 'CutOffs', 100);
replicated_ndcg1000 = discountedCumulatedGainTR(pool, replicated_runSet, 'ShortNameSuffix', 'ndcg_replicated_1000', 'LogBase', 2, 'Normalize', true, 'CutOffs', 1000);
% Compute mean nDCG for the replicated run_set
% replicated_mndcg = mean(replicated_ndcg{:, :}, 1);

%%%%%%%%%%%%%%%%%% Write the results in a csv file

% Path to the folder which will contain the results
output_path = './results/measures/';
% List of measures that we need to write on a file
measures = {'p10' 'ap' 'ndcg5' 'ndcg10' 'ndcg20' 'ndcg50' 'ndcg100' 'ndcg1000'};

% For each measure in the list create a csv file with the results
for m = measures
    % Create the file name
    file_path = sprintf('%srpl_%s_%s.csv', output_path, original_run_name, m{:});
    
    % Write the measure data
    % Concatenate the original run table with the replicated runs
    eval(sprintf('results_%1$s = [original_%1$s, replicated_%1$s];', m{:}));
    % Write the run scores for each topic
    eval(sprintf('writetable(results_%s, file_path, ''Delimiter'', '','', ''WriteRowNames'', true, ''Encoding'',''UTF-8'');', m{:})); 
end

%%%%%%%%%%%%%%%%%% Compute Kendall's tau

% Trim the runs at 5, 10, 20, 50 and at 100
% Original run
original_run_5 = trim_runs(original_run, 5);
original_run_5.Properties.UserData.identifier = 'original_run_5';

original_run_10 = trim_runs(original_run, 10);
original_run_10.Properties.UserData.identifier = 'original_run_10';

original_run_20 = trim_runs(original_run, 20);
original_run_20.Properties.UserData.identifier = 'original_run_20';

original_run_50 = trim_runs(original_run, 50);
original_run_50.Properties.UserData.identifier = 'original_run_50';

original_run_100 = trim_runs(original_run, 100);
original_run_100.Properties.UserData.identifier = 'original_run_100';

% Replicated runset
replicated_runSet_5 = trim_runs(replicated_runSet, 5);
replicated_runSet_5.Properties.UserData.identifier = 'replicated_runSet_5';

replicated_runSet_10 = trim_runs(replicated_runSet, 10);
replicated_runSet_10.Properties.UserData.identifier = 'replicated_runSet_10';

replicated_runSet_20 = trim_runs(replicated_runSet, 20);
replicated_runSet_20.Properties.UserData.identifier = 'replicated_runSet_20';

replicated_runSet_50 = trim_runs(replicated_runSet, 50);
replicated_runSet_50.Properties.UserData.identifier = 'replicated_runSet_50';

replicated_runSet_100 = trim_runs(replicated_runSet, 100);
replicated_runSet_100.Properties.UserData.identifier = 'replicated_runSet_100';

% Compute Kendall's tau between the original and the replicated runs
% Create the tables which stores kendall's tau data
kendalls_tau_5 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_5.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_5.Properties.Description = 'kendalls_tau_5';

kendalls_tau_10 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_10.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_10.Properties.Description = 'kendalls_tau_10';

kendalls_tau_20 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_20.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_20.Properties.Description = 'kendalls_tau_20';

kendalls_tau_50 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_50.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_50.Properties.Description = 'kendalls_tau_50';

kendalls_tau_100 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_100.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_100.Properties.Description = 'kendalls_tau_100';

kendalls_tau_1000 = array2table(NaN(size(replicated_runSet)), 'VariableNames', replicated_runSet.Properties.VariableNames);
kendalls_tau_1000.Properties.RowNames = replicated_runSet.Properties.RowNames;
kendalls_tau_1000.Properties.Description = 'kendalls_tau';

% Compute Kendalls tau for each run
% For each run in the run set
for run_name = replicated_runSet.Properties.VariableNames
    
    % Return a vectors of tau for each topic
    kendalls_tau_5{:, run_name{:}} = tau_runs(original_run_5, replicated_runSet_5(:, run_name{:})).';
    
    % Return a vectors of tau for each topic
    kendalls_tau_10{:, run_name{:}} = tau_runs(original_run_10, replicated_runSet_10(:, run_name{:})).';
    
    % Return a vectors of tau for each topic
    kendalls_tau_20{:, run_name{:}} = tau_runs(original_run_20, replicated_runSet_20(:, run_name{:})).';
    
    % Return a vectors of tau for each topic
    kendalls_tau_50{:, run_name{:}} = tau_runs(original_run_50, replicated_runSet_50(:, run_name{:})).';
    
    % Return a vectors of tau for each topic
    kendalls_tau_100{:, run_name{:}} = tau_runs(original_run_100, replicated_runSet_100(:, run_name{:})).';
    
    % Return a vectors of tau for each topic
    kendalls_tau_1000{:, run_name{:}} = tau_runs(original_run, replicated_runSet(:, run_name{:})).';
end

% Write the results in a csv file
% List of correlation measures that we need to write on a file
measures = {'kendalls_tau_5', 'kendalls_tau_10', 'kendalls_tau_20', 'kendalls_tau_50' 'kendalls_tau_100' 'kendalls_tau_1000'};

% For each measure in the list create a csv file with the results
for m = measures
    % Create the file name
    file_path = sprintf('%srpl_%s_%s.csv', output_path, original_run_name, m{:});
    
    % Write the correlation scores for each topic and run
    eval(sprintf('writetable(%s, file_path, ''Delimiter'', '','', ''WriteRowNames'', true, ''Encoding'',''UTF-8'');', m{:})); 
end