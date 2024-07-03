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
clearvars -except neurons filenames n_subjects all_zscored_fr previous*
%% initializing all the variables
% 1st column = baseline firing rate 
all_normalized_choice_fr = [];
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
all_spikes = [];
%% 
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
    s_time = 1:3;
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
        clear all_choice_fr spikes
        pt_choicetime = [];
        pt_cuetime = [];
        pt_choicetime = [data.block_one.choicetimes' data.block_two.choicetimes' data.block_three.choicetimes']'; 
        pt_cuetime = [data.block_one.cuetimes' data.block_two.cuetimes' data.block_three.cuetimes']'; 
        pt_rewardtime = [data.block_one.rewardtimes' data.block_two.rewardtimes' data.block_three.rewardtimes']'; 
        for c = 2:n_trials
            choicetime = pt_choicetime(c) - pt_cuetime(c);
            posttime = pt_cuetime(c) - pt_rewardtime(c-1);
            %if choicetime < 100
            if ismember(a, s_time)
                choicetime = choicetime * 1000;
                posttime = posttime*1000;
            end
            % posttime = pt_rewardtime(c) - pt_choicetime(c);
            % if posttime < 5
            %     posttime = posttime * 1000;
            % end
            % %pretime = round(pretime);
            choicetime = ceil(choicetime/10)*10;
            posttime = ceil(posttime/10)*10;
            timing = AO_reward_time_overall;
            timing = timing(c);
            trigtimes_s = timing/1000;
            [stats_plot] = baseline_fr(time_clus_s,trigtimes_s, choicetime,posttime);
            [psth trialspx] = mpsth(time_clus_s,trigtimes_s,choicetime);
            %[zscored_stats_plot] = zscored_feedback_fr(time_clus_s,trigtimes_s);
            all_choice_fr{c,:} = stats_plot;
            spikes{c,:} = trialspx;
            %all_baseline_fr(c,:) = stats_plot;
        end
        %baseline_mean = mean(mean(all_baseline_fr(:,1:100)));
        % for cc = 1:length(all_choice_fr)
        %     choice_values{cc,:} = all_choice_fr{cc,1}(1:end-100);
        % end
        choice_mean = {mean(cat(2,all_choice_fr{:}))};
        choice_std = {std(cat(2,all_choice_fr{:}))};
        clear normalized_choice_fr norm_feedback_fr_points norm_baseline_fr_points no_z_feedback_fr no_z_choice_fr all_choice_fr_norm 
        %changed all of these from 100 to 300 
        for d = 1:n_trials
            %baseline fr-column 1
            normalized_choice_fr(d) = ((mean(all_choice_fr{d,1}))- cell2mat(choice_mean))/cell2mat(choice_std);
            all_choice_fr_norm{d,:} = (all_choice_fr{d,1} - cell2mat(choice_mean))/cell2mat(choice_std);
            %feedback fr-column 2
            no_z_choice_fr(d) = mean(all_choice_fr{d,1});
        end
        normalized_choice_fr = normalized_choice_fr';
        no_z_choice_fr = no_z_choice_fr';
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
        all_normalized_choice_fr = vertcat(all_normalized_choice_fr, normalized_choice_fr);
        %column 6-block number
        all_blocks = vertcat(all_blocks,block_number);
        %column 7-neuron number
        all_neurons = vertcat(all_neurons,neuron_number);
        %column 8-neuron type
        all_neuron_type = vertcat(all_neuron_type,neuron_type);
        %no column just adding it in here-normalized feedback firing rate
        %for 100 points post reward
        all_no_z_baseline_fr = vertcat(all_no_z_baseline_fr, no_z_choice_fr);
        all_fr_400 = vertcat(all_fr_400, all_choice_fr);
        all_fr_400_norm = vertcat(all_fr_400_norm, all_choice_fr_norm);
        all_spikes = vertcat(all_spikes, spikes);
    end
end