%% analysis code for Hypothesis1 - retrieving powers and saving to csv files

Participant='ASC_P2_digitised_matched/';
Session='2816551';
path=['/Users/hannahbetts/Documents/PartII_Project/TET_med/' Participant Session '/'];

cd(path)


%load TET dimensions and corresponding alpha data from EEG - at the moment
%need to change for every file name for each session
load alpha.mat;
load beta.mat;
load delta.mat;
load gamma.mat;
load theta.mat;
load _downsampled.mat;

%extract alpha 
Channel_1_alpha = hilbdataalpha(1,:)';
Channel_3_alpha = hilbdataalpha(2,:)';
Channel_4_alpha = hilbdataalpha(3,:)';
Channel_5_alpha = hilbdataalpha(4,:)';
Channel_7_alpha = hilbdataalpha(5,:)';

%extract beta
Channel_1_beta = hilbdatabeta(1,:)';
Channel_3_beta = hilbdatabeta(2,:)';
Channel_4_beta = hilbdatabeta(3,:)';
Channel_5_beta = hilbdatabeta(4,:)';
Channel_7_beta = hilbdatabeta(5,:)';

%extract delta
Channel_1_delta = hilbdatadelta(1,:)';
Channel_3_delta = hilbdatadelta(2,:)';
Channel_4_delta = hilbdatadelta(3,:)';
Channel_5_delta = hilbdatadelta(4,:)';
Channel_7_delta = hilbdatadelta(5,:)';

%extract theta
Channel_1_theta = hilbdatatheta(1,:)';
Channel_3_theta = hilbdatatheta(2,:)';
Channel_4_theta = hilbdatatheta(3,:)';
Channel_5_theta = hilbdatatheta(4,:)';
Channel_7_theta = hilbdatatheta(5,:)';

%extract gamma
Channel_1_gamma = hilbdatagamma(1,:)';
Channel_3_gamma = hilbdatagamma(2,:)';
Channel_4_gamma = hilbdatagamma(3,:)';
Channel_5_gamma = hilbdatagamma(4,:)';
Channel_7_gamma = hilbdatagamma(5,:)';


%extract TET dimensions for the session - remember that HC_P1 has more so
%need to comment out and write new for them
Attention = data_downsampled(:,1);
Body = data_downsampled(:,2);
Boredom = data_downsampled(:,3);
Effort = data_downsampled(:,4);
Metaawareness = data_downsampled(:,5);
Physicaltension = data_downsampled(:,6);
Rumination = data_downsampled(:,7);
Scenarioanxiety = data_downsampled(:,8);
Sensoryseeking = data_downsampled(:,9);
Source = data_downsampled(:,10);
Stress = data_downsampled(:,11);
Wakefulness = data_downsampled(:,12);

%write in a csv file so can be opened in Jasp for analysis
csvwrite(['Channel_1_alpha_' Session '.csv'], Channel_1_alpha);
csvwrite(['Channel_1_beta_' Session '.csv'], Channel_1_beta);
csvwrite(['Channel_1_delta_' Session '.csv'], Channel_1_delta);
csvwrite(['Channel_1_theta_' Session '.csv'], Channel_1_theta);
csvwrite(['Channel_1_gamma_' Session '.csv'], Channel_1_gamma);

%csvwrite(['Channel_3_alpha_' Session '.csv'], Channel_3_alpha);
%csvwrite(['Channel_3_beta_' Session '.csv'], Channel_3_beta);
%csvwrite(['Channel_3_delta_' Session '.csv'], Channel_3_delta);
%csvwrite(['Channel_3_theta_' Session '.csv'], Channel_3_theta);
%csvwrite(['Channel_3_gamma_' Session '.csv'], Channel_3_gamma);

%csvwrite(['Channel_4_alpha_' Session '.csv'], Channel_4_alpha);
%csvwrite(['Channel_4_beta_' Session '.csv'], Channel_4_beta);
%csvwrite(['Channel_4_delta_' Session '.csv'], Channel_4_delta);
%csvwrite(['Channel_4_theta_' Session '.csv'], Channel_4_theta);
%csvwrite(['Channel_4_gamma_' Session '.csv'], Channel_4_gamma);

