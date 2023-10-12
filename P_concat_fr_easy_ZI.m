%the * indicates anything variable and then write whatever specifics you
%need
%i have 2 line shere for filename, but I run them one at a time based on
%what i need because i have different file types saved in different folders
%and it's easier than changing it each time 
%make sure all the files are added to path in order for them to be loaded
%in 
%% if you have multiple files and need to average 
filenames = dir('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_*/firing rate graphs/manual/reward/cl*_reward*_GABA_mixed.mat')
filenames = dir('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_*/fr_wins_loss/mat files/reward/cl*_reward*_loss*_GABA_mixed.mat')

clear zscores 

for i = 1:length(filenames)
    load(filenames(i).name, '-mat')
    zscores(i,:) = zscored_continuous_fr_avg;
end

%change your variable name accordingly 
cl880_wins_overall = mean(zscores);
cl880_wins_allzscores = zscored_continuous_fr;

%% if you just have one file and don't need to average
load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_334/z scored fr/fr_wins_loss/overall'/cl1626_loss_zcscore_2.mat
cl1626_loss_overall = zscored_continuous_fr;
cl1626_loss_allzscores = zscored_continuous_fr_all;
cl1626_loss_zscores_stats = zscored_continuous_stats;
for i = 1:20
    cl1626_loss_plotstats(i) = mean(zscored_continuous_stats(i,:));
end

%% plotting
%this is for comparison-change accordingly
%i wrote out the legend so change that accordingly too 
figure('name','peri-stimulus group firing rate','units','normalized','position',[0.6 0.6 0.8 0.6])
patch([tVec200(clusters{1}+100) fliplr(tVec200(clusters{1}+100))], [cl1571_mix_win_plot(clusters{1}) fliplr(cl1571_mix_loss_plot(clusters{1}))], 'k', 'FaceAlpha', .3); hold on
plot(tVec200(101:200), mean(cl1571_mix_win_plot, 1), 'r', 'LineWidth',3); hold on 
plot(tVec200(101:200), mean(cl1571_mix_loss_plot, 1), 'b', 'LineWidth',3); hold on
xline(0)
yline(0)
%ylim([-4 4])
ylabel(['z-scored firing rate (Hz)'])
xlabel('time (ms)')
xlabel('peri-stimulus time (ms)')
title("Peri-Stimulus Group Firing Rate")
legend('p = 0.0020', 'Cl 1571 Mixed Wins','Cl 1571 Mixed Loss')%, 'Cl 1158 Negative RPE', 'DA Mixed Block Win of 50+')

saveas(gcf, '/Users/Lab Member/Desktop/DBS Slot Machine Pt/peristimulus graphs/all neurons/peristimulus fr cl 1571 mixed wins vs loss.png')
saveas(gcf, '/Users/Lab Member/Desktop/DBS Slot Machine Pt/peristimulus graphs/new group level/peristimulus group fr DA outcomes.png')

%at the very end if you have to clear out your workspace and do something
%else just save all your variables to a mat file so you don't have to redo
%them all 
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/plotting stats mat files/DA win magnitude spike stuff.mat')
%save individual pt data
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_323/pt_323_rpe_plotting_stats_data.mat')

