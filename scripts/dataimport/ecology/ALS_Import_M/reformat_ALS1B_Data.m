
clear all; close all;

addpath(genpath('fileseries'));

maindir = '../../../../data/incoming/DEW/wq/WQ_HCHB_Phase1B/ALS Results/';

filelist = dir(fullfile(maindir, '**\*RG.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


for i = 2%1:length(filelist)
    filename =  [ filelist(i).folder,'/',filelist(i).name ] ;
    
    data(i).out = grab_ALS_Data(filename);
    
 
    
    data(i).out.filename = filelist(i).name;
    data(i).out.folder = filelist(i).folder;
    
    
%     data(i).out.Ammonia_as_N.data
%     data(i).out.filename
%     if i == 2
%         stop
%     end
    
end

stop
fid = fopen('ALS_Data_1B.csv','wt');

fprintf(fid,'File Name,File Path,Site Name,Var Name,Units,Date,Val\n');


for i = 1:length(data)
    
    vars = fieldnames(data(i).out);
    
    for j = 1:length(data(i).out.dates)
        
        for k = 1:length(vars)
            
            switch vars{k}
                
                case 'dates'
                    
                case 'sites'
                    
                case 'filename'
                    
                case 'folder'
                    
                otherwise
                    
                    thefile = data(i).out.filename;
                    thefolder = data(i).out.folder;
                    thedate = data(i).out.dates(j);
                    thesite = data(i).out.sites{j};
                    theunits = data(i).out.(vars{k}).Units;
                    thevar = data(i).out.(vars{k}).Var;
                    theval = data(i).out.(vars{k}).data(j);
                    
                    fprintf(fid,'%s,%s,%s,%s,%s,%s,%4.4f\n',thefile,thefolder,thesite,thevar,theunits,datestr(thedate,'dd/mm/yyyy HH:MM:SS'),theval);
                    
            end
        end
    end
end

fclose(fid);
                    
                    
                    
            
            
        
        
        




%  for i = 1:length(data)
%      
%      f
     