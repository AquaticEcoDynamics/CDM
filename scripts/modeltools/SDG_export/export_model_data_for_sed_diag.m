addpath(genpath('functions'));

ncfile = 'Z:\Busch\Studysites\Peel\2018_Modelling\Peel_WQ_Model_v4_benthic\Output\benthic_08flow\sim_2016_Open_2D.nc';

shp = shaperead('Export_Locations.shp');

sites = {'LM3G';'WP1G'}; % mat zones 18 & 9



data = tfv_readnetcdf(ncfile,'timestep',1);
mdata = tfv_readnetcdf(ncfile,'names',{'WQ_OXY_OXY';'WQ_NIT_NIT';'WQ_NIT_AMM';'WQ_OGM_POC';'WQ_PHS_FRP'});
dat = tfv_readnetcdf(ncfile,'time',1);
tdate = dat.Time;

cX = double(data.cell_X);
cY = double(data.cell_Y);
dtri = DelaunayTri(cX,cY);

for i = 1:length(sites)
    
    for j = 1:length(shp)
        if strcmpi(shp(j).Name,sites{i}) == 1
            ind = j;
        end
    end
    
    X = shp(ind).X;
    Y = shp(ind).Y;
    
   pt_id = nearestNeighbor(dtri,[X Y]);
   
   
   oxy = mdata.WQ_OXY_OXY(pt_id,:);
   nit = mdata.WQ_NIT_NIT(pt_id,:);
   amm = mdata.WQ_NIT_AMM(pt_id,:);
   poc = mdata.WQ_OGM_POC(pt_id,:);
   frp = mdata.WQ_PHS_FRP(pt_id,:); 
   
   
   tdate = tdate - tdate(1);
   
   
   fid = fopen(['aed2_sediment_swibc_',sites{i},'.dat'],'wt');
   
   
   fprintf(fid,'!				1				2			3			4			5			6			7\n');
   fprintf(fid,'&bc\n');
   fprintf(fid,'headings1 = 	timestep, 	time, 	      oxy,		  nit,		  amm,		 poml, 	      frp\n');
   fprintf(fid,'forzone   =  	0,			   0,			1,			1,			1,			1,			1\n');
   fprintf(fid,'swibc 	  =     1,             0,       %4.4f,      %4.4f,      %4.4f,      %4.4f,      %4.4f\n',...
       oxy(1),nit(1),amm(1),poc(1),frp(1));
   for j = 2:length(oxy)
       fprintf(fid,'                %d,         %4.2f       %4.4f,      %4.4f,      %4.4f,      %4.4f,      %4.4f\n',...
           j,tdate(j),oxy(j),nit(j),amm(j),poc(j),frp(j));
   end
   fclose(fid);
end
   


   
   

 
    
    
    