%% load files
%load the alpha omega data files
%don't need all the variables so only uploading the relevant ones so we
%don't clutter our workspace

%this is if you have more than one mat file from the alpha omega machine 
%if not just load that one variable normally
load '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_371/RT1D-1.288F0002.mat' CDIG_IN_1_Up

%more than one file 
load '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_371/RT1D-1.288F0002.mat' CDIG_IN_1_Up
Cdig_01_file1 = CDIG_IN_1_Up;
load '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_344/LT1D-0.434F0003.mat' CDIG_IN_1_Up
Cdig_01_file2 = CDIG_IN_1_Up;
%this is to combine the 2 variables into one continuous file
%again if you only have one file you don't need to do that
CDIG_IN_1_Up = [Cdig_01_file1 Cdig_01_file2];

%load behavioral data
load '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_371/behavior/371_behavioral_data.mat'

%load osort cluster data 
load '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_371/sort/final/test_1_sorted_new.mat'

%% Alignment 
%timings is the data trigger times
%digupms is the cdig 
%triggers_ms = data.trigger_times * 1000; %this is for older files when timings weren't ix unix 
triggers_ms = data.trigger_times - data.trigger_times(1); 
digupms = CDIG_IN_1_Up / 44; %change this according to however you label the name 
digupms = digupms';

%regression
%the first number in the stats variable is the r2 
%double check the r2 make sure it's 1 or close to 1
%change the number in the parenthesis to match how many digup points you
%have 
bfix = triggers_ms(1);
[b,bint,r,rin,stats] = regress(digupms(1:length(triggers_ms)),[ones(length(triggers_ms),1) triggers_ms]);
slope = b(2); %b gives the slope and offset of our 2 variables 
offset = b(1);
plot(triggers_ms,digupms(1:length(triggers_ms))); %plot the 2 against each other just to make sure it's a straight line
%more of a check than anything else 

% p = polyfit(triggers_ms,digupms_2(1:1002),1); %another way to get the
% slope and intercept

%changing the trigger timings into alpha omega timings for proper alignment
%making the choice and reward timings consecutive
%these are for the regular timing trials before we changed it to unix
% AO_choice_time_1 = ((data.block_one.choicetimes*1000) * slope) + offset;
% AO_choice_time_2 = ((data.block_two.choicetimes*1000) * slope) + offset + ((data.block_one.timeelapsed*1000) * slope);
% AO_choice_time_3 = ((data.block_three.choicetimes*1000) * slope) + offset + ((data.block_one.timeelapsed*1000) * slope) + ((data.block_two.timeelapsed*1000) * slope);
% AO_reward_time_1 = ((data.block_one.rewardtimes*1000) * slope) + offset;
% AO_reward_time_2 = ((data.block_two.rewardtimes*1000) * slope) + offset + ((data.block_one.timeelapsed*1000) * slope);
% AO_reward_time_3 = ((data.block_three.rewardtimes*1000) * slope) + offset + ((data.block_one.timeelapsed*1000) * slope) + ((data.block_two.timeelapsed*1000) * slope);

%this is for unix timings
AO_choice_time_1 = ((data.block_one.choicetimes-data.block_one.trigger_start) * slope) + offset;
AO_reward_time_1 = ((data.block_one.rewardtimes-data.block_one.trigger_start) * slope) + offset;
AO_choice_time_2 = ((data.block_two.choicetimes-data.block_one.trigger_start) * slope) + offset;% + ((data.block_one.timeelapsed) * slope);
AO_reward_time_2 = ((data.block_two.rewardtimes-data.block_one.trigger_start) * slope) + offset;% + ((data.block_one.timeelapsed) * slope);
AO_choice_time_3 = ((data.block_three.choicetimes-data.block_one.trigger_start) * slope) + offset;% + ((data.block_one.timeelapsed) * slope) + ((data.block_two.timeelapsed) * slope);
AO_reward_time_3 = ((data.block_three.rewardtimes-data.block_one.trigger_start) * slope) + offset;% + ((data.block_one.timeelapsed) * slope) + ((data.block_two.timeelapsed) * slope);

% AO_triggers = (triggers_ms * slope) + offset;

%convert the osort timings to ms
%EVERYTHING NEEDS TO BE IN MS FOR CONSISTENCY
timestamps = newTimestampsNegative';
timestamps_ms = timestamps/1000; %because osort saves it in microseconds 

