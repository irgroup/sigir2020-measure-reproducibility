% This script:
% 1) Imports the original and reproduced runs
% 2) Computes the evaluation measures for each run
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
    % Path to the folder with the reproducibility runs
    reproduced_run_path = '../runs/reproducibility_rename/wcrobust04/';
    
elseif strcmp(original_run_name, 'wcrobust0405')
    % Path to the original run
    % We removed from this run the extra topics which are not assessed
    original_run_path = '../runs/original/WCrobust0405_replicability.txt';
    % Path to the folder with the reproducibility runs
    reproduced_run_path = '../runs/reproducibility_rename/wcrobust0405/';
end

% Path to the qrels, 2017 (original), 2018 (reproduced)
original_qrels_path = '../qrels/qrels_common_core_2017.txt';
reproduced_qrels_path = '../qrels/qrels_common_core_2018_reproducibility.txt';

% Import the qrels, both the 2017 and 2018
original_pool = importPoolFromFileTRECFormat('FileName', original_qrels_path, 'Identifier', 'original_pool', 'Delimiter', 'space', 'RelevanceGrades', 0:2, 'RelevanceDegrees', {'NotRelevant', 'Relevant', 'HighlyRelevant'});
% The delimiter for the qrels from 2018 (modified set of qrels) is tab
% The qrels were modified to contain only the 25 topics that are included
% in the reproducibility runs
reproduced_pool = importPoolFromFileTRECFormat('FileName', reproduced_qrels_path, 'Identifier', 'reproduced_pool', 'Delimiter', 'tab', 'RelevanceGrades', 0:2, 'RelevanceDegrees', {'NotRelevant', 'Relevant', 'HighlyRelevant'});

% Import the original run, we use the same order as trec_eval
original_run = importRunFromFileTRECFormat('FileName', original_run_path, 'Identifier', 'original_run', 'Delimiter', 'tab', 'DocumentOrdering', 'TrecEvalLexDesc');

% Import the replicated runs
% Recall that they should be .txt files
% The run id should be different for each run even inside the text file
reproduced_runSet = importRunsFromDirectoryTRECFormat('Path', reproduced_run_path, 'Identifier', 'reproduced_runSet', 'Delimiter', 'tab', 'DocumentOrdering', 'TrecEvalLexDesc');
%test_runSet = importRunFromFileTRECFormat('FileName', '../runs/reproducibility_rename/wcrobust04/rpd_wcrobust04_10.txt', 'Identifier', 'reproduced_runSet', 'Delimiter', 'tab', 'DocumentOrdering', 'TrecEvalLexDesc');


%%%%%%%%%%%%%%%%%% Precision at 10

% Compute precision at 10 for the original run
original_p10 = precision(original_pool, original_run, 'ShortNameSuffix', 'p_original_10', 'MapToBinaryRelevance', 'Lenient', 'CutOffs', 10);
% Compute precision at 10 for the reproduced runset
reproduced_p10 = precision(reproduced_pool, reproduced_runSet, 'ShortNameSuffix', 'p_reproduced_10', 'MapToBinaryRelevance', 'Lenient', 'CutOffs', 10);


%%%%%%%%%%%%%%%%%% Average Precision

% Compute average precision for the original run
original_ap = averagePrecision(original_pool, original_run, 'ShortNameSuffix', 'ap_original', 'MapToBinaryRelevance', 'Lenient');
% Compute average precision for the reproduced runset
reproduced_ap = averagePrecision(reproduced_pool, reproduced_runSet, 'ShortNameSuffix', 'ap_reproduced', 'MapToBinaryRelevance', 'Lenient');

%%%%%%%%%%%%%%%%%% nDCG

% Compute nDCG for the original run
% This is nDCG as in trec_eval: the discount is done by log2(i + 1), not
% log2(i)
% The default relevance weights are [0 5 10]
original_ndcg10 = discountedCumulatedGainTR(original_pool, original_run, 'ShortNameSuffix', 'ndcg_original_10', 'Normalize', true, 'LogBase', 2, 'CutOffs', 10);
original_ndcg100 = discountedCumulatedGainTR(original_pool, original_run, 'ShortNameSuffix', 'ndcg_original_100', 'Normalize', true, 'LogBase', 2, 'CutOffs', 100);
original_ndcg1000 = discountedCumulatedGainTR(original_pool, original_run, 'ShortNameSuffix', 'ndcg_original_1000', 'Normalize', true, 'LogBase', 2, 'CutOffs', 1000);
% Compute nDCG for the reproduced runset
reproduced_ndcg10 = discountedCumulatedGainTR(reproduced_pool, reproduced_runSet, 'ShortNameSuffix', 'ndcg_reproduced_10', 'LogBase', 2, 'Normalize', true, 'CutOffs', 10);
reproduced_ndcg100 = discountedCumulatedGainTR(reproduced_pool, reproduced_runSet, 'ShortNameSuffix', 'ndcg_reproduced_100', 'LogBase', 2, 'Normalize', true, 'CutOffs', 100);
reproduced_ndcg1000 = discountedCumulatedGainTR(reproduced_pool, reproduced_runSet, 'ShortNameSuffix', 'ndcg_reproduced_1000', 'LogBase', 2, 'Normalize', true, 'CutOffs', 1000);


%%%%%%%%%%%%%%%%%% Write the results in a csv file

% Path to the folder which will contain the results
output_path = './results/measures_rpd/';
% List of measures that we need to write on a file
measures = {'p10' 'ap' 'ndcg10' 'ndcg100' 'ndcg1000'};

% For each measure in the list create a csv file with the results
for m = measures
    % Create the file name
    original_file_path = sprintf('%sorg_%s_%s.csv', output_path, original_run_name, m{:});
    reproducibility_file_path = sprintf('%srpd_%s_%s.csv', output_path, original_run_name, m{:});
    % Write the run scores for each topic for the original runs
    eval(sprintf('writetable(original_%1$s, original_file_path, ''Delimiter'', '','', ''WriteRowNames'', true, ''Encoding'',''UTF-8'');', m{:})); 
    % Write the run scores for each topic for the reproducibility runs
    eval(sprintf('writetable(reproduced_%1$s, reproducibility_file_path, ''Delimiter'', '','', ''WriteRowNames'', true, ''Encoding'',''UTF-8'');', m{:})); 
end
