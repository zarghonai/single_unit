%this to plot the waveforms of all the clusters with labels
%do this once with all the clusters osort outputs
%do it again after merging and discarding with the final mat file 
nrDataPoints=size(newSpikesNegative,2);

%raw , sortedit
label = 'Pt 343';
for k=1:2
    allSpikes=[];
    assigned=[];
    toUse=[];
    if k==1
        allSpikes=newSpikesPositive;
        assigned=assignedPositive;
        toUse=usePositive;
    else
        allSpikes=newSpikesNegative;
        assigned=assignedNegative;
        toUse=useNegative;
    end
    
    if size(allSpikes,1)==0
        continue;
    end
	
    hold on
	for i=1:length(toUse)
        cluNr = toUse(i);
        txt = ['Cluster Number = ',num2str(cluNr)];
        m = mean ( allSpikes( find(assigned==cluNr),:)); %this is what is used to plot the average waveforms!!!!
        %use this to figure out peaks and troughs and all that fun jazz
        %color=colors{i};
%         if ismember(toUse(i), bad_clus)
%             plot(1:nrDataPoints, m,'Color',[0.7,0.7,0.7],'linewidth',2,'DisplayName',txt);
%         else toUse(i)
%             plot(1:nrDataPoints, m,'Color',[rand,rand,rand],'linewidth',2,'DisplayName',txt);
%         end
        plot(1:nrDataPoints, m,'Color',[rand,rand,rand],'linewidth',2,'DisplayName',txt);
	end
    hold off
    %legend sho
	xlim( [1 nrDataPoints] );

    title([ label ' Average Waveforms of All Clusters ']);
end
%% SAVING
%save after you see the graph in case you don't like the colors :)
%run whichever line accordingly 
%this is for the one with all the clusters
saveas(gcf,'/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/figs/plotwithlegend.png')
%this is for the final merged clusters
saveas(gcf,'/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/figs/final/plotwithlegend.png')
