function [zcontinuous_fr_for_stats, tVec2, zscored_continuous_fr, zscored_stats_plot, psth trialspx, tVec, continuous_fr, continuous_fr_for_stats] = mpsth_SEQ_slots(spxtimes,trigtimes,pretime,varargin)
% [psth trialspx] = mpsth(spxtimes,trigtimes,varargin)
% function generates a peri-stimulus time histogram (psth) with time base in column 1 and histogram in column 2
% in addition, function returns spike timestamps relative to trigger times
% IMPORTANT: all timestamp inputs (spxtimes, trigtimes) must be seconds and will be converted to ms in the script!
%
% MANDATORY INPUTS
% spxtimes      vector with timestamps (seconds) of spike events
% trigtimes     vector with timestamps (seconds) of trigger events
%
% OPTIONAL INPUTS
% pre           time before trigger to include in psth (default 1000 ms)
% post          time after trigger to include in psth (default 1000 ms)
% fr            if '1', normalizes to firing rate (Hz); if '0', does nothing (default)
% tb            if '1', function returns timebase in the first column (default); if '0', no time base - output is a single column
% binsz         bin size of psth (default: 1 ms)
% chart         if '0' (default), no plot will be generated
%               if '1', a PSTH will be generated
%               if '2', a PSTH together with a raster plot will be generated
%
% EXAMPLES
% psth = mpsth(chan9.timings(chan9.markers(:,1)==1),chan32.timings(chan32.markers(:,1)==105))
%               generates a psth (time base in first column, psth in second column) from marker 1 in channel 9 for event 105
%
% [psth trialspx] = mpsth(chan9.timings(chan9.markers(:,1)==1),chan32.timings(chan32.markers(:,1)==105),'pre',3000,'post',3000,'fr',1);
%               same, but PSTH extends from -3 to +3 s around event (rather than -1 to +1 s, which is the default)
%               scales to firing rate ('fr' set to 1)
%
% HISTORY
% sep 12, 2013   minor bug detected; in preallocation, it previously read "psth = zeros(pre/binsz+post/binsz,2)", which
%                could result in mismatches of matrix size
% july 30, 2013  minor changes to comments above
% feb 23, 2012   changed conversion of spike counts into firing rate -> bug eliminated
% august 12      changed argument name 'ntb' to 'tb' for consistency
% april 18       debugged bin size argument, added optional raster display
% april 16       added bin size as argument
% feb 16, 2011   added examples
%
% by Maik C. Stüttgen, Feb 2011
%% define and override defaults
spxtimes  = spxtimes*1000;
trigtimes = trigtimes*1000;
%pre   = 3000;
pre = pretime;
post  = 1000;
fr    = 0;
tb    = 1;
binsz = 50;
chart = 2; % 3 for model free; 4 for model based; 5 for neat model based for final example unit figure 
if nargin
  for i=1:2:size(varargin,2)
    switch varargin{i}
      case 'pre'
        pre = varargin{i+1};
      case 'post'
        post = varargin{i+1};
      case 'fr'
        fr = varargin{i+1};
      case 'tb'
        tb = varargin{i+1};
      case 'binsz'
        binsz = varargin{i+1};
      case 'chart'
        chart = varargin{i+1};
      otherwise
        errordlg('unknown argument')
    end
  end
else
end
%% pre-allocate for speed
if binsz>1
  psth = zeros(ceil(pre/binsz+post/binsz),2);         % one extra chan for timebase
  psth (:,1) = (-1*pre:binsz:post-1);           % time base
elseif binsz==1
  % in this case, pre+post+1 bins are generate (ranging from pre:1:post)
  psth = zeros(pre+post+1,2);
  psth (:,1) = (-1*pre:1:post);       % time base
end
%% construct psth & trialspx
trialspx = cell(numel(trigtimes),1);
zcontinuous_fr = zeros(numel(trigtimes), pre+post);

zcontinuous_fr_for_stats = zeros(numel(trigtimes), (pre+post)/10); % sub-sample time to minimize MC corrections

% convolve the session-wide spike train to get a session-long continuous FR
% without edge effects for each trial 
spikeTimes = round(spxtimes); % all the spike times
fsample = 1; %% just changed to 1 from 1000 in denominator
dt = 1/fsample; % this is a 1 ms for turning the spike times into a spike train
tVec = 0:dt:trigtimes(end) + 2*post;  % this is the time bins
tVec2 = -pre:dt:post-dt;
spikeTrain = histc(spikeTimes, tVec); % the spike Train [0,1,0,1….]

% create a gaussian kernel to smooth our point process 
N = 100;
sds = 3;
gaussian_kernel = gausswin(N,sds);

continuous_fr_all = filtfilt(gaussian_kernel,1,spikeTrain)/(1000/N); %%% when you take your average continuous firing rate for a trial, it should be similar to number of spikes over that time window / 2 seconds
zscored_continuous_fr_all = zscore(continuous_fr_all);

