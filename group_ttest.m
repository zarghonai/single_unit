%% group level firing rate
% getting data together
% outcome 10 
outcome_10 = [];
outcome_10_spikes = [];
for a = 1:length(DA_neurons)
    y = DA_neurons(a);
    clear xx
    xx = [];
    abc = [];
    spikes3 = [];
    for i = 1:length(all_data_2(:,1))
        %if all_data_2(i,7) == y && all_data_2(i,13) == 10
        if all_data_2(i,7) == y && previous_reward_outcome(i) == 10
            x = all_data_2(i,1);
            %x = all_no_z_baseline_fr(i);
            abc = vertcat(abc,i);
            xx = vertcat(xx,x);
            spikes = cell2mat(all_spikes(i));
            spikes1 = find(spikes < 0);
            spikes2 = numel(spikes1);
            spikes3 = vertcat(spikes3, spikes2);
        end
    end
    avg_10_spikes = mean(spikes3);
    avg_10 = mean(xx);
    outcome_10 = vertcat(outcome_10, avg_10);
    outcome_10_spikes = vertcat(outcome_10_spikes, avg_10_spikes);
end
sem_outcome_10 = std((outcome_10/3))/sqrt(length(outcome_10));

% outcome 0
outcome_0 = [];
outcome_0_spikes = [];
for a = 1:length(DA_neurons)
    y = DA_neurons(a);
    clear xx
    xx = [];
    abc = [];
    spikes3 = [];
    for i = 1:length(all_data_2(:,1))
        %if all_data_2(i,7) == y && all_data_2(i,13) == 10
        if all_data_2(i,7) == y && previous_reward_outcome(i) == 0
            x = all_data_2(i,1);
            %x = all_no_z_baseline_fr(i);
            abc = vertcat(abc,i);
            xx = vertcat(xx,x);
            spikes = cell2mat(all_spikes(i));
            spikes1 = find(spikes < 0);
            spikes2 = numel(spikes1);
            spikes3 = vertcat(spikes3, spikes2);
        end
    end
    avg_0_spikes = mean(spikes3);
    avg_0 = mean(xx);
    outcome_0 = vertcat(outcome_0, avg_0);
    outcome_0_spikes = vertcat(outcome_0_spikes, avg_0_spikes);
end
sem_outcome_0 = std((outcome_0/3))/sqrt(length(outcome_0));

% outcome -10
outcome_neg10 = [];
outcome_neg10_spikes = [];
for a = 1:length(DA_neurons)
    y = DA_neurons(a);
    clear xx
    xx = [];
    abc = [];
    spikes3 = [];
    for i = 1:length(all_data_2(:,1))
        %if all_data_2(i,7) == y && all_data_2(i,13) == 10
        if all_data_2(i,7) == y && previous_reward_outcome(i) == -10
            x = all_data_2(i,1);
            %x = all_no_z_baseline_fr(i);
            abc = vertcat(abc,i);
            xx = vertcat(xx,x);
            spikes = cell2mat(all_spikes(i));
            spikes1 = find(spikes < 0);
            spikes2 = numel(spikes1);
            spikes3 = vertcat(spikes3, spikes2);
        end
    end
    avg_neg10_spikes = mean(spikes3);
    avg_neg10 = mean(xx);
    outcome_neg10 = vertcat(outcome_neg10, avg_neg10);
    outcome_neg10_spikes = vertcat(outcome_neg10_spikes, avg_neg10_spikes);
end
sem_outcome_neg10 = std((outcome_neg10/3))/sqrt(length(outcome_neg10));
%% ttests
[h,p,ci,stats] = ttest(outcome_neg10,outcome_0,'tail','left')
[h,p,ci,stats] = ttest(outcome_neg10,outcome_10,'tail','left')
[h,p,ci,stats] = ttest(outcome_10,outcome_0,'tail','left')