
clear all; close all;

addpath(genpath('fileseries'));

maindir = '../../../../data/incoming/DEW/wq/WQ_HCHB_Phase1/ALS Results/';

filelist = dir(fullfile(maindir, '**\ALS*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


for i = 1:length(filelist)
    filename =  [ filelist(i).folder,'/',filelist(i).name ] ;
    
    grab_BGA_Data(filelist(i),i);
    

end

                    
                    
                    
            
            
        
        
        




%  for i = 1:length(data)
%      
%      f
     