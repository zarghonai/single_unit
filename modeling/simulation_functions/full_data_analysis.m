%% getting the files ready 
filenames = dir('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_*/*_raster_data.mat');
n_subjects = length(filenames);
%% getting all the neurons in a vector
neurons = [];
for i = 1:n_subjects
    subj{i,1} = filenames(i).name; %listing out our file names 
    load(subj{i})
    good_neurons = useNegative';
    neurons = vertcat(neurons, good_neurons);
end
clearvars -except neurons filenames n_subjects all_spikes all_zscored_fr
%% initializing all the variables
% 1st column = baseline firing rate 
all_normalized_baseline_fr = [];
% 2nd column = feedback firing rate
all_normalized_feedback_fr = [];
% 3rd column = rewards 
all_outcomes = [];
% 4th column = actions 
all_actions = [];
% 5th column = condition (reward, punishment, mixed) - 1 is reward, 2 is
% punishment, 3 is mixed
all_conditions = [];
% 6th column = block number 
all_blocks = [];
% 7th column = neuron number
all_neurons = [];
% 8th column = neuron type (DA or GABA) - 1 is DA, 2 is GABA 
all_neuron_type = [];
all_norm_feedback_fr_points = [];
all_norm_baseline_fr_points = [];
all_no_z_baseline_fr = [];
all_no_z_feedback_fr = [];
all_fr_400 = [];
%% do everything else?
%n_trials = 105;
%block order-column 6
%block_number = zeros(n_trials,1);
%block_number(1:35) = 1;
%block_number(36:70) = 2;
%block_number(71:105) = 3;
DA_neurons = [880, 947, 1158, 1164, 687, 660, 1622, 1755, 587, 473, 917, 1609, 1571, 1430, 424, 475, 733, 702, 404, 389, 400, 882];
GABA_neurons = [1626, 1773, 1043, 1457, 919];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    %outcomes/rewards-column 3
    pt_outcomes = [data.block_one.outcomes' data.block_two.outcomes' data.block_three.outcomes']'; 
    %actions-column 4 
    pt_choices = [data.block_one.choices' data.block_two.choices' data.block_three.choices']';    
    block_order = data.block_order;
    %condition-column 5
    pt_id = data.block_one.participant_id;
    clear conditions
    [conditions] = condition_sequence(block_order, pt_id);
    conditions = conditions';
    AO_reward_time_overall = [AO_reward_time_1' AO_reward_time_2' AO_reward_time_3'];
    AO_reward_time_overall = AO_reward_time_overall';
    %block number-column 6
    clear block_number
    if contains (data.block_one.participant_id, '360_2')
        block_number(1:34) = 1;
        block_number(35:69) = 2;
        block_number(70:104) = 3;
    else
        block_number(1:35) = 1;
        block_number(36:70) = 2;
        block_number(71:105) = 3;
    end
    block_number = block_number';
    for b = 1:length(useNegative)
        clus = find(assignedNegative == useNegative(b));
        time_clus = timestamps_ms(clus);
        time_clus_s = time_clus/1000;
        if contains (data.block_one.participant_id, '360_2')
            n_trials = 104;
        else 
            n_trials = 105;
        end
        clear all_baseline_fr
        pt_choicetime = [];
        pt_rewardtime = [];
        pt_choicetime = [data.block_one.choicetimes' data.block_two.choicetimes' data.block_three.choicetimes']'; 
        pt_rewardtime = [data.block_one.rewardtimes' data.block_two.rewardtimes' data.block_three.rewardtimes']'; 
        for c = 1:n_trials
            pretime = pt_rewardtime(c) - pt_choicetime(c);
            if pretime < 5
                pretime = pretime * 1000;
            end
            %pretime = round(pretime);
            pretime = ceil(pretime/10)*10;
            timing = AO_reward_time_overall;
            timing = timing(c);
            trigtimes_s = timing/1000;
            [stats_plot] = baseline_fr(time_clus_s,trigtimes_s, pretime);
            %[zscored_stats_plot] = zscored_feedback_fr(time_clus_s,trigtimes_s);
            %all_baseline_fr{c,:} = stats_plot
            all_baseline_fr(c,:) = stats_plot;
        end
        %baseline_mean = mean(mean(all_baseline_fr(:,1:100)));
        baseline_values = all_baseline_fr(:,1:100); %changed from 100 to 300
        baseline_mean = mean(baseline_values(:));
        baseline_std = std(baseline_values(:));
        clear normalized_feedback_fr normalized_baseline_fr norm_feedback_fr_points norm_baseline_fr_points no_z_feedback_fr no_z_baseline_fr
        %changed all of these from 100 to 300 
        for d = 1:n_trials
            %baseline fr-column 1
            normalized_baseline_fr(d) = ((mean(all_baseline_fr(d,1:75)))- baseline_mean)/baseline_std;
            %feedback fr-column 2
            normalized_feedback_fr(d) = ((mean(all_baseline_fr(d,76:100)))-baseline_mean)/baseline_std;
            no_z_baseline_fr(d) = mean(all_baseline_fr(d,1:75));
            no_z_feedback_fr(d) = mean(all_baseline_fr(d,76:100));
            for e = 76:100
                norm_feedback_fr_points(d,e) = (all_baseline_fr(d,e) - baseline_mean)/baseline_std;
            end
            for f = 1:75
                norm_baseline_fr_points(d,f) = (all_baseline_fr(d,f) - baseline_mean)/baseline_std;
            end
        end
        norm_feedback_fr_points = norm_feedback_fr_points(:,76:100);
        norm_baseline_fr_points = norm_baseline_fr_points(:,1:75);
        normalized_baseline_fr = normalized_baseline_fr';
        normalized_feedback_fr = normalized_feedback_fr';
        no_z_baseline_fr = no_z_baseline_fr';
        no_z_feedback_fr = no_z_feedback_fr';
        %now we put it all together and pray it doesn't turn into a big
        %mess
        %gonna use a lot of vertcat
        %store everything in separate vectors and then put it all together
        %neuron number-column 7
        clear neuron_number
        neuron_number(1:n_trials,1) = useNegative(b);
        %neuron type-column 8
        clear neuron_type
        if ismember(useNegative(b), DA_neurons)
            neuron_type(1:n_trials,1) = 1;
        elseif ismember(useNegative(b), GABA_neurons)
            neuron_type(1:n_trials,1) = 2;
        end
        %start with column 1-normalized baseline fr
        all_normalized_baseline_fr = vertcat(all_normalized_baseline_fr, normalized_baseline_fr);
        %column 2-normalized feedback fr
        all_normalized_feedback_fr = vertcat(all_normalized_feedback_fr, normalized_feedback_fr);
        %column 3-reward
        all_outcomes = vertcat(all_outcomes, pt_outcomes);
        %column 4-actions
        all_actions = vertcat(all_actions, pt_choices);
        %column 5-conditions
        all_conditions = vertcat(all_conditions, conditions);
        %column 6-block number
        all_blocks = vertcat(all_blocks,block_number);
        %column 7-neuron number
        all_neurons = vertcat(all_neurons,neuron_number);
        %column 8-neuron type
        all_neuron_type = vertcat(all_neuron_type,neuron_type);
        %no column just adding it in here-normalized feedback firing rate
        %for 100 points post reward
        all_norm_feedback_fr_points = vertcat(all_norm_feedback_fr_points,norm_feedback_fr_points);
        all_norm_baseline_fr_points = vertcat(all_norm_baseline_fr_points,norm_baseline_fr_points);
        all_no_z_baseline_fr = vertcat(all_no_z_baseline_fr, no_z_baseline_fr);
        all_no_z_feedback_fr = vertcat(all_no_z_feedback_fr, no_z_feedback_fr);
        all_fr_400 = vertcat(all_fr_400, all_baseline_fr);
    end
end
big_brain_data = [all_normalized_baseline_fr, all_normalized_feedback_fr, all_outcomes,...
    all_actions, all_conditions, all_blocks, all_neurons, all_neuron_type];


%% adding more columns!
%previous reward
%9th column
previous_reward_1 = [];
for t = 2:length(all_outcomes)
    if all_outcomes(t) == 0 && all_outcomes(t-1) == 0;
        previous_reward_1(t) = 0;
    elseif all_outcomes(t) == 0 && all_outcomes(t-1) == 1;
        previous_reward_1(t) = 1;
    elseif all_outcomes(t) == 1 && all_outcomes(t-1) == 0;
        previous_reward_1(t) = 2;
    else all_outcomes(t) == 1 && all_outcomes(t-1) == 1;
        previous_reward_1(t) = 3;
    end
end
previous_reward_1 = previous_reward_1';
previous_reward_1(1) = NaN;
for ii = 1:21
    for i = 1:length(previous_reward_1)    
        if i == 1+35*ii
            previous_reward_1(i) = NaN;
        end
    end
end

%previous action
%10th column
previous_action = [];
for t = 2:length(all_actions)
    if all_actions(t) == 0 && all_actions(t-1) == 0;
        previous_action(t) = 0;
    elseif all_actions(t) == 0 && all_actions(t-1) == 1;
        previous_action(t) = 1;
    elseif all_actions(t) == 1 && all_actions(t-1) == 0;
        previous_action(t) = 2;
    else all_actions(t) == 1 && all_actions(t-1) == 1;
        previous_action(t) = 3;
    end
end
previous_action = previous_action';

%reaction time
%11th column
%some are in unix some are not ughhh gotta change that 
%is it just dividing it by 1000???
%%
all_rttimes = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    rt_time_1 = data.block_one.choicetimes - data.block_one.cuetimes;
    rt_time_2 = data.block_two.choicetimes - data.block_two.cuetimes;
    rt_time_3 = data.block_three.choicetimes - data.block_three.cuetimes;
    rt_time = [rt_time_1' rt_time_2' rt_time_3']';
    if ismember(a, s_time)
        rt_time = rt_time * 1000;
    end
    for b = 1:length(useNegative)
        all_rttimes = vertcat(all_rttimes, rt_time);
    end
end
%%
for b = 1:length(all_rttimes)
    if all_rttimes(b) >= 100;
        all_rttimes(b) = all_rttimes(b)/1000;
    end
end
log_rttimes = log(all_rttimes);
%RPE?? is that the difference between the outcomes or a more complicated
%computational modeling way to figure out RPE 
%there is a computational way-will talk about that with salman later

%magnitude of outcomes
%12th column
all_magnitude_outcomes = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    [magnitude_outcome] = magnitude_outcome_calc(data);
    for b = 1:length(useNegative)
        all_magnitude_outcomes = vertcat(all_magnitude_outcomes, magnitude_outcome);
    end
end

%reward outcomes so just +10, 0, or -10
%13th column
all_reward_outcomes = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    [reward_outcomes] = reward_outcomes_func(data);
    for b = 1:length(useNegative)
        all_reward_outcomes = vertcat(all_reward_outcomes, reward_outcomes);
    end
end


all_data_2 = [big_brain_data, previous_reward_1, previous_action, all_rttimes, all_magnitude_outcomes, all_reward_outcomes];

%% splitting the table by dopamine and GABA neurons 
neuron_type = all_data_2(:,8);
for i = 1:length(all_data_2(:,8))
    if all_data_2(i,8) == 1
        DA_data(i,:) = all_data_2(i,:);
    elseif all_data_2(i,8) == 2
        GABA_data(i,:) = all_data_2(i,:);
    end
end
DA_data = DA_data(any(DA_data,2),:);
GABA_data = GABA_data(any(GABA_data,2),:);

%clearvars -except all_data_2 all_norm_feedback_fr_points all_spikes all_zscored_fr big_brain_data DA_data GABA_data all_fr_400
clearvars -except all* big* DA* GABA* previous*

%% RASTER DATA STUFFFFFFFFFFF
%find whatever trial numbers correspond to what we wanna check in the
%DA_data or GABA_data trials
%use the corresponding trials in the all_spikes cell array
%bad_DA = [424, 475, 1755, 404, 389, 400];
%good_DA = [880, 947, 1158, 1164, 687, 660, 587, 473, 1609, 1571, 1430, 917, 733, 702]; 
DA_win_after_loss = [];
for i = 1:length(all_data_2(:,1))
    if ismember(all_data_2(i,7), DA_neurons)
        %if all_data(i,5) == 2
            if previous_reward_1(i) == 2
                x = i;
                DA_win_after_loss = vertcat(DA_win_after_loss, x);
            end
        %end
    end
end
%DA_pun_exp_win_fr = all_zscored_fr(DA_loss_after_loss,:);
DA_win_after_loss_fb_fr = all_norm_feedback_fr_points(DA_win_after_loss,:);
DA_win_after_loss_plot = mean(DA_win_after_loss_fb_fr);
% DA_pun_exp_win_100_plot = mean(DA_loss_after_loss_fb_fr);
% DA_rew_20_feedback = DA_data(DA_rew_20, 2);
% DA_0_spikes = all_spikes(DA_0);
% trialspx = DA_0_spikes;

%% individual neuron plots
%per block
cl1164_neg_rpe_rew = find(all_rpes{1,2}(:,1) < 0);% + 35;
cl1158 = find(all_data(:,7) == 1164);
cl1158_neg_rpe_rew_fr = all_norm_feedback_fr_points(cl1158(cl1164_neg_rpe_rew),:);
%cl947_0_fr = all_norm_feedback_fr_points(cl947(find(all_data(cl947,13) == 0)),:);
cl1164_neg_rpe_rew_plot = mean(cl1158_neg_rpe_rew_fr);

%altogether
rpe_323 = [all_rpes{1,2}(:,1)' all_rpes{1,2}(:,2)' all_rpes{1,2}(:,3)']';
cl1158_neg_rpe = find(rpe_323 < 0);
cl1158 = find(all_data(:,7) == 1158);
cl1158_neg_rpe_rew_fr = all_norm_feedback_fr_points(cl1158(cl1158_neg_rpe),:);
cl1158_neg_rpe_plot = mean(cl1158_neg_rpe_rew_fr);

%wins vs losses
cl882_loss_0 = find(all_data(:,7)==882 & all_data(:,13)==0 & all_data(:,3)==0);
cl400_loss_0_fr = all_norm_feedback_fr_points(cl400_loss_0,:);
cl400_loss_0_plot = mean(cl400_loss_0_fr);

%% individual raster data
cl733_wins_spikes = all_spikes(cl733_wins);
trialspx = cl733_wins_spikes;

%% individual neuron fr plotting
cl1622_wins = [];
for i = 1:length(all_data_2(:,1))
    if all_data_2(i,7) == 1622 & all_data_2(i,3) == 1
        x = i;
        cl1622_wins = vertcat(cl1622_wins, x);
    end
end
%cl1626_loss_fb_fr = all_norm_feedback_fr_points(cl1626_loss,:);
cl1164_0_base_fr = all_norm_baseline_fr_points(cl1622_wins,:);
cl1164_0_plot = mean(cl1164_0_base_fr);

patch([(clusters{1}) fliplr((clusters{1}))],[cl1164_neg10_plot(clusters{1}+200) fliplr(cl1164_pos10_plot(clusters{1}+200))], 'k', 'EdgeColor', 'none', 'FaceAlpha', .3); hold on
plot(cl1164_neg10_plot(201:300), 'r')
hold on
plot(cl1164_0_plot(201:300), 'b')
hold on
plot(cl1164_pos10_plot(201:300), 'g')
legend('Cl 1164 Outcome = -10', 'Cl 1164 Outcome = 0', 'Cl 1164 Outcome = +10')
title("Peri-Stimulus Firing Rate")
ax = gca
saveas(gcf, '/Users/Lab Member/Desktop/DBS Slot Machine Pt/peristimulus graphs/all neurons/cl1164 reward outcome baseline.png')


[clusters, p_values, t_sums, permutation_distribution] = permutest(cl1164_neg10_base_fr(:,201:300)', cl1164_pos10_base_fr(:,201:300)', false, 0.05, 500, true);

%% new section
cl880_loss_nonz_fr = all_feedback_fr(cl880_loss,:);
cl882_wins_nonz_fr = all_fr_400(cl1622_wins,301:400);
