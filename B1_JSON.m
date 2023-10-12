%converting the behavioral task file to a mat file 
fileName = '/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/behavior/371_1_5_2023@9_41_48.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
data = jsondecode(str); % Using the jsondecode function to parse JSON from string
save('/Users/Lab Member/Desktop/DBS Slot Machine Pt/pt_371/behavior/371_behavioral_data.mat') %save data as mat file