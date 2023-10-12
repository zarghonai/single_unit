%% loading data in 
%load raw spiking data
load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_324/LT1D-0.784F0002.mat' CSPK_01_KHz CSPK_01
%load osort data
load 'Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_324/sort/final/324_test_1_sorted_new.mat'
%% analysis 
%find length of recording 
time_sec = length(CSPK_01)/(CSPK_01_KHz * 1000); %this will give you the time in seconds
timestamps = newTimestampsNegative';
timestamps_ms = timestamps/1000;
%find timings of spikes for each cluster
%divide those timings by 1000 
%keep track of the naming
%if you have more than 2 then just add another cluster 
cluster1name = num2str(useNegative(1));
cluster2name = num2str(useNegative(2));
%cluster3name = num2str(useNegative(3));

cluster1 = (timestamps_ms(find(assignedNegative == useNegative(1))))/1000;
cluster2 = (timestamps_ms(find(assignedNegative == useNegative(2))))/1000;
%cluster3 = (timestamps_ms(find(assignedNegative == useNegative(3))))/1000;

%make a vector of for the length of your recording 
rec_length_sec = 1:1:time_sec;
rec_length_sec = rec_length_sec';
%change the name of the cluster accordingly
%again if there's more than 2 just add in another 2 lines but change the
%numbers to reflect cluster 3 and so on 
for i = 1:length(rec_length_sec)
%for i = rec_length_sec(233):1:rec_length_sec(end)
    spikes_clus1 = cluster1(cluster1 > (i-1) & cluster1 < i); %this is looking at
    % how many times the values in the cluster occurred between each second
    spikes_sec_clus1(i) = numel(spikes_clus1); %counting how many times the above happened
    %for each iteration 
    spikes_clus2 = cluster2(cluster2 > (i-1) & cluster2 < i); 
    spikes_sec_clus2(i) = numel(spikes_clus2);
%     spikes_clus3 = cluster3(cluster3 > (i-1) & cluster3 < i); 
%     spikes_sec_clus3(i) = numel(spikes_clus3);
end
%% now average it out I guess
%label the firing rates according to which cluster is 1 and which is 2
firingrate_816 = mean(spikes_sec_clus1);
firingrate_148 = mean(spikes_sec_clus2);
%save 
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/371_firing_rate.mat') %save data as mat file
