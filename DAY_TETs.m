
Directory='/Users/hannahbetts/Documents/PartII_Project/TET_day/';
Participant='HC_P3';
Date='110222';
inputpath=[Directory Participant '/' Date '/'];
outputpath=[Directory Participant '_digitised/' Date];
x_points = [0:1/499:1];

addpath('/Users/hannahbetts/Documents/PartII_Project/AdaptedGraphDigitization-master/')

%change the 00 number for each individual image
path_to_image = ['/Users/hannahbetts/Documents/PartII_Project/TET_day/HC_P1/110222/110222_.009.jpeg']

cd(inputpath);

if contains(path_to_image, '.001.jpeg')
        output_file_name = [Date '_metaawareness_dimensionsdata.mat'];
elseif contains(path_to_image, '.002.jpeg')
        output_file_name = [Date '_wakefulness_dimensionsdata.mat'];
elseif contains(path_to_image, '.003.jpeg')
        output_file_name = [Date '_boredom_dimensionsdata.mat'];
elseif contains(path_to_image, '.004.jpeg')
        output_file_name = [Date '_sensoryseeking_dimensionsdata.mat'];
elseif contains(path_to_image, '.005.jpeg')
        output_file_name = [Date '_socialavoidance_dimensionsdata.mat'];
elseif contains(path_to_image, '.006.jpeg')
        output_file_name = [Date '_physicaltension_dimensionsdata.mat'];
elseif contains(path_to_image, '.007.jpeg')
        output_file_name = [Date '_scenarioanxiety_dimensionsdata.mat'];
elseif contains(path_to_image, '.008.jpeg')
        output_file_name = [Date '_rumination_dimensionsdata.mat'];
elseif contains(path_to_image, '.009.jpeg')
        output_file_name = [Date '_stress_dimensionsdata.mat'];
elseif contains(path_to_image, '.010.jpeg')
        output_file_name = [Date '_pain_dimensionsdata.mat'];
end

%run function
y_points = digitise_graph_autocrop_JS(path_to_image, x_points);


%save y_points

filename = output_file_name;
save(fullfile(outputpath, filename), 'y_points')
