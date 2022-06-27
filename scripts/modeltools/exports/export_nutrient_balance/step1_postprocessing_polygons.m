clear; close all;

% define short names for scenarios
scens={'basecase','noSE','noeWater','Designed','noBarrage'};

% main model output path
mDir='W:\CDM\HCHB_scenario_assessment\HCHB_GEN2_4yrs_20220620\';

% scenario output files
files={'output_basecase_hd\hchb_Gen2_201707_202201_all.nc';...
    'output_noSE\hchb_Gen2_201707_202201_noSE_all.nc';...
    'output_noeWater\hchb_Gen2_201707_202201_noeWater_all.nc';...
    'output_scen3a\hchb_Gen2_201707_202201_scen3a_all.nc';...
    'output_scen3b\hchb_Gen2_201707_202201_scen3b_all.nc'};

% variables to process
vars = {'WQ_DIAG_TOT_TN','WQ_DIAG_TOT_TP'};

% define output path
outdir = '.\processed_data\';
if exist(outdir,'dir')
    mkdir(outdir);
end

%% CNL and CSL polygons
shp(1) = shaperead('E:\Github\CDM\scripts\modeltools\exports\CoorongPolygons_DEW\2-NorthLagoon\ExtendedNorth3_Merge.shp');
shp(2) = shaperead('E:\Github\CDM\scripts\modeltools\exports\CoorongPolygons_DEW\3-SouthLagoon\ExtendedSouth_Merge.shp');

shpnames={'CNL','CSL'};
%
ncfile = [mDir,files{1}];
disp(['reading BATHY']);
data = tfv_readnetcdf(ncfile,'names',{'cell_X';'cell_Y'});

% read cell number in polygon
disp(['reading GIS']);

for i = 1:length(shp)
    inpol = inpolygon(data.cell_X,data.cell_Y,shp(i).X,shp(i).Y);
    ttt = find(inpol == 1);
    fsite(i).theID = ttt;
    fsite(i).Name = shpnames{i};
end

%% processing FLUX files and save to .mat files

for ff=1:length(scens)
    ncfile = [mDir,files{ff}];
    disp(['processing ',ncfile, ' ...']);
    names = tfv_infonetcdf(ncfile);
    mdata = tfv_readnetcdf(ncfile,'time',1);
    Time = mdata.Time;
    data = tfv_readnetcdf(ncfile,'names',{'cell_X';'cell_Y';'cell_A';'D'});
    
    for i = 1:length(vars)
        
        if sum(strcmpi(names,vars{i})) == 1
            
            disp(['Importing ',vars{i}]);
            tic
            
            mod = tfv_readnetcdf(ncfile,'names',vars(i));
            
            for j = 1:length(shp)
                savedata = [];
                tmp=[];
                findir = [outdir,scens{ff},'/',shpnames{j},'/'];
                if ~exist(findir,'dir')
                    mkdir(findir);
                end
                %if ~exists([findir,vars{i},'.mat'],'file')
                
                tmp.X = data.cell_X(fsite(j).theID);
                tmp.Y = data.cell_Y(fsite(j).theID);
                    
                    tmp.(vars{i}).Bot(:,:) = mod.(vars{i})(fsite(j).theID,:);
                    DD = data.D(fsite(j).theID,:);

                    tmp.(vars{i}).Area(:) = data.cell_A(fsite(j).theID);
                    
                    tmp.(vars{i}).Column(:,:) = mod.(vars{i})(fsite(j).theID,:) .* DD .* tmp.(vars{i}).Area(:);
                    tmp.(vars{i}).volumn(:,:) = DD .* tmp.(vars{i}).Area(:);
                    tmp.(vars{i}).meanConcentration(:,:) = tmp.(vars{i}).Column(:,:)./tmp.(vars{i}).volumn(:,:);
                
                savedata.Time = Time;
                savedata.meanConcentration = mean(tmp.(vars{i}).meanConcentration,1);
                
                save([findir,vars{i},'.mat'],'savedata','-mat','-v7.3');
                clear savedata tmp;

            end
            
            toc
        else
            disp(['not found ',vars{i}]);
        end
    end
    
end