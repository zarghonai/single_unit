# Single Unit Analysis
Scripts for the PD DBS single unit analysis.

Folders are labeled according to what part of the pipeline the scripts are required for.

1. Neural:

      a. N1-Cleaning up neural data from Alpha Omega

      b. N2-Running the neural data through OSort

      c. N3-5-Post-processing of neural data that was sorted through OSort to finalize the number of single unit neurons in the recording

      d. Use the merge template excel sheet for N4
      
      e. N6-N7-Determining the firing rate and waveform properties of the neurons
   
3. Behavior:
   
      a. B1-converting the behavioral JSON file to a mat file
   
5. Alignment:

      a. A1-lining up the behavioral and neural data with the timings of the Alpha Omega

6. Modeling:

     a. M1-sets up parameters for modeling according to each block, uses the functions in the modeling file 

     b. M2-calculates RPE

Further analysis:
 All_code_funcs-gets all the data and puts it in an array 
 Regression analysis-does the glm analysis for the expectation period and the feedback period

Sample data:
Behavioral data as well as pre-processed neural data (what we would get after script A1) are in the behav_neural_data file
