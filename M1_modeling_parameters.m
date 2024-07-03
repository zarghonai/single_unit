% do this for every person
% for loop to collect BIC for every person
% take the mean of collected BIC scores
% determine which model has the lowest BIC score across individuals 
filenames = dir('/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_*/behavior/*_behavioral_data.mat');
filenames(11).name = '360_2_behavioral_data_og.mat';
n_subjects=length(filenames); %number of subjects 
n_blocks = 3;
n_trials= 35;
for i=1:n_subjects
    subj{i,1} = filenames(i).name; %listing out our file names 
end
%% for choices by block-getting the choices in order
for agent=1:n_subjects
    load(subj{agent})
    IDs{agent} = subj{agent}(1:5); %having the pt numbers as the ID
    all_outcomes = [data.block_one.outcomes data.block_two.outcomes data.block_three.outcomes];
    all_choices = [data.block_one.choices data.block_two.choices data.block_three.choices];    
    for blocki = 1:n_blocks
        if contains(data.block_order{blocki},'pos') 
           rew_choices = all_choices(:,blocki);
           rew_outcomes = all_outcomes(:,blocki);
        elseif contains(data.block_order{blocki},'neg')
            pun_choices = all_choices(:,blocki);
            pun_outcomes = all_outcomes(:,blocki);
        else data.block_order{blocki}
            mix_choices = all_choices(:,blocki);
            mix_outcomes = all_outcomes(:,blocki);
        end
    end
    ordered_choice = [rew_choices pun_choices mix_choices];
    ordered_rewards = [rew_outcomes pun_outcomes mix_outcomes];
    all_pt_outcomes{agent,1} = ordered_rewards;
    all_pt_choices{agent,1} = ordered_choice;
end
%% getting the parameters by block
for agent = 1:n_subjects
    for b = 1:n_blocks
        for t = 1:n_trials
            if all_pt_choices{agent,1}(t,b) == 0
                choices(t) = 1;
            elseif all_pt_choices{agent,1}(t,b) == 1
                choices(t) = 2;
            end
        end
        outcomes = all_pt_outcomes{agent,1}(:,b);
        [all_XFits, param, BIC, iBEST, BEST] = fit_all_v1_ZI(choices, outcomes);
        all_reversals{agent,1} = data.reversal_timings;
        best_params{agent,b} = [param, iBEST];
        all_params{agent,b} = cell2mat(all_XFits);
        all_bics{agent,b} = BIC;
    end
end
all_bics = cell2mat(all_bics);
all_params = cell2mat(all_params);
rew_params = all_params(:,1:4);
pun_params = all_params(:,5:8);
mix_params = all_params(:,9:12);
rew_bic = all_bics(:,1:3);
pun_bic = all_bics(:,4:6);
mix_bic = all_bics(:,7:9);
