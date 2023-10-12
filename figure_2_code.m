%% Figure 2
%% A
% Average behavior
filenames = dir('/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/pt_*/behavior/*_behavioral_data.mat');
filenames(11).name = '360_2_behavioral_data_og.mat';
n_subjects = length(filenames);
evr1_action_outcomes = [];

evr1_good_action_outcomes = [];
evr1_bad_action_outcomes = [];
evr1_condition_sequence = [];
for a = 1:n_subjects
    subj{a,1} = filenames(a).name; %listing out our file names 
    load(subj{a})
    reversal_condition = data.reversal_timings;
    [block1, block2, block3] = correct_action(reversal_condition);
    pt_actions = [data.block_one.choices' data.block_two.choices' data.block_three.choices'];
    good_action = [block1 block2 block3];
    good_machine_first = good_action(1);
    bad_machine_first = good_action(15);
    block_order = data.block_order;
    pt_id = data.block_one.participant_id;
    clear conditions
    [conditions] = condition_sequence(block_order, pt_id);
    for i = 1:length(good_action)
        if pt_actions(i) == good_machine_first
            good_action_outcome(i) = 1;
        elseif pt_actions(i) ~= good_machine_first
            good_action_outcome(i) = 0;
        end
    end
    for i = 1:length(good_action)
        if pt_actions(i) == bad_machine_first
            bad_action_outcome(i) = 1;
        elseif pt_actions(i) ~= bad_machine_first
            bad_action_outcome(i) = 0;
        end
    end
    evr1_good_action_outcomes = vertcat(evr1_good_action_outcomes, good_action_outcome);
    evr1_bad_action_outcomes = vertcat(evr1_bad_action_outcomes, bad_action_outcome);
    evr1_condition_sequence = vertcat(evr1_condition_sequence, conditions);
end

avg_good_action = mean(evr1_good_action_outcomes);
good_action_sems = std(evr1_good_action_outcomes)/sqrt(size(evr1_good_action_outcomes,1));
avg_bad_action = mean(evr1_bad_action_outcomes);
bad_action_sems = std(evr1_bad_action_outcomes)/sqrt(size(evr1_bad_action_outcomes,1));
%% plotting
figure('name','average behavior','units','normalized','position',[0.5 0.5 1 0.7])
shadedErrorBar(1:105,avg_good_action, good_action_sems,'lineProps',{'b','markerfacecolor','b'}); hold on
shadedErrorBar(1:105,avg_bad_action, bad_action_sems,'lineProps',{'k','markerfacecolor','m'}); hold on
ylim([-0.01, 1.01])
yticks([0, 0.2, 0.4, 0.6, 0.8 1])
xlabel('Trials')
ylabel('P(choice)')
xlim([0, 105])
xline(12.5,'k--','LineWidth',2)
xline(24.5,'k--','LineWidth',2)
xline(35,'k','LineWidth',4)
xline(47.5,'k--','LineWidth',2)
xline(59.5,'k--','LineWidth',2)
xline(70,'k','LineWidth',4)
xline(82.5,'k--','LineWidth',2)
xline(94.5,'k--','LineWidth',2)
yline(0.5,'k','0.5','LineWidth',2)
legend('','','Reversal Trial','','New Block','')
title("Average Behavior Across Task")
H = gca;
H.LineWidth=2;
H.FontSize = 30;
set(gca, 'box', 'off')
%% saving a
saveas(gcf, '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/figures/9_26 figure 2a.png')
%% B
number_correct = [72 65 72 72 58 77 64 63 68 43 71 67 79];
percent_correct = (number_correct/105)*100;
x_value = ones(1,length(number_correct));
figure('Units','normalized','Position',[0 0 0.25 1])
plot(x_value, percent_correct, 'xb', 'MarkerSize',30, 'LineWidth', 3)
ylim([0, 100])
xticks([])
yticks([0,20,40,60,80,100])
ylabel('% Correct')
yline(50, '--', 'LineWidth', 2)
title(["Correct Machine", "Picked"])
H = gca;
H.LineWidth=2;
H.FontSize = 30;
set(gca, 'box', 'off')
%% saving b
saveas(gcf, '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/figures/9_26 figure 2b.png')
%% C
model_fits = [2,7,4];
figure('Units','normalized','Position',[0 0 0.4 0.75])
b = bar(model_fits,'facecolor','flat','FaceAlpha',0.5, 'EdgeColor','none');
ylim([0, 10])
xlim([0.5 3.5])
%b.FaceColor = 'flat'
barlabels_order = {'Random Model' 'Heuristic Model' 'Rescorla-Wagner Model'};
set(gca,'xticklabel',barlabels_order)
ylabel(['Number of Participants'])
title('Best Model Fit')
b.CData(1,:) = [0.550000 0.710000 0.000000]; %green
b.CData(2,:) = [0.000000 0.480000 0.650000]; %bluish gray
b.CData(3,:) = [0.000000 0.000000 0.000000]; %black
H = gca;
H.LineWidth=2;
H.FontSize = 30;
set(gca, 'box', 'off')
%% saving c
saveas(gcf, '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/figures/9_26 figure 2c.png')
%% D
figure('Units','normalized','Position',[0 0 0.4 0.75])
reward_correct = [27 22 24 25 14 26 19 24 24 21 23 31 29];
punishment_correct = [18 23 21 18 23 25 19 20 21 6 29 13 21];
mixed_correct = [27 20 27 29 21 26 26 19 23 16 19 23 29];
reward_percent = (reward_correct/35)*100;
punishment_percent = (punishment_correct/35)*100;
mixed_percent = (mixed_correct/35)*100;
[h,p] = ttest(punishment_percent,mixed_percent)
sem_reward = std(reward_percent)/sqrt(length(reward_percent));
sem_punishment = std(punishment_percent)/sqrt(length(punishment_percent));
sem_mixed = std(mixed_percent)/sqrt(length(mixed_percent));
block_correct = [mean(reward_percent), mean(punishment_percent), mean(mixed_percent)];
sem_correct = [sem_reward, sem_punishment, sem_mixed];

z = [1:3];
b = bar(z,block_correct,'FaceColor','flat','FaceAlpha',0.5, 'EdgeColor','none'); hold on
er = errorbar(block_correct, sem_correct, 'LineWidth', 1);
er.Color = [0 0 0];
er.LineStyle = 'none';
xlim([0.5 3.5])
ylim([0, 100])
xticks([1:3])
xticklabels({'Reward', 'Punishment', 'Mixed'})
ylabel('% Correct')
yline(50, '--', 'LineWidth', 2)
title(["Correct Machine", "Picked by Block"])
H = gca;
H.LineWidth=2;
H.FontSize = 20;
b.CData(1,:) = [0.550000 0.710000 0.000000]; %green
b.CData(2,:) = [0.000000 0.480000 0.650000]; %bluish gray
b.CData(3,:) = [0.000000 0.000000 0.000000]; %black
H = gca;
H.LineWidth=2;
H.FontSize = 30;
set(gca, 'box', 'off')
%% saving d
saveas(gcf, '/Users/lab/Desktop/Saez Lab/Desktop/DBS Slot Machine Pt/figures/10_4 figure 2d.png')








