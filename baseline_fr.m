function [stats_plot] = baseline_fr(spxtimes,trigtimes,pretime,varargin)
%% idk what i'm doing 
spxtimes  = spxtimes*1000;
trigtimes = trigtimes*1000;
%pre   = 3000;
pre = pretime;
post  = 0;
%post = posttime;
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
continuous_fr = zeros(numel(trigtimes), pre+post);

continuous_fr_for_stats = zeros(numel(trigtimes), ceil((pre+post)/10)); % sub-sample time to minimize MC corrections

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
%zscored_continuous_fr_all = zscore(continuous_fr_all);

for i = 1:numel(trigtimes)
  clear spikes
  spikes = spxtimes - trigtimes(i);                           % all spikes relative to current trigtime
  trialspx{i} = round(spikes(spikes>=-pre & spikes<=post));   % spikes close to current trigtime

  % find the time vector points near the triggers, and use these to cut up
  % the continuous firing rate (just like we did for finding spikes pre
  % and post trigger) 

  tVec_relative_to_trig = tVec - trigtimes(i);                           % all spikes relative to current trigtime
  
  cont_fr_around_trig = continuous_fr_all(tVec_relative_to_trig>=-pre & tVec_relative_to_trig<=post);

  continuous_fr(i, :) = cont_fr_around_trig; %%% when you take your average continuous firing rate for a trial, it should be similar to number of spikes over that time window / 2 seconds
  %continuous_fr_for_stats(i,:) = decimate(cont_fr_around_trig, 10); % subsample by a factor of 100
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
 
%stats_plot = mean(continuous_fr_for_stats, 1);
stats_plot = mean(continuous_fr, 1);