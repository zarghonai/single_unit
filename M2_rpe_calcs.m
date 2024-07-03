%using the new simulation code run to get rpes
%use actual values from each patient
%make sure the reversals are correct
filenames = dir('/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_*/*_raster_data.mat');
n_subjects = length(filenames);
clearvars -except all_params filenames n_subjects rew_params pun_params mix_params best_params 
T =35; 
%% new section 
%load data in
%use reversal condition function to get the reversal trials and different
%mu values 
%using the params find rpes
%order them according to original order???
n_blocks = 3;
all_neuron_rpe = [];
for i=1:n_subjects
    subj{i,1} = filenames(i).name; %listing out our file names 
    load(subj{i})
    reversal_timings = data.reversal_timings;
    [mu, mu2, reversal_trials, reversal_trials_full] = reversal_condition(reversal_timings);
    %block 1
    clear a r rpe
    if contains(data.block_order{1},'pos') 
        alpha = rew_params(i,3);
        beta = rew_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe1 = rpe;
    elseif contains(data.block_order{1},'neg')
        alpha = pun_params(i,3);
        beta = pun_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe1 = rpe;
    else contains(data.block_order{1},'mix')
        alpha = mix_params(i,3);
        beta = mix_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe1 = rpe;
    end
    %block 2
    clear a r rpe
    if contains(data.block_order{2},'pos') 
        alpha = rew_params(i,3);
        beta = rew_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu2, alpha, beta, reversal_trials);
        rpe2 = rpe;
    elseif contains(data.block_order{2},'neg')
        alpha = pun_params(i,3);
        beta = pun_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu2, alpha, beta, reversal_trials);
        rpe2 = rpe;
    else contains(data.block_order{2},'mix')
        alpha = mix_params(i,3);
        beta = mix_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu2, alpha, beta, reversal_trials);
        rpe2 = rpe;
    end
    % block 3
    clear a r rpe
    if contains(data.block_order{3},'pos') 
        alpha = rew_params(i,3);
        beta = rew_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe3 = rpe;
    elseif contains(data.block_order{3},'neg')
        alpha = pun_params(i,3);
        beta = pun_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe3 = rpe;
    else contains(data.block_order{3},'mix')
        alpha = mix_params(i,3);
        beta = mix_params(i,4);
        [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials);
        rpe3 = rpe;
    end
    all_rpes{i} = [rpe1', rpe2', rpe3'];
    rpe_total = [rpe1, rpe2, rpe3]';
    for b = 1:length(useNegative)
        neurons_360_2 = [733, 702];
        clear rpe_total
        rpe_total = [rpe1, rpe2, rpe3]';
        if ismember(useNegative(b), neurons_360_2)
            rpe_total = rpe_total(2:end);
        end
        all_neuron_rpe = vertcat(all_neuron_rpe, rpe_total);
    end
end

% mu = [0.8,0.2];
% reversal_trials = [13,25];
% alpha = all_params(1,3);
% beta = all_params(1,4);
% [a, r, rpe] = simulate_M3RescorlaWagner_v1_ZI(T, mu, alpha, beta, reversal_trials)
%for a = 1:n_subjects
   %rewards block... does it matter?