%csvwrite(['Channel_5_alpha_' Session '.csv'], Channel_5_alpha);
%csvwrite(['Channel_5_beta_' Session '.csv'], Channel_5_beta);
%csvwrite(['Channel_5_delta_' Session '.csv'], Channel_5_delta);
%csvwrite(['Channel_5_theta_' Session '.csv'], Channel_5_theta);
%csvwrite(['Channel_5_gamma_' Session '.csv'], Channel_5_gamma);

%csvwrite(['Channel_7_alpha_' Session '.csv'], Channel_7_alpha);
%csvwrite(['Channel_7_beta_' Session '.csv'], Channel_7_beta);
%csvwrite(['Channel_7_delta_' Session '.csv'], Channel_7_delta);
%csvwrite(['Channel_7_theta_' Session '.csv'], Channel_7_theta);
%csvwrite(['Channel_7_gamma_' Session '.csv'], Channel_7_gamma);


csvwrite(['Attention_' Session '.csv'], Attention);
csvwrite(['Body_' Session '.csv'], Body);
csvwrite(['Boredom_' Session '.csv'], Boredom);
csvwrite(['Effort_' Session '.csv'], Effort);
csvwrite(['Metaawareness_' Session '.csv'], Metaawareness);
csvwrite(['Physicaltension_' Session '.csv'], Physicaltension);
csvwrite(['Scenarioanxiety_' Session '.csv'], Scenarioanxiety);
csvwrite(['Sensoryseeking_' Session '.csv'], Sensoryseeking);
csvwrite(['Source_' Session '.csv'], Sensoryseeking);
csvwrite(['Stress_' Session '.csv'], Stress);
csvwrite(['Wakefulness_' Session '.csv'], Wakefulness);



%% concatenating into a csv 
Participant = 'HC_P3_digitised_matched/';
Session = '2816551';
path = ['/Users/hannahbetts/Documents/PartII_Project/TET_med/' Participant Session '/'];

cd(path)

% make sure the only .csv files in the folder are the ones wanted to export to a dataset on JASP
fileList = dir('*.csv');
allData = {};

for i = 1:length(fileList)
    fprintf('Adding file %s\n', fileList(i).name);
    data = csvread(fileList(i).name);
    
    % pad the data with NaN values if it is shorter than the longest file
    [nRows, nCols] = size(data);
    maxRows = max(cellfun(@(x) size(x, 1), allData));
    if nRows < maxRows
        data = padarray(data, maxRows - nRows, NaN, 'post');
    end
    
    allData{end+1} = data;
end

% concatenate the data vertically
allData = horzcat(allData{:});

%to prevent first row being assigned variable names need to manually add 
%varNames = {'alpha1', 'beta1', 'delta1', 'gamma1', 'theta1','alpha3', 'beta3', 'delta3', 'gamma3', 'theta3', 'alpha4', 'beta4', 'delta4', 'gamma4', 'theta4','alpha5', 'beta5', 'delta5', 'gamma5', 'theta5','alpha7', 'beta7', 'delta7', 'gamma7', 'theta7','Physical Tension', 'Rumination', 'Scenario Anxiety', 'Stress'};
varNames = {'alpha', 'beta', 'delta', 'gamma', 'theta','Physical Tension', 'Rumination', 'Scenario Anxiety', 'Stress'};
%varNames = {'alpha', 'beta', 'delta', 'gamma', 'theta'};
header = sprintf('%s,', varNames{:});
header = header(1:end-1);
fid = fopen([Session '.csv'], 'w');
fprintf(fid, '%s\n', header);
fclose(fid);
dlmwrite([Session '.csv'], allData, '-append', 'delimiter', ',');


%% for HC1 (15 dimensions not 12)

Participant='HC_P1_digitised_matched/';
Session='2665839';
path=['/Users/hannahbetts/Documents/PartII_Project/TET_med/' Participant Session '/'];

