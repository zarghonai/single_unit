%% waveform metrics
m = mean ( newSpikesNegative( find(assignedNegative==useNegative(3)),:));
plot(m);
findpeaks(m);
peaks = findpeaks(m);
thresh = mean(m(1:10));
thresh = mean(m(end-10:end));
yline(thresh);
minpeak = min(m);
minpeak_mv = minpeak - thresh;
maxpeak = max(m);
maxpeak_mv = maxpeak - thresh;
%abs_peaks_1 = abs(m_1);
%find(abs_peaks_1 >= thresh);
%to look for the data points-this part you kind of have to do manually and
%look for the longest continuous string of numbers both above and below the
%threshold and compare it to the plot as well to see what matches 
find(m <= thresh);
find(m >= thresh);
%finding the peak to trough 
p2t = find(m == max(m)) - find(m == min(m));