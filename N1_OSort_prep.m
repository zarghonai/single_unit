%% STEPS FOR OSORT ANALYSIS
% getting the data ready to load into matlab 
% use whichever section is relevant ie if you have one file or multiple
% files
%% Getting data ready for OSort with only one mat file
% load the data first
load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_343'/LT1D-2.400F0002.mat CSPK_01 CSPK_01_KHz
% set the data up the correct way 
data = CSPK_01;
data = double(data);
% save the data
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/rawData/chan1.mat','data','-v7.3') %add your correct path with correct file name 
% file name should be chan_XXX

%% Merge all the mat files *THIS IS ONLY IF YOU HAVE MORE THAN ONE MAT FILE
%label the files just so we don't get confused
%expand to as many files as you have 
file1 = 'RT2D-0.719F0001';
file2 = 'RT2D-0.719F0002';

% load relevant data
load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_326/RT2D-0.719F0001.mat' CSPK_01
CSPK_01_file1 = CSPK_01;

load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_326/RT2D-0.719F0002.mat' CSPK_01
CSPK_01_file2 = CSPK_01;

load '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_326/RT2D-0.719F0001.mat' CSPK_01_KHz

clear CSPK_01

% concantenate
CSPK_01 = [CSPK_01_file1 CSPK_01_file2];

%% Get data in the right format for OSort
%correctly label data
data = CSPK_01;
data = double(data);

%% Save file in correct format
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_326/rawData/chan1.mat','data','-v7.3') %add your correct path with correct file name 
%file name should be pt_XXX 