cd(path)

format shortG


%load TET dimensions and corresponding alpha data from EEG - at the moment
%need to change for every file name for each session
load alpha.mat;
load beta.mat;
load delta.mat;
load theta.mat;
load gamma.mat;
load _downsampled.mat;

%extract alpha
Channel_1_alpha = hilbdataalpha(1,:)';
Channel_3_alpha = hilbdataalpha(2,:)';
Channel_4_alpha = hilbdataalpha(3,:)';
Channel_5_alpha = hilbdataalpha(4,:)';
Channel_7_alpha = hilbdataalpha(5,:)';

%extract beta
Channel_1_beta = hilbdatabeta(1,:)';
Channel_3_beta = hilbdatabeta(2,:)';
Channel_4_beta = hilbdatabeta(3,:)';
Channel_5_beta = hilbdatabeta(4,:)';
Channel_7_beta = hilbdatabeta(5,:)';

%extract delta
Channel_1_delta = hilbdatadelta(1,:)';
Channel_3_delta = hilbdatadelta(2,:)';
Channel_4_delta = hilbdatadelta(3,:)';
Channel_5_delta = hilbdatadelta(4,:)';
Channel_7_delta = hilbdatadelta(5,:)';

%extract theta
Channel_1_theta = hilbdatatheta(1,:)';
Channel_3_theta = hilbdatatheta(2,:)';
Channel_4_theta = hilbdatatheta(3,:)';
Channel_5_theta = hilbdatatheta(4,:)';
Channel_7_theta = hilbdatatheta(5,:)';

%extract gamma
Channel_1_gamma = hilbdatagamma(1,:)';
Channel_3_gamma = hilbdatagamma(2,:)';
Channel_4_gamma = hilbdatagamma(3,:)';
Channel_5_gamma = hilbdatagamma(4,:)';
Channel_7_gamma = hilbdatagamma(5,:)';


%extract TET dimensions for the session - remember that HC_P1 has more so
%need to comment out and write new for them
Attention = data_downsampled(:,1);
Body = data_downsampled(:,2);
Boredom = data_downsampled(:,3);
Effort = data_downsampled(:,4);
Metaawareness = data_downsampled(:,5);
Physicaltension = data_downsampled(:,6);
Rumination = data_downsampled(:,7);
Scenarioanxiety = data_downsampled(:,8);
Sensoryavoidance = data_downsampled(:,9);
Sensoryseeking = data_downsampled(:,10);
Socialavoidance = data_downsampled(:,11);
Socialseeking = data_downsampled(:,12);
Source = data_downsampled(:,13);
Stress = data_downsampled(:,14);
Wakefulness = data_downsampled(:,15);



%write in a csv file so can be opened in Jasp for analysis
csvwrite(['Channel_1_alpha_' Session '.csv'], Channel_1_alpha);
csvwrite(['Channel_1_beta_' Session '.csv'], Channel_1_beta);
csvwrite(['Channel_1_delta_' Session '.csv'], Channel_1_delta);
csvwrite(['Channel_1_theta_' Session '.csv'], Channel_1_theta);
csvwrite(['Channel_1_gamma_' Session '.csv'], Channel_1_gamma);

%csvwrite(['Channel_3_alpha_' Session '.csv'], Channel_3_alpha);
%csvwrite(['Channel_3_beta_' Session '.csv'], Channel_3_beta);
%csvwrite(['Channel_3_delta_' Session '.csv'], Channel_3_delta);
%csvwrite(['Channel_3_theta_' Session '.csv'], Channel_3_theta);
%csvwrite(['Channel_3_gamma_' Session '.csv'], Channel_3_gamma);

%csvwrite(['Channel_4_alpha_' Session '.csv'], Channel_4_alpha);
%csvwrite(['Channel_4_beta_' Session '.csv'], Channel_4_beta);
%csvwrite(['Channel_4_delta_' Session '.csv'], Channel_4_delta);
%csvwrite(['Channel_4_theta_' Session '.csv'], Channel_4_theta);
%csvwrite(['Channel_4_gamma_' Session '.csv'], Channel_4_gamma);

