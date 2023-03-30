function hilbdatadelta=dreemhilbertdelta(inpath, outpath,freqband)
if freqband=='delta'
    freqbin=[0.5:0.5:4]; 
elseif freqband=='alpha'
    freqbin=[8:0.5:13];
elseif freqband=='beta'
    freqbin=[16:0.5:31];
elseif freqband=='theta'
    freqbin=[4:0.5:7];
elseif freqband=='gamma'
    freqbin=[31:0.5:50];
else 
    disp('not a valid frequency band')
end
cd (inpath)
files=dir('*.set')
mkdir(outpath)
for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    newStr = erase(name,'_hp_4sec_labelled_rej_epoch');
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    hilbdatadelta=runhilbert(EEG,freqbin);
    hilbdatadelta = abs(hilbdatadelta).^2; %kills the imaginary part to give power
    SqueezeFrequencies=squeeze(mean(hilbdatadelta)); % averages across the  frequency bin
    hilbdatadelta=squeeze(mean(SqueezeFrequencies,2)); %Averages across the 1000 seconds in the epoch
    newname=[outpath '/' newStr '_hilbdata_' freqband ];
    save(newname,'hilbdatadelta')
end
end
