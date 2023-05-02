%each discrete data point in its own file downloaded from Dreem interface
%refer to Xcel sheet (log of data colelction) to check time and dates and
%coordinate file grids

eeglab

%change for each participant, and for each trial to be correct for
%directory and file path

participant='HC_P2';
path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant '/'];
cd(path)

%make directories, where elements will be saved as convert things
%must do for every trial, in each trial folder
mkdir('1-matfiles');
mkdir('2-setfiles');
mkdir('3-cutfiles');
mkdir('4-epoch4secs');

%convert those.h5 files to .mat files for every trial
%this uses h5tomat code

[data,start_time]=h5tomat(path);

%create set file for analysis
mattoeeg(path);


%highpass reduces drift 
hp=1;
dreem_highpass(path,hp);

%use dreemlength to check how long the EEG session was
%rec_length=dreemlength(path,participant);
%rec_length(2,:)=rec_length(1,:)/250;
%rec_length(3,:)=rec_length(2,:)/60;

%set epochs
inpath=[path '/3-cutfiles/'];
outpath=[path '/4-epoch4secs/'];

%this will give an epoch of 4 seconds, can change
epoch_length=4;
dreem_8secs(inpath,outpath,epoch_length);

%% labelling files to correct start and end location
%to cut manually, open eeglab > edit > selectdata by epoch or time then
%save file into a folder called 5-cut
%load dataset from 4s epochs

participant='HC_P2';
path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant];
cd(path);

mkdir('5-labelled');
mkdir('5b-cut')
mkdir('6-rej_epoch')
mkdir('6-removechan');

i=44;

newlength=301; %BASED ON 20 MINUTES FOR PILOT (300 epochs)
inpath=[path '/4-epoch4secs/'];
outpath=[path '/5-labelled/'];

EEG=cut20minutes(inpath,outpath,i,newlength); 


%% cutting each file

participant='HC_P2';
path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant];
cd(path);
folder='/5-labelled/';
inpath=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant folder];
outfolder = ['/5b-cut/'];
outpath = ['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant outfolder];

%change for each EEG file being cut
name = ['HC_P2_240922_2799528_EEG_hp_4sec_labelled'];

EEG = pop_loadset();
event_type = 'Med';
epoch_length = [0 4];
EEG_epochs = pop_epoch(EEG, {event_type}, epoch_length);
pop_saveset(EEG_epochs, 'filename', [name '_cut.set'], 'filepath', outpath);

%% remove channels - often have to manually do
participant='HC_P2';
path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant];
cd(path);
folder='/5b-cut/';

inpath=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant folder];

%change for each EEG file being edited
name=['HC_P2_050922_2790316_EEG_cut'];

filename=[name '.set'];
[pathstr,name,ext] = fileparts([inpath filename]);
EEG=[];
EEG = pop_loadset('filename',filename,'filepath',inpath);

eeglab

%check data again in eeglab and select the channels to be removed
chan=[]; %edit based on which are faulty
EEG.data(chan,:,:)=0;
eeglab redraw

outfolder = ['/6-removechan/']
outpath = ['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant outfolder];

EEG=pop_saveset(EEG, 'filename',[name '_rmchan.set'],'filepath',outpath);

%% clean data by rejecting epochs
participant='HC_P2';
path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant];
cd(path);
name = 'HC_P2_240922_2799528_EEG_hp_4sec_labelled_cut' %only need to do this
%if have not got name defined in workspace after removing channels

%eeglab %load correct file if not working straight from channels, otherwise 
% comment out 


opts=[];
opts.reject = 1; opts.recon = 0;
opts.threshold = 1; opts.slope = 0;

input_path=[path '/5b-cut/']; %need to figure out why this is only working
%for the /5-cut/ files, not the removed channel files

%mkdir('7-removechanrej')
outfolder =['/7-removechanrej/'];
output_path=[path outfolder];

EEG = pop_loadset('filename',[name '.set'],'filepath',input_path)

addpath '/Users/hannahbetts/Documents/PartII_Project/DreemEEG/HC_P2'


[EEG]=preprocess_manageBadTrials(EEG,opts)

%to save a record of which epochs rejected 
%['ep_' name]=(EEG.rejepoch)'
%save(['ep_' name], output_path)

[EEG]=pop_saveset(EEG, 'filename',[name '_rej_epoch.set'],'filepath', output_path);

eeglab redraw;
EEG.setname;


%% running hilbert

participant = 'HC_P2';
path=['/Users/hannahbetts/Documents/PartII_project/DreemEEG/' participant '/'];
cd(path);

mkdir('8-alphadata');

inpath=[path '7-removechanrej'];
outpath=[path '8-alphadata'];

%dreemhilbert calls runhilbert, third input is the desired frequency band
%can choose from alpha, beta, theta, delta
hilbdata = dreemhilbert(inpath,outpath,'alpha');



%% calculate the frontal alpha asymmetry FAA
eeglab
ParticipantList={'ASC_P1'};

for p=1:length(ParticipantList)
    
    participant=ParticipantList{p};
    path=['/Users/hannahbetts/Documents/PartII_Project/DreemEEG/' participant '/'];;
    
    
    cd (path)
    
    mkdir ('10-faadata')
    % inpath=[path '7-med/'];
    inpath=[path '7-removechanrej']
    outpath=[path '10-faadata/']
    cd (inpath)
    files=dir('*.set')
    
    for i=1:length(files)
        filename=files(i).name;
        [pathstr,name,ext] = fileparts([inpath filename]);
        EEG=[];
        EEG = pop_loadset('filename',filename,'filepath',inpath);
       
        editname=erase(name,'_cut_4sec_rej_epoch');
        newname=erase(editname,'_rmchan_rej_epoch');
        
     
        try
            faa=dreem_faa(EEG);
            save([outpath newname '_faadata'],'faa')
        catch
            disp(['could not compute faa for ' newname])
        end
        
    end
end

%% dreem_highpass

function data = dreem_highpass(path,hp);

inpath=[path '/2-setfiles/'];
outpath=[path '/3-cutfiles/'];

cd (inpath);
files=dir('*.set');

for i=1:length(files);
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename]);
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    EEG = pop_eegfiltnew(EEG, [], hp, [], true, [], 0);

    EEG = pop_saveset( EEG, 'filename',[name '_hp.set'],'filepath', outpath);

end
end

%% dreem_8secs

function data=dreem_8secs(inpath,outpath,epoch_length)


cd (inpath)
files=dir('*.set')

for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    
    EEG = eeg_regepochs(EEG, 'recurrence',epoch_length,'limits',[0 epoch_length],'extractepochs','on');

    EEG = pop_saveset( EEG, 'filename',[name '_' num2str(epoch_length) 'sec.set'],'filepath', outpath);

end

end