for i = 1:numel(trigtimes)
  clear spikes
  spikes = spxtimes - trigtimes(i);                           % all spikes relative to current trigtime
  trialspx{i} = round(spikes(spikes>=-pre & spikes<=post));   % spikes close to current trigtime

  % find the time vector points near the triggers, and use these to cut up
  % the continuous firing rate (just like we did for finding spikes pre
  % and post trigger) 

  tVec_relative_to_trig = tVec - trigtimes(i);                           % all spikes relative to current trigtime
  
  zcont_fr_around_trig = zscored_continuous_fr_all(tVec_relative_to_trig>=-pre & tVec_relative_to_trig<=post);

  zcontinuous_fr(i, :) = zcont_fr_around_trig; %%% when you take your average continuous firing rate for a trial, it should be similar to number of spikes over that time window / 2 seconds
  zcontinuous_fr_for_stats(i,:) = decimate(zcont_fr_around_trig, 10); % subsample by a factor of 100

  if binsz==1 % just to make sure...
    psth(trialspx{i}+pre+1,2) = psth(trialspx{i}+pre+1,2)+1;    % markers just add up
    % previous line works fine as long as not more than one spike occurs in the same ms bin
    % in the same trial - else it's omitted
  elseif binsz>1
    try
      for j = 1:numel(trialspx{i})
        psth(floor(trialspx{i}(j)/binsz+pre/binsz+1),2) = psth(floor(trialspx{i}(j)/binsz+pre/binsz+1),2)+1;
      end
    end
  end
end
%% normalize to firing rate if desired
if fr==1
  psth (:,2) = (1/binsz)*1000*psth(:,2)/numel(trigtimes);
end
%% remove time base
if tb==0
  psth(:,1) = [];
end
%% plot
% if chart==1
%   figure('name','peri-stimulus time histogram','units','normalized','position',[0.3 0.4 0.4 0.2])
%   bar(psth(:,1)+binsz,psth(:,2),'k','BarWidth',1)
%   axis([min(psth(:,1))-10 max(psth(:,1))+10 0 max(psth(:,2))+1])
%   xlabel('peri-stimulus time'),ylabel(['counts per ' num2str(binsz) 'ms bin / fr (Hz)'])
% elseif chart==2
%   figure('name','peri-stimulus time histogram','units','normalized','position',[0.6 0.6 0.8 0.6])
%   
%   subplot(412)  %% the bottom plot
%   bar(psth(:,1)+binsz,psth(:,2),'k','BarWidth',1)
%   axis([min(psth(:,1))-10 max(psth(:,1))+10 0 max(psth(:,2))+1])
%   ylabel(['counts per ' num2str(binsz) 'ms bin / fr (Hz)'])
%   
%   subplot(413) %%% PLOT CONTINUOUS FR
%   plot(tVec2, mean(zcontinuous_fr, 1))
%   ylabel(['firing rate (Hz)'])
% 
%   subplot(414) %%% Z-SCORE CONTINUOUS FR
%   plot(tVec2, (mean(zcontinuous_fr, 1)))
%   ylabel(['z-scored firing rate (Hz)'])
%   xlabel('peri-stimulus time (ms)')
% 
%   zscored_continuous_fr = mean(zcontinuous_fr, 1);
% %   zscored_continuous_fr_all = zscore(zcontinuous_fr, 1);
% %   zscored_continuous_stats = (zcontinuous_fr_for_stats, 1);
%   zscored_stats_plot = mean(zcontinuous_fr_for_stats, 1);
% 
%   % remember to use the debugger at line 159 to save the firing rate and tVec bins! for
%   % example:
%   % save('/Users/ariannaneal/Mirror/UG_OR_Ephys/UG1/data/pt0272_2/neural/rasters_50/splitreveal_fr/cluster252_splitreveal_zscored_continuousfr.mat', "tVec", "zscored_continuous_fr")
% 
%   % plot(tVec, continuous_fr(2, :)) for just trial 2 across full 2000 ms
%   % time period
%   % to double check this plot, set degbugging at line 88 and then open
%   % variable trialspx, look at row 2 for number of spikes!
%   % example_zscored = plot(tVec, zscore(continuous_fr(2, :))) for z scored
%   % version of single trial?
% 
% 
%   subplot(411)  %% the top plot
%   [rastmat timevec] = mraster(trialspx,pre,post);
%   for i = 1:numel(trialspx)
%     plot(timevec,rastmat(i,:)*i,'Color','k','Marker','.','MarkerSize',1,'LineStyle','none'),hold on
%   end
%   axis([-pre+10 post+10 0.5 numel(trialspx)+0.5])
%   xlabel('time (ms)'),ylabel('trials')
%   xlabel('peri-stimulus time (ms)')
%   
% end
% % save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_369/z scored fr/fr_wins_loss/cl404_loss_reward1_zcscore_new.mat', "tVec2", "zscored_continuous_fr", "zscored_stats_plot", "zcontinuous_fr_for_stats")
% % save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_360_2/z scored fr/cl733_outcome_pos10_zcscore_new.mat', "tVec2", "zscored_continuous_fr", "zscored_stats_plot", "zcontinuous_fr_for_stats")
% 
