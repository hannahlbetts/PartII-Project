%%  downsampling the TETs
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_med/';
Participant='HC_P3';
Session='/2816551/';
inputpath=[Directory Participant Session];
outputpath=[Directory Participant '_digitised/'];

% load data from matrix 'dimensions'
data = dimensions;

% round up number of rows to nearest multiple of 10
nRows = size(data, 1);
nColumnsPadded = ceil(nRows/10)*10;
dataPadded = padarray(data, nColumnsPadded - nRows, NaN, 'post');

% reshape matrix into 10 x (nRowsPadded/10) x 12 matrix
data_reshaped = reshape(dataPadded, [10, nColumnsPadded/10, 12]);
data_reshaped = permute(data_reshaped, [1 3 2]); % swap 2nd and 3rd dimensions
data_reshaped = reshape(data_reshaped, [10, 12*(nColumnsPadded/10)]);

% take average of each row
data_downsampled = nanmean(data_reshaped, 1);
data_downsampled = reshape(data_downsampled, [12, nColumnsPadded/10])';

newpath=[Directory Participant '_digitised_matched/' Session];
newdimensions = [newpath '_downsampled.mat'];
save(newdimensions, 'data_downsampled');

%% downsampling the EEG data
path = '/Users/hannahbetts/Documents/PartII_Project/TET_med/ASCP2_new/2835003'
Session = '2835003';
cd(path)

%alpha
load _alphadownsampled.mat
csvwrite(['alpha' Session '.csv'], downsampled_data.');

%beta
load _betadownsampled.mat
csvwrite(['beta' Session '.csv'], downsampled_data.');

%delta
load _deltadownsampled.mat
csvwrite(['delta' Session '.csv'], downsampled_data.');

%theta
load _thetadownsampled.mat
csvwrite(['theta' Session '.csv'], downsampled_data.');

%gamma
load _gammadownsampled.mat
csvwrite(['gamma' Session '.csv'], downsampled_data.');

%% concatenating
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
