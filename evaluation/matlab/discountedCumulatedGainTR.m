%% discountedCumulatedGain
% 
% Computes the discounted cumulated gain at each rank position, or 
% at  document cut-offs values, or at the recall base, or at each 
% relevant retrieved document.

%% Synopsis
%
%   [measuredRunSet, poolStats, runSetStats, inputParams] = discountedCumulatedGain(pool, runSet, Name, Value)
%
% Note that discounted cumulated gain will be NaN when there are no relevant
% documents for a given topic in the pool.
%  
% *Parameters*
%
% * *|pool|* - the pool to be used to assess the run(s). It is a table in the
% same format returned by <../io/importPoolFromFileTRECFormat.html 
% importPoolFromFileTRECFormat>;
% * *|runSet|* - the run(s) to be assessed. It is a table in the same format
% returned by <../io/importRunFromFileTRECFormat.html 
% importRunFromFileTRECFormat> or by <../io/importRunsFromDirectoryTRECFormat.html 
% importRunsFromDirectoryTRECFormat>;
%
% *Name-Value Pair Arguments*
%
% Specify comma-separated pairs of |Name|, |Value| arguments. |Name| is the 
% argument name and |Value| is the corresponding value. |Name| must appear 
% inside single quotes (' '). You can specify several name and value pair 
% arguments in any order as |Name1, Value1, ..., NameN, ValueN|.
%
% * *|ShortNameSuffix|* (optional) - a string providing a suffix which will
% be concatenated to the short name of the measure. It can contain only
% letters, numbers and the underscore. The default is empty.
% * *|NotAssessed|* (optional) - a string indicating how not assessed
% documents, i.e. those in the run but not in the pool, have to be
% processed: |NotRevelant|, the minimum of the relevance degrees of the 
% pool is used as |NotRelevant|; |Condensed|, the not assessed documents 
% are  removed from the run. If not specified, the default value  is 
% |NotRelevant| to mimic the behaviour of trec_eval.
% * *|MapToRelevanceWeights|* (optional) - a vector of numbers to which the
% relevance degrees in the pool will be mapped. It must be an increasing
% vector with as many elements as the relevance degrees in the pool are.
% The default is |[0, 5, 10, ...]| up to as many relevance degrees are in
% the pool.
% * *|MapToBinaryRelevance|* (optional) - a string specifying how relevance 
% degrees have to be mapped to binary relevance. The following values can 
% be used: _|Hard|_ considers only the maximum degree of relevance in the 
% pool as |Relevant| and any degree below it as |NotRelevant|; _|Lenient|_ 
% considers any degree of relevance in the pool above the minimum one as 
% |Relevant| and only the minimum one is considered as |NotRelevant|; 
% * *|Normalize|* (optional) - a boolean indicating whether normalization
% has to be performed or not, i.e whether DCG or nDCG has to be computed.
% Default is |false|.
% * *|LogBase|* (optional) - an integer indicating the log base to be used
% for discounting. The default is |10|.
% * *|Microsoft|* (optional) - a boolean indicating whether the "Microsoft"
% version of (n)DCG has to be used (discounting by log2(r+1)). The default
% is |false|.
% * *|CutOffs|* (optional) - specifies whether DCG at document
% cut-offs values has to be returned instead of DCG at each rank
% position. It can be either the string _|Standard|_ to use the standard
% trec_eval document cut-off values [5 10 15 20 30 100 200 500 1000]; a
% numeric integer increasing vector with the desired document cut-off
% values; _|RelevantRetrieved|_ to compute cumulated gain at each relevant
% retrieved document; or, _|LastRelevantRetrieved|_ to return the value of
% the measure at the last relevant retrieved document. If not specified, 
% cumulated gain at each rank position will be computed.
% * *|RecallBase|* (optional) - a boolean specifying whether DCG
% at the recall base has to be computed or not. If not specified, then 
% |false| is  used as default. Note that this option is mutually exclusive 
% with |CutOffs|.
% * *|FixNumberRetrievedDocuments|* (optional) - an integer value
% specifying the expected length of the retrieved document list. Topics
% retrieving more documents than |FixNumberRetrievedDocuments| will be 
% truncated at |FixNumberRetrievedDocuments|; topics retrieving less
% documents than |FixNumberRetrievedDocuments| will be padded with
% additional documents according to the strategy defined in 
% |FixedNumberRetrievedDocumentsPaddingStrategy|. If not specified, the 
% value 1,000 will be used as default, to mimic the behaviour of trec_eval.
% Pass an empty matrix to let topics retrieve a variable number of
% documents.
% * *|FixedNumberRetrievedDocumentsPaddingStrategy|* (optional) - a string
% specifying how topics with less than |FixNumberRetrievedDocuments| have
% to be padded. The following values can be used: _|NotRelevant|_ documents
% assessed as |NotRelevant|, i.e. the minimum relevance degree in the pool,
% are added and then the measure will be computed; _|NaN|_ the measure
% vector will be filled in with 
% <http://www.mathworks.it/it/help/matlab/ref/nan.html NaN> values; 
% _|LastValue| the measure vector will be filled in with the last value
% achieved by the measure itself; _|LastValueAfterRecallBase|_
% |NotRelevant| documents will be added up to the recall base and then the
% measure will be computed while after the recall base the measure vector
% will be filled in with the last value achieved by the measure itself.
% If not specified, |NotRelevant| is used as default to mimic the behaviour 
% of trec_eval.
% % * *|Verbose|* (optional) - a boolean specifying whether additional
% information has to be displayed or not. If not specified, then |false| is 
% used as default.
%
% *Returns*
%
% * *|measureRunSet|*  - a table containing a row for each topic and a column 
% for each run named |runName|. Each cell of the table contains either a 
% vector of DCG values, when DCG or DCG at document 
% cut-off values are asked, or a scalar, when DCG at recall base is 
% asked. The |UserData| property of  the table contains a struct  with the 
% following fields: _|identifier|_ is the identifier of the run; _|name|_ 
% is the name of the computed measure; _|shortName|_ is a short name of the
% computed measure; _|pool|_ is the identifier of the pool with respect to
% which the measure has been computed; |cutOffs| are the request document 
% cut-offs values, if any. 
% * *|poolStats|* - see description in <assess.html assess>.
% * *|runSetStats|* - see description in <assess.html assess>.
% * *|inputParams|* - a struct summarizing the input parameters passed.
% 

