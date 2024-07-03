%% getting the files ready 
filenames = dir('/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_*/*_raster_data.mat');
n_subjects = length(filenames);
%% getting all the neurons in a vector
neurons = [];
for i = 1:n_subjects
    subj{i,1} = filenames(i).name; %listing out our file names 
    load(subj{i})
    good_neurons = useNegative';
    neurons = vertcat(neurons, good_neurons);
end
%clearvars -except neurons filenames n_subjects all_spikes all_zscored_fr
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
all_fr_400_norm = [];
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
            all_baseline_fr{c,:} = stats_plot;
            %all_baseline_fr(c,:) = stats_plot;
        end
        %baseline_mean = mean(mean(all_baseline_fr(:,1:100)));
        for cc = 1:length(all_baseline_fr)
            baseline_values{cc,:} = all_baseline_fr{cc,1}(1:end-100);
        end
        baseline_mean = {mean(cat(2,baseline_values{:}))};
        baseline_std = {std(cat(2,baseline_values{:}))};
        clear normalized_feedback_fr normalized_baseline_fr norm_feedback_fr_points norm_baseline_fr_points no_z_feedback_fr no_z_baseline_fr all_baseline_fr_norm
        %changed all of these from 100 to 300 
        for d = 1:n_trials
            %baseline fr-column 1
            normalized_baseline_fr(d) = ((mean(all_baseline_fr{d,1}(1:end-1000)))- cell2mat(baseline_mean))/cell2mat(baseline_std);
            all_baseline_fr_norm{d,:} = (all_baseline_fr{d,1}(1:end-1000) - cell2mat(baseline_mean))/cell2mat(baseline_std);
            %feedback fr-column 2
            normalized_feedback_fr(d) = ((mean(all_baseline_fr{d,1}(end-999:end)))-cell2mat(baseline_mean))/cell2mat(baseline_std);
            no_z_baseline_fr(d) = mean(all_baseline_fr{d,1}(1:end-1000));
            no_z_feedback_fr(d) = mean(all_baseline_fr{d,1}(end-999:end));
%             for e = 301:400
%                norm_feedback_fr_points(d,:) = (all_baseline_fr{d,1} - cell2mat(baseline_mean))/cell2mat(baseline_std);
%             end
%             for f = 1:300
%                 norm_baseline_fr_points(d,f) = (all_baseline_fr(d,f) - baseline_mean)/baseline_std;
%             end
            norm_feedback_fr_points(d,:) = (all_baseline_fr{d,1}(end-999:end)-cell2mat(baseline_mean))/cell2mat(baseline_std);
        end
        norm_feedback_fr_points = norm_feedback_fr_points(:,end-999:end);
%         norm_baseline_fr_points = norm_baseline_fr_points(:,1:300);
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
%         all_norm_baseline_fr_points = vertcat(all_norm_baseline_fr_points,norm_baseline_fr_points);
        all_no_z_baseline_fr = vertcat(all_no_z_baseline_fr, no_z_baseline_fr);
        all_no_z_feedback_fr = vertcat(all_no_z_feedback_fr, no_z_feedback_fr);
        all_fr_400 = vertcat(all_fr_400, all_baseline_fr);
        all_fr_400_norm = vertcat(all_fr_400_norm, all_baseline_fr_norm);
    end
end
big_brain_data = [all_normalized_baseline_fr, all_normalized_feedback_fr, all_outcomes,...
    all_actions, all_conditions, all_blocks, all_neurons, all_neuron_type];
%% previous trials
previous_action = [];
previous_reward = [];
previous_reward_outcome = [];

for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    %previous action
    block1_pr_action = NaN(length(data.block_one.choices),1);
    block1_pr_action(2:end) = data.block_one.choices(1:end-1);
    block2_pr_action = NaN(length(data.block_two.choices),1);
    block2_pr_action(2:end) = data.block_two.choices(1:end-1);
    block3_pr_action = NaN(length(data.block_three.choices),1);
    block3_pr_action(2:end) = data.block_three.choices(1:end-1);
    pr_action = [block1_pr_action' block2_pr_action' block3_pr_action']';
    %previous reward
    block1_pr_reward = NaN(length(data.block_one.outcomes),1);
    block1_pr_reward(2:end) = data.block_one.outcomes(1:end-1);
    block2_pr_reward = NaN(length(data.block_two.outcomes),1);
    block2_pr_reward(2:end) = data.block_two.outcomes(1:end-1);
    block3_pr_reward = NaN(length(data.block_three.outcomes),1);
    block3_pr_reward(2:end) = data.block_three.outcomes(1:end-1);
    pr_reward = [block1_pr_reward' block2_pr_reward' block3_pr_reward']';
    %previous reward outcomes
    [reward_outcomes, outcomes1, outcomes2, outcomes3] = reward_outcomes_func(data);
    pr_reward_outcome1 = NaN(length(outcomes1),1);
    pr_reward_outcome1(2:end) = outcomes1(1:end-1);
    pr_reward_outcome2 = NaN(length(outcomes2),1);
    pr_reward_outcome2(2:end) = outcomes2(1:end-1);
    pr_reward_outcome3 = NaN(length(outcomes3),1);
    pr_reward_outcome3(2:end) = outcomes3(1:end-1);
    pr_reward_outcome = [pr_reward_outcome1' pr_reward_outcome2' pr_reward_outcome3']';
    for b = 1:length(useNegative)
        neurons_360_2 = [733, 702];
        previous_action = vertcat(previous_action, pr_action);
        previous_reward = vertcat(previous_reward, pr_reward);
        previous_reward_outcome = vertcat(previous_reward_outcome, pr_reward_outcome);
   end
end
%% reaction time
n_subjects = length(filenames);
s_time = [1,2,3]; %patients where the task was the old version so the time was recorded in seconds
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


%% magnitude of outcomes
all_magnitude_outcomes = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    [magnitude_outcome] = magnitude_outcome_calc(data);
    for b = 1:length(useNegative)
        all_magnitude_outcomes = vertcat(all_magnitude_outcomes, magnitude_outcome);
    end
end

%% reward outcomes so just +10, 0, or -10
all_reward_outcomes = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    [reward_outcomes] = reward_outcomes_func(data);
    for b = 1:length(useNegative)
        all_reward_outcomes = vertcat(all_reward_outcomes, reward_outcomes);
    end
end

%% put it all together 
all_data_2 = [big_brain_data, previous_reward, previous_action, previous_reward_outcome, all_rttimes, all_magnitude_outcomes, all_reward_outcomes];


