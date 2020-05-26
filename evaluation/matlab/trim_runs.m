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
function [runSet] = trim_runs(runSet, runLength)
     persistent PROCESS_RUN;
    
    if isempty(PROCESS_RUN)        
        PROCESS_RUN = @processRun;
    end
      
    fprintf('+ Trimming runs\n');
    
    % replicate runLength to properly work with cellfun
    runLength = repmat({runLength}, 1, width(runSet));
    
    for t = 1:height(runSet)
        runSet{t, :} = cellfun(PROCESS_RUN, runSet{t, :}, runLength, 'UniformOutput', false);
    end % for topic
    
        
end


function [runTopic] = processRun(topic, runLength)
   runTopic = topic(1:min(height(topic), runLength), :);
end
