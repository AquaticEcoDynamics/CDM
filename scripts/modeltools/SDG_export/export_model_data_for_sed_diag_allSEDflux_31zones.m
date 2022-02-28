clear; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

% define import file and output directory
ncfile = 'W:\CDM\hchb_tfvaed_v2_resuspension_z31_newSHP\output\hchb_wave_21901101_20210701_wq_v5_resuspension_all.nc';
%shp = shaperead('Export_Locations.shp');
shp = shaperead('W:\CDM\hchb_tfvaed_v2_resuspension_z31_newSHP\model\gis\shp\31_material_zones.shp');

outDIR='C:\Users\00064235\AED Dropbox\AED_Coorong_db\3_data\SedimentData\model_export\31zones_SEDPHY\';

% sediment flux variables
SedVars={'WQ_OXY_OXY',...       % oxy
    'WQ_NIT_NIT',...            % nit
    'WQ_NIT_AMM',...            % amm
    'WQ_PHS_FRP',...            % frp
    'WQ_DIAG_OGM_PSED_POC',...      % sedpoc
    'WQ_DIAG_PHY_PSED_PHY',...      % sedphy
% 'WQ_DIAG_OXY_SED_OXY',...   % sedoxy
% 'WQ_DIAG_SIL_SED_RSI',...       % sedrsi
% 'WQ_DIAG_NIT_SED_AMM',...       % sedamm
% 'WQ_DIAG_NIT_SED_NIT',...       % sednit
% 'WQ_DIAG_PHS_SED_FRP',...       % sedfrp
% 'WQ_DIAG_OGM_PSED_PON',...      % sedpon
% 'WQ_DIAG_OGM_PSED_POP',...      % sedpop
% 'WQ_DIAG_PHY_PSED_PHY',...      % sedphy
};

% export the flux data and save it in a .mat file for future use
data = tfv_readnetcdf(ncfile,'timestep',1);
dat = tfv_readnetcdf(ncfile,'time',1);
tdate = dat.Time;

cX = double(data.cell_X);
cY = double(data.cell_Y);
%dtri = DelaunayTri(cX,cY);

readdata=1; % 1: import the data from NC file, 0: read in the data from saved .mat file

if readdata

for i = 1:length(shp)
        
    X = shp(i).X;
    Y = shp(i).Y;
    
    sites = ['zone_',num2str(shp(i).Mat)];
    
   %pt_id(i) = nearestNeighbor(dtri,[X Y]);
   pt_id.(sites) = inpolygon(cX,cY,X,Y);
   
end

for vv=1:length(SedVars)
    disp(SedVars{vv});
    tmp=ncread(ncfile,SedVars{vv});
    
    for i = 1:length(shp)
        sites = ['zone_',num2str(shp(i).Mat)];
        export.(SedVars{vv}).(sites)=mean(tmp(pt_id.(sites),:),1);
    end
   
end

save([outDIR,'exported_31zones.mat'],'export','-mat','-v7.3');

else
    
    load([outDIR,'exported_31zones.mat']);

end
   
%% write to output

for i = 1:length(shp)
    
%     header_str1='!				1				2';
% header_str2='headings1 = 	timestep, 	time,';
% header_str3='forzone   =  	0,			   0,';
% 
% for vv=1:length(SedVars)
%     header_str1=[header_str1,'          ',num2str(vv+2)];
%     header_str2=[header_str2,'          ',SedVars{vv}];
%     header_str3=[header_str3,'          ',num2str(shp(i).Mat)];
% end
       
    sites = ['zone_',num2str(shp(i).Mat)];
    disp(sites);
    tdate = tdate - tdate(1);
    
    oxy=abs(export.(SedVars{1}).(sites));
    nit=abs(export.(SedVars{2}).(sites));
    amm=abs(export.(SedVars{3}).(sites));
    frp=abs(export.(SedVars{4}).(sites));
    poc=abs(export.(SedVars{5}).(sites))*86400*365;
    poc=poc+abs(export.(SedVars{6}).(sites))*86400*365;

   fid = fopen([outDIR,'aed2_sediment_swibc_',sites,'.dat'],'wt');
   
      fprintf(fid,'!				1				2			3			4			5			6			7\n');
   fprintf(fid,'&bc\n');
   fprintf(fid,'headings1 = 	timestep, 	time, 	      oxy,		  nit,		  amm,		 frp, 	      pocl\n');
   fprintf(fid,'forzone   =  	0,			   0,			1,			1,			1,			1,			1\n');
   fprintf(fid,'swibc 	  =     1,             0,       %4.4f,      %4.4f,      %4.4f,      %4.4f,      %4.4f\n',...
       oxy(1),nit(1),amm(1),frp(1),poc(1));
   for j = 2:length(oxy)
       fprintf(fid,'                %d,         %4.2f       %4.4f,      %4.4f,      %4.4f,      %4.4f,      %4.4f\n',...
           j,tdate(j),oxy(j),nit(j),amm(j),frp(j),poc(j));
   end
%    
%    fprintf(fid,'%s\n',header_str1); 
%    fprintf(fid,'&bc\n');
%    fprintf(fid,'%s\n',header_str2);
%    fprintf(fid,'%s\n',header_str3);
% 
%    for j = 1:length(tdate)
%        if j==1
%            fprintf(fid,'swibc 	  =     1,             0');
%        else
%            fprintf(fid,'                %d,         %4.2f',j,tdate(j));
%        end
%        
%        for vv=1:length(SedVars)
%            if vv>=9
%            fprintf(fid,',       %4.4f',abs(export.(SedVars{vv}).(sites)(j))*86400); % convert from /s to /day for seleted vars
%            else 
%                fprintf(fid,',       %4.4f',abs(export.(SedVars{vv}).(sites)(j)));
%            end
%        end
%        fprintf(fid,'\n');
% 
%    end
   fclose(fid);
end
   


   
   

 
    
    
    