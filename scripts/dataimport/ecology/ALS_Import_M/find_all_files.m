
addpath(genpath('fileseries'));

maindir = '../../../../data/incoming/DEW/wq/WQ_HCHB_Phase1/ALS Results/';

filelist = dir(fullfile(maindir, '**\*RG.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


for i = 1:length(filelist)
    filename =  [ filelist(i).folder,'/',filelist(i).name ] ;
    
    data(i).out = grab_ALS_Data(filename);
    
end



 for i = 1:length(data)
     
     f
     