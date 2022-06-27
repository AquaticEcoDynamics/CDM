
clear; close all;

% define short names for scenarios
scens={'basecase','noeWater','noSE','Designed','noBarrage'};

% variables to process
vars = {'WQ_DIAG_TOT_TN','WQ_DIAG_TOT_TP'};

% polygons
shpnames={'CNL','CSL'};

% time windows for output
export(1).time=[datenum(2020,4,1) datenum(2020,9,30)];
export(2).time=[datenum(2020,10,1) datenum(2021,3,31)];

% mat outpus main path in step1
matoutputDir='.\processed_data\';

% calculate mean concentration in polygons in time windows
for ss=1:length(scens)
    for nn=1:length(shpnames)
        for ii=1:length(vars)
            matfile=[matoutputDir,scens{ss},'\',shpnames{nn},'\',vars{ii},'.mat'];
            disp(matfile);
            tmpfile=load(matfile);
            tmptime=tmpfile.savedata.Time;
            tmpdata=tmpfile.savedata.meanConcentration;
            
            for tt=1:length(export)
                inds=find(tmptime>=export(tt).time(1) & tmptime <export(tt).time(2));
                data.(scens{ss}).(shpnames{nn}).(vars{ii})(tt)=mean(tmpdata(inds));
            end
        end
    end
end

%% export

fileID = fopen('nutrient concentration - 2020.csv','w');
header='export,basecase,no eWater,no SE, designed, no barrage';
fprintf(fileID,'%s\n',header);

polys={'CNL','CSL'};

for pp=1:length(polys)
    fprintf(fileID,'%s',['CPS TN apr-sep:',polys{pp}]);

         for ss=1:length(scens)
      
            fprintf(fileID,',%6.2f',data.(scens{ss}).(polys{pp}).WQ_DIAG_TOT_TN(1)*14/1000);
        end

    fprintf(fileID,'%s\n','');
    
end


for pp=1:length(polys)
    fprintf(fileID,'%s',['CPS TN oct-mar:',polys{pp}]);

       for ss=1:length(scens)
         
            fprintf(fileID,',%6.2f',data.(scens{ss}).(polys{pp}).WQ_DIAG_TOT_TN(2)*14/1000);
        end

    fprintf(fileID,'%s\n','');
    
end

for pp=1:length(polys)
    fprintf(fileID,'%s',['CPS TP apr-sep:',polys{pp}]);

       for ss=1:length(scens)
         
            fprintf(fileID,',%6.2f',data.(scens{ss}).(polys{pp}).WQ_DIAG_TOT_TP(1)*31/1000);
        end

    fprintf(fileID,'%s\n','');
    
end


for pp=1:length(polys)
    fprintf(fileID,'%s',['CPS TP oct-mar:',polys{pp}]);

        for ss=1:length(scens)
           
            fprintf(fileID,',%6.2f',data.(scens{ss}).(polys{pp}).WQ_DIAG_TOT_TP(2)*31/1000);
        end

    fprintf(fileID,'%s\n','');
    
end

fclose(fileID);