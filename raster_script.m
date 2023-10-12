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
