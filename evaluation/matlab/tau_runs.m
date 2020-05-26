%% trim_run
% 
% Trims a set of runs to the length specificed in the overall configuration.
%
%% Synopsis
%
%   [outputRun] = trim_runs(inputRun)
%  
%
% *Parameters*
%
% * *|inputTrackID|* - the identifier of the input track to process.
% * *|outputTrackID|* - the identifier of the output track to produce.
%
% *Returns*
%
% Nothing
%

%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: Matlab 2018a or higher
% * *Copyright:* (C) 2018 <http://www.dei.unipd.it/ 
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
function [tau] = tau_runs(run1, run2)    
    assert(height(run1) == height(run2))
    
    T = height(run1);
    
    tau = NaN(1, T);
    
    for t = 1:T
        
        doc1 = run1{t, 1}{1}{:, 1};
        doc2 = run2{t, 1}{1}{:, 1};
        
        % Take the union of the ranked list of documents
        doc = [doc1; doc2];
        % Remove the duplicate documents
        doc = unique(doc);
        
        % Get the rank position of each document from the original list in 
        % the union list
        % original list.
        [~, ldoc1] = ismember(doc1, doc);
        [~, ldoc2] = ismember(doc2, doc);
        
        tau(t) = corr(ldoc1, ldoc2, 'type','Kendall');
    end % for topic
            
end
