
clear all; close all;

addpath(genpath('fileseries'));

maindir = '../../../../data/incoming/DEW/wq/WQ_HCHB_Phase1/AWQC Results/';

filelist = dir(fullfile(maindir, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen('AWQC_Data.csv','wt');

fprintf(fid,'File Name,File Path,Site Name,Var Name,Units,Date,Val\n');

fclose(fid)

for i = 1:length(filelist)
    filename =  [ filelist(i).folder,'/',filelist(i).name ] ;
    
    
    grab_AWQC_Data(filelist(i));
    

end

                    
                    
                    
            
            
        
        
        




%  for i = 1:length(data)
%      
%      f
     