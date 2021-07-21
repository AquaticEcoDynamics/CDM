clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


filename = '../../../../data/incoming/DEW/wind/BulkExport-A4260603,A4261110,A4261123,A4261124-20210702140250.csv ';



fid = fopen(filename,'rt');

frewind(fid)
x  = 9;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',5,'Delimiter',',');
fclose(fid);


thesite = {'A4260603','A4260603','A4261110','A4261110','A4261123','A4261123','A4261124','A4261124'};

thevars = {'WD','WS','WD','WS','WD','WS','WD','WS'};

mDate(:,1) = datenum(datacell{1},'yyyy-mm-dd HH:MM:SS');

for i = 1:length(thesite)
    data.(thesite{i}).(thevars{i}).Date = mDate;
    data.(thesite{i}).(thevars{i}).Data = str2double(datacell{i+1});
end

save('../../../../data/store/metocean/dew_wind_raw.mat','data','-mat');

load ../../../../data/store/hydro/dew_daily.mat;   

mtime = [datenum(2016,01,01):01/24:datenum(2021,03,01)];


sites = {...
    'A4260603',...
    'A4261110',...
    'A4261123',...
    'A4261124',...
    };

grid = 'CoorongBGC_mesh_001.2dm';

[XX,YY,nodeID,faces,X,Y,ID] = tfv_get_node_from_2dm(grid);

% Create the mesh grid that completely covers the 2dm zone
xarray = [(min(XX)-1000):3000:max(XX)+1000];
yarray = [(min(YY)-1000):3000:max(YY)+1000];
[xx,yy] = meshgrid(xarray',yarray');

Wx = zeros(size(xx,1),size(xx,2),length(mtime));
Wy = zeros(size(xx,1),size(xx,2),length(mtime));


for i = 1:length(mtime)
    %disp([num2str((i/length(mtime))*100),'%']);
    
    WX = [];
    WY = [];
    X = [];
    Y = [];
    
    inc = 1;
    
    for j = 1:length(sites)
        
        vars = fieldnames(dwlbc.(sites{j}));
        
        [val,ind] = min(abs(data.(sites{j}).WS.Date - mtime(i)));
        
        if val < 2
            WS = data.(sites{j}).WS.Data(ind);
            WD = data.(sites{j}).WD.Data(ind);
            
            if ~isnan(WS) & ~isnan(WD)
            
                WX(inc) = (round(-1.0.*(WS).*sin((pi/180).* WD)*1000000)/1000000)/3.6;
                WY(inc) = (round(-1.0.*(WS).*cos((pi/180).* WD)*1000000)/1000000)/3.6;
                X(inc) = dwlbc.(sites{j}).(vars{1}).X;
                Y(inc) = dwlbc.(sites{j}).(vars{1}).Y;
                inc = inc + 1;
            
            end
        end
    end
    
    if ~isempty(WX)   & length(WX) > 1 
        Fx = scatteredInterpolant(X',Y',WX','linear','nearest'); 
        Fy = scatteredInterpolant(X',Y',WY','linear','nearest');    
        
        
        if ~isempty(Fx(xx,yy))
            

            
            
            
            
            Wx(:,:,i) = Fx(xx,yy);
            Wy(:,:,i) = Fy(xx,yy);    
            
        else
            
            [yyy,mm,dd] = datevec(mtime(i));
            
            ss = find(mtime == datenum(yyy-1,mm,dd));
            
            Wx(:,:,i) = Wx(:,:,ss);
            Wy(:,:,i) = Wy(:,:,ss);   
            disp(datestr(mtime(i)));
        end
            
    else
        if length(WX) == 1
        Wx(:,:,i) = WX;
        Wy(:,:,i) = WY;
        else
            stop
        end
        
    end
end

ncid = netcdf.create('DEWNR_Wx_Wy_2010_2020.nc', 'NETCDF4');



% Need to change from [row,col,time] to [x,y,time];
Wx_netcdf = permute(Wx,[2,1,3]);
Wy_netcdf = permute(Wy,[2,1,3]);




[sx,sy,sz] = size(Wx_netcdf);

% I think time is hours since 01/01/1990 00:00:00
mhours = (mtime - datenum(1990,01,01,00,00,00)) * 24;

% Create a test file...


time_dimID = netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED')); %time
y_dimID = netcdf.defDim(ncid,'lat',sy);%latitude
x_dimID = netcdf.defDim(ncid,'lon',sx);%longitude

% Define variables

time_varid = netcdf.defVar(ncid,'time','double',time_dimID);
x_varid = netcdf.defVar(ncid,'lon','double',x_dimID);
y_varid = netcdf.defVar(ncid,'lat','double',y_dimID);
u_varid = netcdf.defVar(ncid,'u','double',[x_dimID,y_dimID,time_dimID]);
v_varid = netcdf.defVar(ncid,'v','double',[x_dimID,y_dimID,time_dimID]);

% Time
netcdf.putAtt(ncid,time_varid,'long_name','time in decimal hours since 01/01/1990 00:00');
netcdf.putAtt(ncid,time_varid,'units','hours');
% Lat
netcdf.putAtt(ncid,y_varid,'units','m');
netcdf.putAtt(ncid,y_varid,'long_name','latitude');
netcdf.putAtt(ncid,y_varid,'projection','UTM');
% Long
netcdf.putAtt(ncid,x_varid,'units','m');
netcdf.putAtt(ncid,x_varid,'long_name','longitude');
netcdf.putAtt(ncid,x_varid,'projection','UTM');
% U (Wx)
netcdf.putAtt(ncid,u_varid,'units','m s^-1');
netcdf.putAtt(ncid,u_varid,'long_name','u');
% V (Wy)
netcdf.putAtt(ncid,v_varid,'units','m s^-1');
netcdf.putAtt(ncid,v_varid,'long_name','v');


netcdf.endDef(ncid);

% Add the data
disp('Writing Time');
netcdf.putVar(ncid,time_varid,0,length(mhours),mhours);
netcdf.putVar(ncid,y_varid,0,sy,yarray);
netcdf.putVar(ncid,x_varid,0,sx,xarray);

% U Data
disp('Writing U');
netcdf.putVar(ncid,u_varid,[0,0,0],[sx,sy,sz],Wx_netcdf);
% V Data
disp('Writing V');
netcdf.putVar(ncid,v_varid,[0,0,0],[sx,sy,sz],Wy_netcdf);

netcdf.close(ncid)% Close the file.
    
    
 