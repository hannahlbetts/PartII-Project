%% loading the right directory

Directory='/Users/hannahbetts/Documents/PartII_Project/TET_med/';
Participant='HC_P3';
Date='/2810449/';
inputpath=[Directory Participant Date];
outputpath=[Directory Participant '_digitised/'];

%mkdir(outputpath) %comment out once done

cd(inputpath)
files=dir(['*.JPG']);

%load the outputfile if it already exists
outputfile=[outputpath '_dimensionsdata.mat'];

if exist (outputfile)~=0
    load (outputfile);
    zer=find(dimensions(1,:)==0);
    else dimensions = [];
end

%% digitising the meditation graphs - HAND DRAWN / POWERPOINT
n_epochs = 301;
addpath '/Users/hannahbetts/Documents/PartII_Project/AdaptedGraphDigitization-master'

for f=1:length(files)
    try
        %y=digitize_graph(files(f).name,[0:1/(n_epochs-1):1]);
        close all
        dimensions(:,f)=y;
        disp(files(f).name)
    catch
        disp(['couldnt digitise ' files(f).name ', attempting with automatically cropped image'])

        try
            close all
            y=digitize_graph_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
            dimensions(:,f)=y;
            disp(files(f).name)

        catch
            disp (['couldnt digitise ' files(f).name ', attempting again with cropped image'])

            try 
%                 close all
                y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
                dimensions(:,f)=y;
                disp(files(f).name)
            catch
                disp(['couldnt digitise ' files(f).name])
            end
        end
    end
    save(outputfile, 'dimensions');
end

%% digitising meditation, autocrop only - HAND DRAWN / POWERPOINT
n_epochs = 301;
for f= 1:length(files)
    try
        close all
        y=digitize_graph_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
        dimensions(:,f)=y;
        disp(files(f).name)
            
    catch    
            disp (['couldnt digitise ' files(f).name ', attempting again with cropped image'])
    end
    save(outputfile,'dimensions');
end

figure; plot(dimensions(:,f))

%% check if the files were digitised correctly  - HAND DRAWN / POWERPOINT
close all

for f=1:length(files)
    I = imread(files(f).name);
    fig_position = [400 400 1200 300];
    figure('Position', fig_position)

    subplot(1,2,1)
    imshow(I);
    subplot(1,2,2)
    plot(dimensions(:,f));
    ylim([0 1])
    xlim([0 n_epochs]);
    sgtitle(files(f).name);
end
%% now load all the dimensionfiles and concatenate into one  - HAND DRAWN / POWERPOINT
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant='ASC_P1';
inputpath=[Directory Participant '_digitised/'];
outputfile=[Directory Participant 'AllData.mat'];

%mkdir(inputpath);

cd(inputpath)

AllData=[];
files=dir ('*.mat')
for i=1:length(files)
    load(files(i).name)
    %check it's all in correct order
    disp(files(i).name)
    AllData=[AllData; dimensions];
end

save(outputfile,'dimensions');


%% APP DATA y coords


Directory='/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant='ASC_P3';
Session = '040423';
inputpath = [Directory Participant];
cd(inputpath);
%outpath = [outputpath Session] %comment out after first one
outputpath = [Directory Participant '_digitised'];
%mkdir(outpath);

%mkdir(outputpath); %comment out after first one


[num,txt,raw] = xlsread('ASC_P3_040423_TETday.xlsx');
question = num(:,1);
x = num(:,2);
y = num(:,3);

idx = find(question == 10); %change for each question
xq = x(idx);
yq = y(idx);

%removing duplicate data points
[xq_unique, idx_unique] = unique(xq);
yq_unique = yq(idx_unique);


x_interp = linspace(min(xq_unique), max(xq_unique), 301);
y_interp = interp1(xq_unique, yq_unique, x_interp, 'linear');
xlim([0,301]);
scaling_factor = 301 / 4;
x_interpscaled = x_interp * scaling_factor;

plot(x_interpscaled, y_interp)


dimensions = y_interp';
filename = (['physicalpain']);
% Save data matrix to a file
save(fullfile(outputpath, filename), 'dimensions')

%% concatenate into one

Directory = '/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant = 'ASC_P2_digitised';
Session = '301122';
folder = [Directory Participant '/' Session];


files = dir(fullfile(folder, '*.mat'));
data = [];

% Load each matrix and concatenate horizontally
for i = 1:length(files)
    % Load the current matrix
    current_matrix = load(fullfile(folder, files(i).name));
    
    % Extract all fields of the current matrix and concatenate them horizontally
    current_data = cell2mat(struct2cell(current_matrix));
    
    % Concatenate the current data horizontally to the existing data
    data = horzcat(data, current_data);
end

outputpath = [Directory Participant];

dimensions = data;
filename = [Session '_dimensionsdata'];
save(fullfile(outputpath, filename), 'dimensions')



%% Digitising the daily TETs

%load the right directory 
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant='HC_P1';
Date='/020222/';
inputpath=[Directory Participant Date];
outputpath=[Directory Participant '_digitised/'];

%mkdir(outputpath) %comment out once done

cd(inputpath)
files=dir(['*.JPG']);

%load the outputfile if it already exists
outputfile=[outputpath '_dimensionsdata.mat'];

if exist (outputfile)~=0
    load (outputfile);
    zer=find(dimensions(1,:)==0);
    else dimensions = [];
end