%% Example of use
%  
%   measuredRunSet = discountedCumulatedGainTR(pool, runSet, 'CutOffs', 'Standard');
%
% It computes the discounted cumulated gain at standard document cut-off 
% values for a run set. Suppose the run set contains the following runs:
% 
% * |APL985LC.txt|
% * |AntHoc01.txt|
% * |Brkly24.txt|
%
% In this example each run has two topics, |351| and |352|. It returns the 
% following table.
%
%              APL985LC          AntHoc01          Brkly24   
%           ______________    ______________    ______________
%
%    351    [1x9 double]      [1x9 double]      [1x9 double]
%    352    [1x9 double]      [1x9 double]      [1x9 double]
%
% Column names are run identifiers, row names are topic identifiers; cells
% contain a row vector with the nine values of precision at standard
% document cut-off values.
% 
%   Brkly24_351 = measuredRunSet{'351','Brkly24'}
%
%   ans =
%
%    10.0000   15.0000   15.0000   15.0000   15.0000   49.0007   67.6244   87.9098  105.3730
%
% It returns the discounted cumulated gain at 5, 10, 15, 20, 30, 100, 200, 500, and 1000
% retrieved documents for topic 351 of run Brkly24.
%
%% References
% 
% Please refer to:
%
% * Järvelin, K. and Kekäläinen, J. (2002). Cumulated Gain-Based Evaluation of IR Techniques.
% _ACM Transactions on Information Systems (TOIS)_, 20(4):422-446.
% * Keskustalo, H., Järvelin, K., Pirkola, A., and Kekäläinen, J. (2008). 
% Intuition-Supporting Visualization of User's Performance Based on Explicit 
% Negative Higher-Order Relevance. In Chua, T.-S., Leong, M.-K., Oard, D. W., 
% and Sebastiani, F., editors, _Proc. 31st Annual International ACM SIGIR Conference on Research and Development in Information Retrieval (SIGIR 2008)_, 
% pages 675-681. ACM Press, New York, USA.
% 
% For the "Microsoft" version of (n)DCG, please refer to:
%
% * Burges, C., Shaked, T., Renshaw, E., Lazier, A., Deeds, M., Hamilton, N., 
% and Hullender, G. (2005). Learning to Rank using Gradient Descent. In 
% Dzeroski, S., De Raedt, L., and Wrobel, S., editors,
% _Proc. 22nd International Conference on Machine Learning (ICML 2005)_, 
% pages 89-96. ACM Press, New York, USA.
%
% For condensed result lists (|Condensed| in parameter |NotAssessed|), 
% please refer to:
%
% * Sakai, T. (2007). Alternatives to Bpref. In Kraaij, W., de Vries, A. P., 
% Clarke, C. L. A., Fuhr, N., and Kando, N., editors, _Proc. 30th Annual 
% International ACM SIGIR Conference on Research and Development in 
% Information Retrieval (SIGIR 2007)_, pages 71-78. ACM Press, New York, 
% USA.

