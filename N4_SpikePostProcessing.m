%% TOP LEVEL PARAMETERS
%ADAPTED FROM JURI MINXHA 6/22
%{ 
Spike Sorting Procedure:

1. Run Osort on the task-releated recordings, for all three alignments
   Make sure to do projection tests for each channel
3. Renormalize where necessary
3. Merge clusters within channel where necessary, make sure not to lose
   spikes but also do not merge clusters lightly
4. Define the usable clusters in order to generate a Ax_sorted_new file for
   each sorted channel
5. Use the post-processing tool to clean up the clusters and to do
   comparison tests between them. Reject clusters that seem to much alike. 
6. Convert the Ax_sorted_new files to cell files


5.001 - First pass, positive alignment
5.002 - First pass, negative alignment
5.003 - First pass, mixed alignment

5.01x - Renormalized, positive alignement, block of channels x 
        ex. x=1 corresponds to channels 1-8
5.02x - Renormalized, negative alignement, block of channels x 
5.03x - Renormalized, mixed alignement, block of channels x 

Other folder indeces:

    - a 7 at the end indicates that a merger took place
    - an 8 at the end indicates a min-max merger


finalx - a work in progress, awaiting post-processing
final - the final Ax_sorted_new folder, after post-processing
sorted - contains the _cells files

Done!
%}

toplevel     = '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/';
session     = '';

basedir      = [toplevel,session];
sortVersion  = 'sort';
figsVersion  = 'figs'; 
finalVersion = 'final';
mergeVersion = 'merged';
prefix       = 'test';

%% Read all the data from the xlsx files
% Make sure the range specified within xlsread corresponds only to the
% relevant information, otherwise the indexing is going to be off

[num,txt,raw]               = xlsread([basedir,'pt_371.xlsx'],'Sheet1','C11:G11');
[channel,sort,clusterNumbers,ClustersToMerge] = readNumbersFromText(raw);
idxRemove = cellfun(@(x) isempty(x), clusterNumbers);
channel(idxRemove)          = [];
sort(idxRemove)             = [];
clusterNumbers(idxRemove)   = [];



%% MERGE CLUSTERS

%Do it manually
%mergeClusters( basedir,sortVersion,figsVersion,mergeVersion )

% Do it automatically
whichChannelsNeedMerge = find(~cellfun(@(x) isempty(x), ClustersToMerge));

% For each channel
for i=1:length(whichChannelsNeedMerge)
    groupsOnChannel = ClustersToMerge{whichChannelsNeedMerge(i)};
    
    % For each group of clusters
    for j=1:length(groupsOnChannel)
        pairs = groupsOnChannel{j};
        
        % For each pair of clusters within a group
        for k = 1:size(pairs,1)
            overwriteparams = pairs(k,:);
            mergeClusters( basedir,sortVersion,figsVersion,...
                           mergeVersion,overwriteparams);
        end
    end
end


%% DEFINE USABLE CLUSTERS


idxRemove = cellfun(@(x) isempty(x), clusterNumbers);
channel(idxRemove) = [];
sort(idxRemove) = [];
clusterNumbers(idxRemove) = [];
overwriteParams = [];
 

% List all available clusters
for i=1:length(clusterNumbers)
fprintf('%s\n',['Channel ' num2str(channel(i)) , ', Sort ' sort{i},...
                ', Clusters      ' num2str(clusterNumbers{i}) ]    )
end

% Define all usable clusters
for i=1:length(clusterNumbers)
fprintf('%s\n',['Channel ' num2str(channel(i)) , ', Sort ' sort{i},...
                ', Clusters      ' num2str(clusterNumbers{i}) ]    )
overwriteParams{i} = [channel(i) str2double(sort{i}) clusterNumbers{i}];
defineUsableClusters(basedir, sortVersion, figsVersion, finalVersion,overwriteParams{i});
end



 




 








