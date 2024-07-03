%% baseline regressiong
da_all = find(all_neuron_type == 1);

cl_neuron = all_neurons(da_all);
cl_baseline = all_normalized_baseline_fr(da_all,1);
cl_previous_action = previous_action(da_all);
cl_previous_reward = previous_reward(da_all);
cl_previous_rpe = previous_rpe(da_all);
cl_previous_reward_outcome = previous_reward_outcome(da_all);
cl_condition = all_conditions(da_all);
VariableNames_1 = {'Z_baseline_fr'; 'neuron'; 'previous_action'; 'previous_reward'; 'previous_reward_outcome'; 'previous_rpe';'condition'};
data_table_1 = table(cl_baseline, cl_neuron, cl_previous_action, cl_previous_reward, cl_previous_reward_outcome, cl_previous_rpe, cl_condition,'VariableNames', VariableNames_1);
modelspec = 'Z_baseline_fr ~ previous_action + previous_reward_outcome + previous_reward + previous_rpe';
mdl2 = fitglm(data_table_1,modelspec,"Distribution","normal")

%% feedback regressiong 
da_all = find(all_neuron_type == 1);
cl_neuron = all_neurons(da_all);
cl_feedback = all_normalized_feedback_fr(da_all);
cl_action = all_data_2(da_all,4);   
cl_reward = all_data_2(da_all,3);
cl_reward_outcome = all_data_2(da_all,13); % change this back!!!
%cl_reward_outcome = new_outcomes(cl);
cl_rpe = all_neuron_rpe(da_all);
VariableNames = {'Z_feedback_fr'; 'neuron'; 'action'; 'reward'; 'reward_outcome'; 'rpe'};
data_table = table(cl_feedback, cl_neuron, cl_action, cl_reward, cl_reward_outcome, cl_rpe, 'VariableNames', VariableNames);
modelspec = 'Z_feedback_fr ~ action + reward + reward_outcome + rpe';
%modelspec = 'Z_feedback_fr ~ action + reward_outcome';
mdl1 = fitglm(data_table,modelspec,"Distribution","normal")
