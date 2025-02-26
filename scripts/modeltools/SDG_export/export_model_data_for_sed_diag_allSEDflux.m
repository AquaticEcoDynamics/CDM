clear; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

% define import file and output directory
ncfile = 'W:\CDM\hchb_tfvaed_v2_resuspension_z31_newSHP\output\hchb_wave_21901101_20210701_wq_v5_resuspension_all.nc';
shp = shaperead('Export_Locations.shp');

outDIR='C:\Users\00064235\AED Dropbox\AED_Coorong_db\3_data\SedimentData\model_export\';

% sediment flux variables
SedVars={'WQ_OXY_OXY',...
    'WQ_NIT_NIT',...
    'WQ_NIT_AMM',...
    'WQ_DIAG_OXY_SED_OXY',...
'WQ_DIAG_SIL_SED_RSI',...
'WQ_DIAG_NIT_SED_AMM',...
'WQ_DIAG_NIT_SED_NIT',...
'WQ_DIAG_PHS_SED_FRP',...
'WQ_DIAG_OGM_PSED_POC',...
'WQ_DIAG_OGM_PSED_PON',...
'WQ_DIAG_OGM_PSED_POP',...
'WQ_DIAG_PHY_PSED_PHY',...
};

% export the flux data and save it in a .mat file for future use
data = tfv_readnetcdf(ncfile,'timestep',1);
dat = tfv_readnetcdf(ncfile,'time',1);
tdate = dat.Time;

cX = double(data.cell_X);
cY = double(data.cell_Y);
dtri = DelaunayTri(cX,cY);

readdata=0; % 1: import the data from NC file, 0: read in the data from saved .mat file

if readdata

for i = 1:length(shp)
        
    X = shp(i).X;
    Y = shp(i).Y;
    
    sites = shp(i).Code;
    
   pt_id(i) = nearestNeighbor(dtri,[X Y]);
   
end

for vv=1:length(SedVars)
    disp(SedVars{vv});
    tmp=ncread(ncfile,SedVars{vv});
    
    for i = 1:length(shp)
        
    export.(SedVars{vv})=tmp(pt_id,:);
    end
   
end

save([outDIR,'exported.mat'],'export','-mat','-v7.3');

else
    
    load([outDIR,'exported.mat']);

end
   
%% write to output

for i = 1:length(shp)
    
    header_str1='!				1				2';
header_str2='headings1 = 	timestep, 	time,';
header_str3='forzone   =  	0,			   0,';

for vv=1:length(SedVars)
    header_str1=[header_str1,'          ',num2str(vv+2)];
    header_str2=[header_str2,'          ',SedVars{vv}];
    header_str3=[header_str3,'          ',num2str(i)];
end
       
    sites = shp(i).Code;
    tdate = tdate - tdate(1);

   fid = fopen([outDIR,'aed2_sediment_swibc_',sites,'.dat'],'wt');
   
   
   fprintf(fid,'%s\n',header_str1); 
   fprintf(fid,'&bc\n');
   fprintf(fid,'%s\n',header_str2);
   fprintf(fid,'%s\n',header_str3);

   for j = 1:length(tdate)
       if j==1
           fprintf(fid,'swibc 	  =     1,             0');
       else
           fprintf(fid,'                %d,         %4.2f',j,tdate(j));
       end
       
       for vv=1:length(SedVars)
           if vv>=9
           fprintf(fid,',       %4.4f',abs(export.(SedVars{vv})(i,j))*86400); % convert from /s to /day for seleted vars
           else
               fprintf(fid,',       %4.4f',abs(export.(SedVars{vv})(i,j)));
           end
       end
       fprintf(fid,'\n');

   end
   fclose(fid);
end
   


   
   

 
    
    
    