%csvwrite(['Channel_5_alpha_' Session '.csv'], Channel_5_alpha);
%csvwrite(['Channel_5_beta_' Session '.csv'], Channel_5_beta);
%csvwrite(['Channel_5_delta_' Session '.csv'], Channel_5_delta);
%csvwrite(['Channel_5_theta_' Session '.csv'], Channel_5_theta);
%csvwrite(['Channel_5_gamma_' Session '.csv'], Channel_5_gamma);

%csvwrite(['Channel_7_alpha_' Session '.csv'], Channel_7_alpha);
%csvwrite(['Channel_7_beta_' Session '.csv'], Channel_7_beta);
%csvwrite(['Channel_7_delta_' Session '.csv'], Channel_7_delta);
%csvwrite(['Channel_7_theta_' Session '.csv'], Channel_7_theta);
%csvwrite(['Channel_7_gamma_' Session '.csv'], Channel_7_gamma);


csvwrite(['Physicaltension_' Session '.csv'], Physicaltension);
csvwrite(['Rumination_' Session '.csv'], Rumination);
csvwrite(['Scenarioanxiety_' Session '.csv'], Scenarioanxiety);
csvwrite(['Stress_' Session '.csv'], Stress);



%% with EEG downsampled
path = '/Users/hannahbetts/Documents/PartII_Project/TET_med/ASCP2_new/2835003'
Session = '2835003';
cd(path)

load _alphadownsampled.mat
csvwrite(['alpha' Session '.csv'], downsampled_data.');

%%
load _betadownsampled.mat
csvwrite(['beta' Session '.csv'], downsampled_data.');

%%
load _deltadownsampled.mat
csvwrite(['delta' Session '.csv'], downsampled_data.');
%%
load _thetadownsampled.mat
csvwrite(['theta' Session '.csv'], downsampled_data.');

%% 
load _gammadownsampled.mat
csvwrite(['gamma' Session '.csv'], downsampled_data.');

%% 
Participant = 'ASCP2_new/';
Session = '2835003';
path = ['/Users/hannahbetts/Documents/PartII_Project/TET_med/' Participant Session '/'];

cd(path)

% make sure the only .csv files in the folder are the ones wanted to export to a dataset on JASP
fileList = dir('*.csv');
allData = {};

for i = 1:length(fileList)
    fprintf('Adding file %s\n', fileList(i).name);
    data = csvread(fileList(i).name);
    
    % pad the data with NaN values if it is shorter than the longest file
    [nRows, nCols] = size(data);
    maxRows = max(cellfun(@(x) size(x, 1), allData));
    if nRows < maxRows
        data = padarray(data, maxRows - nRows, NaN, 'post');
    end
    
    allData{end+1} = data;
end

% concatenate the data vertically
allData = horzcat(allData{:});

%to prevent first row being assigned variable names need to manually add 
%varNames = {'alpha1', 'beta1', 'delta1', 'gamma1', 'theta1','alpha3', 'beta3', 'delta3', 'gamma3', 'theta3', 'alpha4', 'beta4', 'delta4', 'gamma4', 'theta4','alpha5', 'beta5', 'delta5', 'gamma5', 'theta5','alpha7', 'beta7', 'delta7', 'gamma7', 'theta7','Physical Tension', 'Rumination', 'Scenario Anxiety', 'Stress'};
varNames = {'Physical Tension', 'Rumination', 'Scenario Anxiety', 'Stress', 'alpha','beta', 'delta', 'gamma', 'theta'};
%varNames = {'alpha', 'beta', 'delta', 'gamma', 'theta'};
header = sprintf('%s,', varNames{:});
header = header(1:end-1);
fid = fopen([Session '.csv'], 'w');
fprintf(fid, '%s\n', header);
fclose(fid);
dlmwrite([Session '.csv'], allData, '-append', 'delimiter', ',');