%plot to make sure they are aligned
%check to make sure putting the choice and reward timings consecutively
%worked and there are no overlaps or big gaps 
plot(timestamps_ms,repmat(0,numel(timestamps_ms),1),'y*'); hold on

plot(AO_choice_time_1,repmat(0,numel(AO_choice_time_1),1),'r*'); hold on
plot(AO_choice_time_2,repmat(0,numel(AO_choice_time_2),1),'r*'); hold on
plot(AO_choice_time_3,repmat(0,numel(AO_choice_time_3),1),'r*'); hold on

plot(AO_reward_time_1,repmat(0,numel(AO_reward_time_1),1),'b*'); hold on
plot(AO_reward_time_2,repmat(0,numel(AO_reward_time_2),1),'b*'); hold on
plot(AO_reward_time_3,repmat(0,numel(AO_reward_time_3),1),'b*'); hold on

%% Raster plot for wins/losses
AO_timings = [AO_choice_time_1 AO_choice_time_2 AO_choice_time_3 AO_reward_time_1 AO_reward_time_2 AO_reward_time_3];
AO_names = {'choice1' 'choice2' 'choice3' 'reward1' 'reward2' 'reward3'};

wins_1 = find(data.block_one.outcomes == 1);
wins_2 = find(data.block_two.outcomes == 1);
wins_3 = find(data.block_three.outcomes == 1);
loss_1 = find(data.block_one.outcomes == 0);
loss_2 = find(data.block_two.outcomes == 0);
loss_3 = find(data.block_three.outcomes == 0);