%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>,
% <mailto:silvello@dei.unipd.it Gianmaria Silvello>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: Matlab 2013b or higher
% * *Copyright:* (C) 2013-2014 <http://ims.dei.unipd.it/ Information 
% Management Systems> (IMS) research group, <http://www.dei.unipd.it/ 
% Department of Information Engineering> (DEI), <http://www.unipd.it/ 
% University of Padua>, Italy
% * *License:* <http://www.apache.org/licenses/LICENSE-2.0 Apache License, 
% Version 2.0>

%%
%{
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
      http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
%}

%%
function [measuredRunSet, poolStats, runSetStats, inputParams] = discountedCumulatedGain(pool, runSet, varargin)

    persistent MY_SORTROWS UNSAMPLED_UNJUDGED;
           
    if isempty(MY_SORTROWS)
        
        MY_SORTROWS = @(x) {sortrows(x, 2, 'descend')};
    
        % New categorical value to be added to the pool to indicate not
        % sampled documents or documents that have been pooled but
        % unjudged. See Yilmaz and Aslam, CIKM 2006
        UNSAMPLED_UNJUDGED = 'U_U';

    end;
    
    
    % check that we have the correct number of input arguments. 
    narginchk(2, inf);
    
    % parse the variable inputs
    pnames = {'ShortNameSuffix' 'MapToRelevanceWeights' 'MapToBinaryRelevance' 'CutOffs' 'NotAssessed' 'FixNumberRetrievedDocuments' 'FixedNumberRetrievedDocumentsPaddingStrategy' 'RecallBase' 'Normalize' 'LogBase' 'Microsoft' 'Verbose'};
    dflts =  {[]                []                      []                     []        'NotRelevant' 1000                          'NotRelevant'                                  false        false       10        false       false};
    
    
    if verLessThan('matlab', '9.2.0')
        [shortNameSuffix, mapToRelevanceWeights, mapToBinaryRelevance, cutOffs, notAssessed, fixNumberRetrievedDocuments, fixedNumberRetrievedDocumentsPaddingStrategy, recallBase, normalize, logBase, microsoft, verbose, supplied] ...
            = matlab.internal.table.parseArgs(pnames, dflts, varargin{:});
    else
        [shortNameSuffix, mapToRelevanceWeights, mapToBinaryRelevance, cutOffs, notAssessed, fixNumberRetrievedDocuments, fixedNumberRetrievedDocumentsPaddingStrategy, recallBase, normalize, logBase, microsoft, verbose, supplied] ...
            = matlab.internal.datatypes.parseArgs(pnames, dflts, varargin{:});
    end        
           

    % actual parameters to be passed to assess.m, at least 6
    assessInput = cell(1, 6);
    
    % not assessed documents must be considered as not relevant for
    % precision
    assessInput{1, 1} = 'NotAssessed';
    assessInput{1, 2} = notAssessed;

    if supplied.MapToBinaryRelevance
        % there will be only two relevance degrees after mapping (no matter
        % their names for the following settings in assessInput)
        relevanceDegrees = {'BinaryNotRelevant', 'BinaryRelevant'};
    else
        % get the relevance degrees in the pools
        relevanceDegrees = categories(pool{:, 1}{1, 1}.RelevanceDegree);
        relevanceDegrees = relevanceDegrees(:).';
    end;
    
    if supplied.MapToRelevanceWeights                        
        validateattributes(mapToRelevanceWeights, {'numeric'}, ....
        {'vector', 'nonempty', 'increasing', 'numel', numel(relevanceDegrees)}, ...
        '', 'MapToRelevanceWeights');

        % ensure it is a row vector
        mapToRelevanceWeights = mapToRelevanceWeights(:).';
    else
        
        
        if strcmpi(relevanceDegrees{1}, UNSAMPLED_UNJUDGED)         
            % set default 5-based relevance weights skipping U_U docs
            mapToRelevanceWeights = 0:5:5*(length(relevanceDegrees) - 2);
        else
            % set default 5-based relevance weights
            mapToRelevanceWeights = 0:5:5*(length(relevanceDegrees) - 1);
        end;
    end;
    
    % map to relevance weights must be performed. Either use the passed
    % values or the default ones.
    assessInput{1, 3} = 'MapToRelevanceWeights';
    assessInput{1, 4} = mapToRelevanceWeights;
        
    % remove unsampled/unjudged documents because they are not appropriate
    % for precision computation
    assessInput{1, 5} = 'RemoveUUFromPool';
    assessInput{1, 6} = true;
    
    % add the mapping to binary relevance, if needed
    if supplied.MapToBinaryRelevance
        assessInput{1, end+1} = 'MapToBinaryRelevance';
        assessInput{1, end+1} = mapToBinaryRelevance;
    end;  
    
    if supplied.ShortNameSuffix
        if iscell(shortNameSuffix)
            % check that nameSuffix is a cell array of strings with one element
            assert(iscellstr(shortNameSuffix) && numel(shortNameSuffix) == 1, ...
                'MATTERS:IllegalArgument', 'Expected ShortNameSuffix to be a cell array of strings containing just one string.');
        end
        
        % remove useless white spaces, if any, and ensure it is a char row
        shortNameSuffix = char(strtrim(shortNameSuffix));
        shortNameSuffix = shortNameSuffix(:).';
        
        % check that the nameSuffix is ok according to the matlab rules
        if ~isempty(regexp(shortNameSuffix, '\W*', 'once'))
            error('MATTERS:IllegalArgument', 'NameSuffix %s is not valid: it can contain only letters, numbers, and the underscore.', ...
                shortNameSuffix);
        end  
        
        % if it starts with an underscore, remove it since il will be
        % appended afterwards
        if strcmp(shortNameSuffix(1), '_')
            shortNameSuffix = shortNameSuffix(2:end);
        end;
    end;
    
    if supplied.FixNumberRetrievedDocuments && ~isempty(fixNumberRetrievedDocuments)
        % check that FixNumberRetrievedDocuments is a scalar integer value
        % greater than 0
        validateattributes(fixNumberRetrievedDocuments, {'numeric'}, ...
            {'scalar', 'integer', '>', 0}, '', 'FixNumberRetrievedDocuments');
    end;
    
    if supplied.FixedNumberRetrievedDocumentsPaddingStrategy
        
        if ~supplied.FixNumberRetrievedDocuments
             error('MATTERS:IllegalArgument', 'Cannot specify a padding strategy when the number of retrieved documents to be considered for each topic has not been set (FixNumberRetrievedDocuments not used).');
        end;
        
        % check that FixedNumberRetrievedDocumentsPaddingStrategy is a non-empty string
        validateattributes(fixedNumberRetrievedDocumentsPaddingStrategy, ...
            {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
            'FixedNumberRetrievedDocumentsPaddingStrategy');
        
        if iscell(fixedNumberRetrievedDocumentsPaddingStrategy)
            % check that fixedNumberRetrievedDocumentsPaddingStrategy is a cell array of strings with one element
            assert(iscellstr(fixedNumberRetrievedDocumentsPaddingStrategy) && numel(fixedNumberRetrievedDocumentsPaddingStrategy) == 1, ...
                'MATTERS:IllegalArgument', 'Expected FixedNumberRetrievedDocumentsPaddingStrategy to be a cell array of strings containing just one string.');
        end
        
        % remove useless white spaces, if any, and ensure it is a char row
        fixedNumberRetrievedDocumentsPaddingStrategy = char(strtrim(fixedNumberRetrievedDocumentsPaddingStrategy));
        fixedNumberRetrievedDocumentsPaddingStrategy = fixedNumberRetrievedDocumentsPaddingStrategy(:).';
        
        % check that FixedNumberRetrievedDocumentsPaddingStrategy assumes a valid value
        validatestring(fixedNumberRetrievedDocumentsPaddingStrategy, ...
            {'NotRelevant', 'NaN', 'LastValue', 'LastValueAfterRecallBase'}, ...
            '', 'FixedNumberRetrievedDocumentsPaddingStrategy');             
    end;       
    
    % when (i) no fixed number of retrieved docs is specified OR (ii) it is
    % specified but no padding strategy is specified or 'NotRelevant'
    % padding is specified OR (iii) it is empty to mean no padding at all, 
    % let assess.m know it
    if ~supplied.FixNumberRetrievedDocuments || ...
        (supplied.FixNumberRetrievedDocuments && ...
            (~supplied.FixedNumberRetrievedDocumentsPaddingStrategy || ...
                strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'NotRelevant') ...
            ) ...
        ) || ...
        isempty(fixNumberRetrievedDocuments)
     
        assessInput{1, end+1} = 'FixNumberRetrievedDocuments';
        assessInput{1, end+1} = fixNumberRetrievedDocuments;
        
        assessInput{1, end+1} = 'FixedNumberRetrievedDocumentsPaddingStrategy';
        assessInput{1, end+1} = fixedNumberRetrievedDocumentsPaddingStrategy;
    end
     
    if supplied.CutOffs
        
        if isnumeric(cutOffs)
            % check that cutOffs is a non-empty numeric vector with
            % increasing and integer values
            validateattributes(cutOffs, {'numeric'}, ...
                {'vector', 'integer', 'nonempty', 'positive', 'increasing'}, ...
                '', 'CutOffs');

            % ensure it is a row vector
            cutOffs = cutOffs(:).';

            % check we are not asking cut-offs we cannot achieve 
            if supplied.FixNumberRetrievedDocuments && cutOffs(end) > fixNumberRetrievedDocuments
                error('MATTERS:IllegalArgument', 'The highest cut-off requested (%d) is bigger than the number of documents to be returned (%d).', ...
                     cutOffs(end), fixNumberRetrievedDocuments);
            end;
            
        % if it is not numeric, 
        elseif ischar(cutOffs)
            
            % check that CutOffs is a non-empty string
            validateattributes(cutOffs, ...
                {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
                'CutOffs');
        
            if iscell(cutOffs)
                % check that cutOffs is a cell array of strings with one element
                assert(iscellstr(cutOffs) && numel(cutOffs) == 1, ...
                    'MATTERS:IllegalArgument', 'Expected cCtOffs to be a cell array of strings containing just one string.');
            end
        
            % remove useless white spaces, if any, and ensure it is a char row
            cutOffs = char(strtrim(cutOffs));
            cutOffs = cutOffs(:).';
        
            % check that CutOffs assumes a valid value
            validatestring(cutOffs, ...
                {'Standard', 'RelevantRetrieved', 'LastRelevantRetrieved'}, ...
                '', 'CutOffs');   
            
            switch lower(cutOffs)
                case 'standard'
                    cutOffs = [5 10 15 20 30 100 200 500 1000];
                case 'relevantretrieved'
                    cutOffs = NaN;
                case 'lastrelevantretrieved'
                    cutOffs = Inf;
            end;   
        else
            error('MATTERS:IllegalArgument', 'Invalid type for CutOffs: only numeric and chars are allowed.).');
        end;
    end;
    
    if supplied.RecallBase
        % check that recallBase is a non-empty scalar
        % logical value
        validateattributes(recallBase, {'logical'}, {'nonempty', 'scalar'}, '', 'RecallBase');
        
        if supplied.CutOffs
             error('MATTERS:IllegalArgument', 'Cannot compute DCG at recall base and DCG@DCV at the same time.');
        end; 
    end; 
    
    if supplied.Normalize
        % check that normalize is a non-empty scalar
        % logical value
        validateattributes(normalize, {'logical'}, {'nonempty', 'scalar'}, '', 'Normalize');
    end;    
    
    if supplied.LogBase
        % check that normalize is a non-empty scalar
        % integer value greater than 1
        validateattributes(logBase, {'numeric'}, {'nonempty', 'integer', 'scalar', '>', 1}, '', 'LogBase');
    end;    
    
    if supplied.Microsoft        
        if supplied.LogBase
            error('MATTERS:IllegalArgument', 'Cannot compute msDCG and DCG with a given log base at the same time.');
        end;
        
        % check that normalize is a non-empty scalar
        % logical value
        validateattributes(microsoft, {'logical'}, {'nonempty', 'scalar'}, '', 'Microsoft');
    end;    
       
    if supplied.Verbose
        % check that verbose is a non-empty scalar
        % logical value
        validateattributes(verbose, {'logical'}, {'nonempty', 'scalar'}, '', 'Verbose');
    end;    
               
      
    if verbose
        fprintf('\n\n----------\n');
        
        fprintf('Computing discounted cumultated gain for run set %s with respect to pool %s: %d run(s) and %d topic(s) to be processed.\n\n', ...
            runSet.Properties.UserData.identifier, pool.Properties.UserData.identifier, width(runSet), height(runSet));

        fprintf('Settings:\n');
        fprintf('  - relevance degrees: %s;\n', strjoin(relevanceDegrees, ', '));
        fprintf('  - relevance weights: %s;\n', num2str(mapToRelevanceWeights));
        
        if normalize
            fprintf('  - performing normalization\n');
        else
            fprintf('  - not performing normalization\n');
        end;
        
        if ~isempty(fixNumberRetrievedDocuments)
            fprintf('  - fixed number of retrieved documents enabled. The threshold for the number of retrieved documents per topic is %d;\n', fixNumberRetrievedDocuments);
            fprintf('    + topics above the threshold will discard documents, topics below the threshold will pad documents;\n');
            fprintf('    + documents will be padded as follows: %s;\n', fixedNumberRetrievedDocumentsPaddingStrategy);
        else
            fprintf('  - fixed number of retrieved documents not enabled. Runs may retrieve a different number of documents per topic;\n');
        end;
        
        if ~isempty(cutOffs)
            fprintf('  - documents cut-offs: %s;\n', num2str(cutOffs));
        else
            fprintf('  - documents cut-offs not enabled;\n');
        end;
        
        if ~isempty(recallBase)
            fprintf('  - CG at recall base will be computed;\n');
        end;
        
        fprintf('\n');
    end;
    
    [assessedRunSet, poolStats, runSetStats, inputParams] = assess(pool, runSet, 'Verbose', verbose, assessInput{:});
    
    % get the minimum weight which is associated to notRelevant documents
    MIN_WEIGHT = min(mapToRelevanceWeights);
    
    % create an ideal run
    if normalize
        idealRun = rowfun(MY_SORTROWS, pool, 'ExtractCellContents', true);
        idealRun.Properties.UserData.identifier = ['idealRun_' pool.Properties.UserData.identifier];
        idealRun = assess(pool, idealRun, 'Verbose', verbose, assessInput{:});                
    end;
    
    % adjust input parameters if padding was not managed by assess.m
    if supplied.FixNumberRetrievedDocuments && ...
            ~strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'NotRelevant')        
        inputParams.fixNumberRetrievedDocuments = fixNumberRetrievedDocuments;
        inputParams.fixedNumberRetrievedDocumentsPaddingStrategy = fixedNumberRetrievedDocumentsPaddingStrategy;
    end;
    
    inputParams.cutOffs = cutOffs;
    inputParams.rPrec = recallBase;

    
     % the topic currently under processing
    ct = 1;
        
    % the run currently under processing
    cr = 1;
    
    % compute the measure topic-by-topic
    measuredRunSet = rowfun(@processTopic, assessedRunSet, 'OutputVariableNames', runSet.Properties.VariableNames, 'OutputFormat', 'table', 'ExtractCellContents', true, 'SeparateInputs', false);
    measuredRunSet.Properties.UserData.identifier = assessedRunSet.Properties.UserData.identifier;
    measuredRunSet.Properties.UserData.pool = pool.Properties.UserData.identifier;
    
    if ~isempty(cutOffs)
        if numel(cutOffs) > 1
            measuredRunSet.Properties.UserData.name = 'discountedCumulatedGainAtDocumentCutOffValues';        
            measuredRunSet.Properties.UserData.shortName = 'DCG_DCV';
        else
            if isnan(cutOffs)
                measuredRunSet.Properties.UserData.name = 'discountedCumulatedGainAtRelevantRetrievedDocuments';        
                measuredRunSet.Properties.UserData.shortName = 'DCG_RR';
            else
                measuredRunSet.Properties.UserData.name = ['discountedCumulatedGainAt_' num2str(cutOffs) '_DocumentCutOffValue'];        
                measuredRunSet.Properties.UserData.shortName = ['DCG_' num2str(cutOffs)];
            end;
        end;
                
        measuredRunSet.Properties.UserData.cutOffs = cutOffs;
    elseif recallBase
        measuredRunSet.Properties.UserData.name = 'discountedCumulatedGainAtRecallBase';
        measuredRunSet.Properties.UserData.shortName = 'DCG_RB';
    else
        measuredRunSet.Properties.UserData.name = 'discountedCumulatedGain';
        measuredRunSet.Properties.UserData.shortName = 'DCG';
    end;
    
    if microsoft
        measuredRunSet.Properties.UserData.name = ['microsoftD'  measuredRunSet.Properties.UserData.name(2:end)];
         measuredRunSet.Properties.UserData.shortName = ['ms'  measuredRunSet.Properties.UserData.shortName];
    end;
    
     if normalize
         if microsoft
            measuredRunSet.Properties.UserData.name = ['normalizedM'  measuredRunSet.Properties.UserData.name(2:end)];
            measuredRunSet.Properties.UserData.shortName = ['nMS'  measuredRunSet.Properties.UserData.shortName(3:end)];
         else
            measuredRunSet.Properties.UserData.name = ['normalizedD'  measuredRunSet.Properties.UserData.name(2:end)];
            measuredRunSet.Properties.UserData.shortName = ['n'  measuredRunSet.Properties.UserData.shortName];
         end;
     end;
     
    % add the used log base
    measuredRunSet.Properties.UserData.name = [measuredRunSet.Properties.UserData.name '_Log' num2str(logBase)];
    measuredRunSet.Properties.UserData.shortName = [measuredRunSet.Properties.UserData.shortName '_Log' num2str(logBase)];
             
    % add the used relevance weights
    measuredRunSet.Properties.UserData.name = [measuredRunSet.Properties.UserData.name '_W' ...
        strrep(sprintf('%d_', mapToRelevanceWeights), '-', 'n')];
    measuredRunSet.Properties.UserData.name = measuredRunSet.Properties.UserData.name(1:end-1);
    
    measuredRunSet.Properties.UserData.shortName = [measuredRunSet.Properties.UserData.shortName '_W' ...
        strrep(sprintf('%d_', mapToRelevanceWeights), '-', 'n')];
    measuredRunSet.Properties.UserData.shortName = measuredRunSet.Properties.UserData.shortName(1:end-1);
    
    if strcmpi(notAssessed, 'condensed')
         if normalize
             measuredRunSet.Properties.UserData.name = ['condensedN'  measuredRunSet.Properties.UserData.name(2:end)];
             measuredRunSet.Properties.UserData.shortName = ['condN'  measuredRunSet.Properties.UserData.shortName(2:end)];
         else
             if microsoft
                 measuredRunSet.Properties.UserData.name = ['condensedM'  measuredRunSet.Properties.UserData.name(2:end)];
                 measuredRunSet.Properties.UserData.shortName = ['condMS'  measuredRunSet.Properties.UserData.shortName(3:end)];
             else
                 measuredRunSet.Properties.UserData.name = ['condensedD'  measuredRunSet.Properties.UserData.name(2:end)];
                 measuredRunSet.Properties.UserData.shortName = ['condD'  measuredRunSet.Properties.UserData.shortName(2:end)];
             end;
         end;
    end;
    
    
    if ~isempty(shortNameSuffix)
        measuredRunSet.Properties.UserData.shortName = [measuredRunSet.Properties.UserData.shortName ...
            '_' shortNameSuffix];
    end;
    
    if verbose
        fprintf('Computation of discounted cumulated gain completed.\n');
    end;
    
    %%
    
    % compute the measure for a given topic over all the runs
    function [varargout] = processTopic(topic)

        
        if(verbose)
            fprintf('Processing topic %s (%d out of %d)\n', pool.Properties.RowNames{ct}, ct, inputParams.topics);
            fprintf('  - run(s): ');
        end;
        
        % reset the index of the run under processing for each topic
        cr = 1;
        
        % compute the measure only on those column which contain the
        % actual runs
        varargout = cellfun(@processRun, topic);
        
        % increment the index of the current topic under processing
        ct = ct + 1;    
        
         if(verbose)
            fprintf('\n');
        end;
        
        %% 
        
        % compute the measure for a given topic of a given run
        function [measure] = processRun(runTopic)
            
            if(verbose)
                fprintf('%s ', runSet.Properties.VariableNames{cr});
            end;
            
            % avoid useless computations when you already know that either
            % the run has retrieved no relevant documents (0) or that there
            % are no relevant documents in the pool (NaN)
            if(runSetStats{ct, cr}.relevantRetrieved == 0)                
                if (poolStats{ct, 'RecallBase'} == 0)
                    measure = NaN(1, height(runTopic));
                else
                    measure = zeros(1, height(runTopic));
                end;                               
            else     
                % run length
                rl = height(runTopic);
                
                if microsoft
                    % the Microsoft version discounts by log2(r + 1),
                    % with rank starting from 1, so by a vector
                    % 2:length(rank)+1
                    % see Burges et al., ICML 2005, equation 16
                    measure = (runTopic{:, 'Assessment'} ./ log2(2:rl + 1)).';
                else                    
                     if logBase > rl
                          error('MATTERS:IllegalState', 'Run %s retrieved %d document(s) for topic %s which is less than the log base requested (%d).', ...
                            runSet.Properties.VariableNames{cr}, rl, ... 
                            pool.Properties.RowNames{ct}, logBase);
                     end;
                     
                     measure = runTopic{:, 'Assessment'}.';
                     
                     % discount only those ranks equal to or greater than the
                     % log base
                     measure(logBase:rl) = measure(logBase:rl) ./ log2((logBase:rl)+1) .* log2(logBase);
                end;
                                                    
                % cumulate the discounted gains up to each rank position 
                measure = cumsum(measure);
                
                % normalize by the ideal run
                if normalize   
                    
                    % the ideal run is the pool sorted in descending order
                    % of relevance weights
                    ideal = sort(idealRun{ct, 1}{1, 1}{:, :}.', 2, 'descend');
                    
                    il = length(ideal);
                    
                    if microsoft
                        ideal = ideal ./ log2(2:il + 1);
                    else
                        if logBase > il
                          error('MATTERS:IllegalState', 'Ideal run %s retrieved %d document(s) for topic %s which is less than the log base requested (%d).', ...
                            pool.Properties.UserData.identifier, il, ... 
                            pool.Properties.RowNames{ct}, logBase);
                        end;
                        
                        % discount only those ranks equal to or greater than 
                        % the log base
                        ideal(logBase:il) = ideal(logBase:il) ./ log2((logBase:rl)+1) .* log2(logBase);
                    end;
                    
                    measure = measure ./ cumsum(ideal);
                end;
                
                
            end;
            
            % check whether we have to retrieve a fixed number of documents
            % and this is not already done in assess.m
            if ~isempty(fixNumberRetrievedDocuments) && ...
                    ~strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'NotRelevant')        
                
                h = length(measure);
                
                % if there are more retrieved documents than the threshold,
                % simply remove them
                if h > fixNumberRetrievedDocuments
                    measure = measure(1:h);    
                    
                    runSetStats{ct, cr}.fixedNumberRetrievedDocuments.discardedDocuments = h - fixNumberRetrievedDocuments;
                    runSetStats{ct, cr}.fixedNumberRetrievedDocuments.paddedDocuments = 0;
                
                % if there are less retrieved documents than the threshold,
                % pad them according to the requested padding strategy
                elseif h < fixNumberRetrievedDocuments 
                    
                    % fill with NaN
                    if strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'NaN')
                        measure(h + 1, fixNumberRetrievedDocuments) = NaN(1, fixedNumberRetrievedDocumentsPaddingStrategy - h);
                    
                    % fill with the last value achieved by the measure
                    elseif strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'LastValue')
                        measure(h + 1, fixNumberRetrievedDocuments) = measure(h);
                        
                    % fill with not relevant between h and recall base and
                    % after recall base with the last value achieved by the
                    % measure
                    elseif strcmpi(fixedNumberRetrievedDocumentsPaddingStrategy, 'LastValueAfterRecallBase')
                        
                        rb =  poolStats{ct, 'RecallBase'};
                        
                        % if we are already after the recall base, fill
                        % with the last value achieved by the measure
                        if h >= rb
                            measure(h + 1, fixNumberRetrievedDocuments) = measure(h);                        
                        else
                            
                            % the padding between h and rb is as if only
                            % not relevant documents were retrieved.
                            % Compute the total number of relevant
                            % retrieved at the end of the vector
                            % (measure(h)*h), repeat it for as many
                            % positions there are up to the recall base,
                            % divide by the index of those position to get
                            % precision
                            measure(h + 1, rb) = repmat(measure(h) * h, 1, rb - h) ...
                                                    ./ ...
                                                 (h+1:rb);
                             
                            % fill with the last value achieved by the 
                            % measure at the recall base
                            measure(rb + 1, fixNumberRetrievedDocuments) = measure(rb);                        
                         end    
                        
                    end;                                            
                    
                    runSetStats{ct, cr}.fixedNumberRetrievedDocuments.discardedDocuments = 0;
                    runSetStats{ct, cr}.fixedNumberRetrievedDocuments.paddedDocuments = fixNumberRetrievedDocuments - h;
                end;
                                   
            end;
            
            % return only the requested cut-offs
            if ~isempty(cutOffs)
                
                % if cutOffs is NaN, then return precision at each relevant
                % retrieved document, which means where there a 1s in
                % runTopic. Note that all the vectors in a table must have
                % the same length, so we cannot return only the relevant
                % documents but instead we return the full precision vector
                % with NaNs at not relevant documents
                if isnan(cutOffs)
                    measure(~logical(runTopic{:, 'Assessment'})) = NaN;
                elseif isinf(cutOffs)
                    %measure = measure(find(runTopic{:, 'Assessment'} ~= MIN_WEIGHT, 1, 'last')); 
                    measure = measure(length(measure)); 
                    % if the are no relevant documents in the run
                    if isempty(measure)
                        measure = 0;
                    end;
                else
                    
                    % check we are not asking cut-offs we cannot achieve 
                    if cutOffs(end) > length(measure)
                        error('MATTERS:IllegalState', 'Run %s retrieved %d document(s) for topic %s which is less than the highest document cut-off value requested (%d).', ...
                            runSet.Properties.VariableNames{cr}, length(measure), ... 
                            pool.Properties.RowNames{ct}, cutOffs(end));
                    end;

                    measure = measure(cutOffs);
                end;
                
            end;
            
            % return Rprecision is asked
            if recallBase
                
                rb =  poolStats{ct, 'RecallBase'};
                
                % check we are not asking cut-offs we cannot achieve 
                if rb > length(measure)
                    error('MATTERS:IllegalState', 'Run %s retrieved %d document(s) for topic %s which is less than the recall base requested (%d).', ...
                        runSet.Properties.VariableNames{cr}, length(measure), ... 
                        pool.Properties.RowNames{ct}, rb);
                end;
                
                if (rb == 0)
                    measure = NaN;
                else                
                    measure = measure(rb);
                end;
                
            end;
            
            % properly wrap the results into a cell in order to fit it into
            % a value for a table
            measure = {measure};
            
            % increment the index of the current run under processing
            cr = cr + 1;
        end
    end
    
end