n_epochs = 500;
addpath '/Users/hannahbetts/Documents/PartII_Project/AdaptedGraphDigitization-master'

for f=1:length(files)
%    try
%        y=digitize_graph(files(f).name,[0:1/(n_epochs-1):1]);
%       close all
%        dimensions(:,f)=y;
%        disp(files(f).name)
%    catch
%        disp(['couldnt digitise ' files(f).name ', attempting with automatically cropped image'])

        try
            close all
            y=digitize_graph_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
            dimensions(:,f)=y;
            disp(files(f).name)

        catch
            disp (['couldnt digitise ' files(f).name ', attempting again with cropped image'])

            try 
                close all
                y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
                dimensions(:,f)=y;
                disp(files(f).name)
            catch
                disp(['couldnt digitise ' files(f).name])
            end
        end
%    end
    save(outputfile, 'dimensions');
end


%% try with digitise_graph_daily_autocrop
%load the right directory 
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant='HC_P1';
Date='/020222/';
inputpath=[Directory Participant Date];
outputpath=[Directory Participant '_digitised/'];

%mkdir(outputpath) %comment out once done

cd(inputpath)
files=dir(['*.JPG']);

%load the outputfile if it already exists
outputfile=[outputpath '_dimensionsdata.mat'];

if exist (outputfile)~=0
    load (outputfile);
    zer=find(dimensions(1,:)==0);
    else dimensions = [];
end


n_epochs = 500;
addpath '/Users/hannahbetts/Documents/PartII_Project/AdaptedGraphDigitization-master'

for f=1:length(files)
%    try
%        y=digitize_graph(files(f).name,[0:1/(n_epochs-1):1]);
%       close all
%        dimensions(:,f)=y;
%        disp(files(f).name)
%    catch
%        disp(['couldnt digitise ' files(f).name ', attempting with automatically cropped image'])

        try
            close all
            y=digitise_graph_daily_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
            dimensions(:,f)=y;
            disp(files(f).name)

        catch
            disp (['couldnt digitise ' files(f).name ' with autocrop, attempting again with cropped image'])

            try 
                close all
                y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
                dimensions(:,f)=y;
                disp(files(f).name)
            catch
                disp(['couldnt digitise ' files(f).name])
            end
        end
%    end
    save(outputfile, 'dimensions');
end


%% Matching code
%loading the right directory

Directory='/Users/hannahbetts/Documents/PartII_Project/TET_med/';
Participant='HC_P3';
Session='/2814095/';
inputpath=[Directory Participant Session];
outputpath=[Directory Participant '_digitised/'];

%mkdir(outputpath) %comment out once done

cd(inputpath)
%files=dir(['*.JPG']);

%load the outputfile if it already exists
outputfile=[outputpath '_dimensionsdata.mat'];

newpath=[Directory Participant '_digitised_matched/' Session];
newoutputfile = [newpath '_dimensionsmatched.mat'];

if exist (outputfile)~=0
    load (outputfile);
    zer=find(dimensions(1,:)==0);
else dimensions = [];
end


TETfileID = '2835003';



%outputfile = [Directory Participant '/' TETfileID '/Digitised/Matched.mat'];
TETinpath = [Directory 'HC_P3_digitised' '/' [TETfileID '_dimensionsdata.mat']];

try exist (TETinpath)~=0
    load (TETinpath);
    zer=find (dimensions(1,:)==0)
catch
    disp('could not load dimensions');
end

%load the EEG file that contains the correct sessionID
EEGinpath=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' Participant '/7-removechanrej/'];

findfiles=dir([EEGinpath '/*' TETfileID '*.set'])
%if isempty(findfiles)
%continue
%end
EEGfilename=findfiles.name
EEG=[];
EEG=pop_loadset('filename',EEGfilename,'filepath',EEGinpath);

n_epochs=length(EEG.urevent); %number of epochs before rejection
rej_epochs=EEG.rejepoch %vector of rejected epochs

%replace the rejected epochs in the TET file
dimensions(rej_epochs,:)=[];

if length(EEG.epoch)~=size(dimensions,1)
    warning (['The TET and EEG epochs are not the same length in file ' TETfileID])
else
    save(newoutputfile,'dimensions');
end


%%  downsampling the TETs: takes the average of 10 data points (corresponding to 40s)
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



%% for HC1 (15 dimensions, not 12)
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_med/';
Participant='HC_P1';
Session='/2665839/';
inputpath=[Directory Participant Session];
outputpath=[Directory Participant '_digitised/'];

% load data from matrix 'dimensions'
data = dimensions;

% round up number of rows to nearest multiple of 10
nRows = size(data, 1);
nColumnsPadded = ceil(nRows/10)*10;
dataPadded = padarray(data, nColumnsPadded - nRows, NaN, 'post');

% reshape matrix into 10 x (nRowsPadded/10) x 12 matrix
data_reshaped = reshape(dataPadded, [10, nColumnsPadded/10, 15]);
data_reshaped = permute(data_reshaped, [1 3 2]); % swap 2nd and 3rd dimensions
data_reshaped = reshape(data_reshaped, [10, 15*(nColumnsPadded/10)]);

% take average of each row
data_downsampled = nanmean(data_reshaped, 1);
data_downsampled = reshape(data_downsampled, [15, nColumnsPadded/10])';

newpath=[Directory Participant '_digitised_matched/' Session];
newdimensions = [newpath '_downsampled.mat'];
save(newdimensions, 'data_downsampled');