addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

%ncfile = 'W:\CIIP\CIIP_Phase2_sensitivity_assessment_v1\output_SC01_S2\CoorongBGC_SC01_base_dry_001_S2_all.nc';
ncfile = 'W:\CDM\hchb_tfvaed_v2_resuspension_z31_newSHP\output\hchb_wave_21901101_20210701_wq_v5_resuspension_all.nc';
shp = shaperead('Export_Locations.shp');

%sites = {'LM3G';'WP1G'}; % mat zones 18 & 9

outDIR='C:\Users\00064235\AED Dropbox\AED_Coorong_db\3_data\SedimentData\model_export\';

data = tfv_readnetcdf(ncfile,'timestep',1);
mdata = tfv_readnetcdf(ncfile,'names',{'WQ_OXY_OXY';'WQ_NIT_NIT';'WQ_NIT_AMM';'WQ_PHS_FRP';'WQ_DIAG_OGM_PSED_POC'});
dat = tfv_readnetcdf(ncfile,'time',1);
tdate = dat.Time;

cX = double(data.cell_X);
cY = double(data.cell_Y);
dtri = DelaunayTri(cX,cY);

for i = 1:length(shp)
    
    
    X = shp(i).X;
    Y = shp(i).Y;
    
    sites = shp(i).Code;
    
   pt_id = nearestNeighbor(dtri,[X Y]);
   
   
   oxy = mdata.WQ_OXY_OXY(pt_id,:);
   nit = mdata.WQ_NIT_NIT(pt_id,:);
   amm = mdata.WQ_NIT_AMM(pt_id,:);
   frp = mdata.WQ_PHS_FRP(pt_id,:); 
   poc = mdata.WQ_DIAG_OGM_PSED_POC(pt_id,:);

   
   tdate = tdate - tdate(1);
   
   
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
   fclose(fid);
end
   


   
   

 
    
    
    