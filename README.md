# Single Unit Analysis
Scripts for the PD DBS single unit analysis.

Folders are labeled according to what part of the pipeline the scripts are required for.

1. Neural folder-contains scripts for:
       a. N1-Cleaning up neural data from Alpha Omega
       b. N2-Running the neural data through OSort
       c. N3-5-Post-processing of neural data that was sorted through OSort to finalize the number of single unit neurons in the recording
       d. N6-N7-Determining the firing rate and waveform properties of the neurons
2. Behavior folder-contains script for:
       a. B1-converting the behavioral JSON file to a mat file
