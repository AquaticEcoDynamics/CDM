clear; close all;

load('lowerlakes.mat');
sites=fieldnames(lowerlakes); %{'A4261207','A4261206','A4261045','A4261039','SAW_Goolwa_US','A4261156'};

polygon_file = 'C:\Users\00064235\CWorkFolder\github\Flow-MER\matlab\modeltools\gis\Coorong\Final_Ruppia_Area.shp';
shp=shaperead(polygon_file);

for i=1:length(sites)
    
    vars=fieldnames(lowerlakes.(sites{i}));
    xx(i)=lowerlakes.(sites{i}).(vars{1}).X;
    yy(i)=lowerlakes.(sites{i}).(vars{1}).Y;
    
   % data.(sites{i}).time=lowerlakes.(sites{i}).SAL.Date;
  %  data.(sites{i}).data=lowerlakes.(sites{i}).SAL.Data;
    tt=lowerlakes.(sites{i}).(vars{1}).Date;
    disp(sites{i});
    disp(datestr(tt(end)));
end

%%
inc=1;
for j=1:length(sites)
    
    if (inpolygon(xx(j),yy(j),shp(1).X,shp(1).Y) || ...
            inpolygon(xx(j),yy(j),shp(2).X,shp(2).Y) || ...
            inpolygon(xx(j),yy(j),shp(3).X,shp(3).Y) || ...
            inpolygon(xx(j),yy(j),shp(4).X,shp(4).Y))
        if regexp(sites{j},'A*')==1
            disp(sites{j});
            xx2(inc)=xx(j);
            yy2(inc)=yy(j);
            sites2{inc}=sites{j};
            inc=inc+1;
        end
    end
end

%%
rad = 500;

int = 1;

sites_selected={'A4261036','A4261039','A4261134','A4261135','A4260633',...
    'A4261209','A4261165'};

for i = 1:length(sites_selected)
    
%    filename='Z:\Busch\Studysites\Lowerlakes\Ruppia\ORH_Simulations_2020\Output\ORH_Base_20170701_20200701.nc';
%   %  filename = 'Z:\Busch\Studysites\Lowerlakes\CEWH_2020\v001_CEW_2013_2020_v1\Output\lower_lakes.nc';
% 
%     rawGeo = tfv_readnetcdf(filename,'timestep',1);
% 

    xx3=lowerlakes.(sites_selected{i}).SAL.X;
    yy3=lowerlakes.(sites_selected{i}).SAL.Y;
    
       T = nsidedpoly(360,'Center',[xx3 yy3],'Radius',rad);

     S(int).X = T.Vertices(:,1);
    S(int).Y = T.Vertices(:,2);
    S(int).Name = sites_selected{i};
    S(int).Geometry = 'Polygon';
    S(int).Plot_Order = int;
    
    int = int + 1;

    

    
end

shapewrite(S,'Coorong_obs_sites.shp');