%% full trial not separating by wins and losses
block = 1:35;
block = block';
%% overall wins and losses
AO_reward_time_overall = [AO_reward_time_1' AO_reward_time_2' AO_reward_time_3'];
AO_reward_time_overall = AO_reward_time_overall';
% 
wins_2 = wins_2 + 35;
wins_3 = wins_3 + 70;
wins = [wins_1' wins_2' wins_3'];
wins = wins';
loss_2 = loss_2 + 35;
loss_3 = loss_3 + 70;
loss = [loss_1' loss_2' loss_3'];
loss = loss';

%% looking at +10 vs 0 vs -10
wins_1_all = wins_1;
wins_2_all = wins_2 + 35;
wins_3_all = wins_3 + 70;
loss_1_all = loss_1;
loss_2_all = loss_2 + 35;
loss_3_all = loss_3 + 70;
%change this as you go but just easier to keep track this way 
% pt = 371
% reward block = 1
% punishment block = 2
% mixed block = 3

% +10 = reward wins + mixed wins
outcome_pos10 = [wins_1_all', wins_3_all']';
% 0 = reward loss + punishment wins
outcome_0 = [ loss_1_all', wins_2_all']';
% -10 = mixed loss + punishment loss 
outcome_neg10 = [loss_2_all', loss_3_all']';

%% save these variables so you don't have to do them again every single time
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/371_raster_data.mat')

%% making this a new section just so i can hit run section 
timing = AO_timings(:,4); %change to go from choice to reward
timing = timing(loss_1); %change from win to loss-both for each choice/reward
trigtimes_s = timing/1000;
setting = num2str(AO_names{4});%change, this should match the AO_timings(:,#)
for i = 1:length(useNegative)
    clus = find(assignedNegative == useNegative(i));
    time_clus = timestamps_ms(clus);
    time_clus_s = time_clus/1000;
    % time_clus_s = timestamps_ms/1000;
    mpsth(time_clus_s,trigtimes_s);
    cluster = ['cluster_', num2str(useNegative(i))];
    %change the save below with the naming at the end either win or loss 
   % saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_358/Rasters/rasters_wins_loss/',cluster,'_',setting,'_loss.png'])
    close all 
end

%% new zscore script wins/losses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% USE THIS %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timing = AO_timings(:,6); %change to go from choice to reward
timing = timing(wins_3); %change from win to loss-both for each choice/reward
trigtimes_s = timing/1000;
setting = num2str(AO_names{6});%change, this should match the AO_timings(:,#)
for i = 1:length(useNegative)
    clus = find(assignedNegative == useNegative(i));
    time_clus = timestamps_ms(clus); 
    time_clus_s = time_clus/1000;
    % time_clus_s = timestamps_ms/1000;
    [zcontinuous_fr_for_stats, tVec2, zscored_continuous_fr, zscored_stats_plot] = mpsth_SEQ_slots(time_clus_s,trigtimes_s); %change it from no z score back to z scores
    cluster = ['cluster_', num2str(useNegative(i))];
    %change the save below with the naming at the end either win or loss 
    save(['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_369/z scored fr/fr_wins_loss/',cluster,'_wins_',setting,'_zcscore_new.mat'], "tVec2", "zscored_continuous_fr", "zscored_stats_plot", "zcontinuous_fr_for_stats")
    saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_369/z scored fr/fr_wins_loss/',cluster,'_',setting,'_wins.png'])
    close all 
end

%%
%%%%% GOING TO LEAVE THE OVERALL STUFF IN BUT NOT DOING THAT%%%%
%% overall wins/losses  
timing = AO_reward_time_overall; 
timing = timing(wins); %change from win to loss
trigtimes_s = timing/1000;
setting = 'wins';%change to wins or loss 
for i = 1:length(useNegative)
    clus = find(assignedNegative == useNegative(i));
    time_clus = timestamps_ms(clus);
    time_clus_s = time_clus/1000;
    % time_clus_s = timestamps_ms/1000;
    %mpsth(time_clus_s,trigtimes_s);
    [zcontinuous_fr_for_stats, tVec2, zscored_continuous_fr, zscored_stats_plot] = mpsth_SEQ_slots(time_clus_s,trigtimes_s); %change it from no z score back to z scores
    cluster = ['cluster_', num2str(useNegative(i))];
    %change the save below with the naming at the end either win or loss 
    save(['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/z scored fr/',cluster,'_',setting,'_zcscore_new.mat'], "tVec2", "zscored_continuous_fr", "zscored_stats_plot", "zcontinuous_fr_for_stats")
    saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/Rasters/',cluster,'_',setting,'_raster.png'])
    close all 
end

%% overall wins and losses with z scores
%%%%%%%%%%%%%UN/EXPECTED WIN LOSS COMPARISON%%%%%%%%%%%%%%
AO_reward_time_overall = [AO_reward_time_1' AO_reward_time_2' AO_reward_time_3'];
AO_reward_time_overall = AO_reward_time_overall';

timing = AO_reward_time_overall;
%timing = AO_timings(:,6); %change to go from choice to reward
timing = timing(outcome_neg10); %change from win to loss
trigtimes_s = timing/1000;
setting = 'outcome_neg10';%change to wins or loss 
for i = 1:length(useNegative)
    clus = find(assignedNegative == useNegative(i));
    time_clus = timestamps_ms(clus);
    time_clus_s = time_clus/1000;
    % time_clus_s = timestamps_ms/1000;
    [zcontinuous_fr_for_stats, tVec2, zscored_continuous_fr, zscored_stats_plot] = mpsth_SEQ_slots(time_clus_s,trigtimes_s);
    cluster = ['cluster_', num2str(useNegative(i))];
    %change the save below with the naming at the end either win or loss 
    %saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_316/z scored fr/un_expected_wins_loss_block/',cluster,'_',setting,'.png'])
    save(['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_360_2/z scored fr/',cluster,'_',setting,'_zcscore_new.mat'], "tVec2", "zscored_continuous_fr", "zscored_stats_plot", "zcontinuous_fr_for_stats")
    saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_360_2/z scored fr/',cluster,'_',setting,'.png'])
    close all 
end
%% overall wins and losses with new z score script
timing = AO_reward_time_overall; 
timing = timing(loss); %change from win to loss
trigtimes_s = timing/1000;
setting = 'loss';%change to wins or loss 
for i = 1:length(useNegative)
    clus = find(assignedNegative == useNegative(i));
    time_clus = timestamps_ms(clus);
    time_clus_s = time_clus/1000;
    % time_clus_s = timestamps_ms/1000;
    mpsth_SEQ_slots(time_clus_s,trigtimes_s);
    cluster = ['cluster_', num2str(useNegative(i))];
    %change the save below with the naming at the end either win or loss 
    saveas(gcf,['/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_316/',cluster,'_',setting,'_zscore_2.png'])
    close all 
end
