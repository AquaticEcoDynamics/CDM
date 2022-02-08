clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


filename = '../BC from Field Data/BCs_BAR_2019_2022_V6/BK_20120101_20220101.csv';

load ../../../../data/store/hydro/dew_tide_VH.mat;
%load ../../../../data/store/hydro/dew_tide_VH_uncorrected.mat;


outdir = 'Images/Tide_7/';

if ~exist(outdir,'dir')
    mkdir(outdir)
end

data = tfv_readBCfile(filename);

vars = fieldnames(data);


% [tt.Date,ind] = unique(tide.VH.H.Date);
% tt.Data = tide.VH.H.Data(ind);
% data.WL = [];
% data.WL = interp1(tt.Date,tt.Data,data.Date);

TKN = data.DON + data.PON;
data.DON = TKN * 0.85;
data.PON = TKN * 0.15;

TP = data.DOP + data.POP;
data.DOP = TP * 0.85;
data.POP = TP * 0.15;


% data.POC(1:length(data.POC),1) = 10;
% data.DOC(1:length(data.DOC),1) = 50;


%fid = fopen('../BC from Field Data/BCs_BAR_2019_2021_Monthly_Ave_Hourly/VH_20190101_20210701_v2.csv','wt');
fid = fopen('VH_20120101_20220101_v6.csv','wt');
for i = 1:length(vars)
    if i == length(vars)
        fprintf(fid,'%s\n',vars{i});
    else
        
        if i == 1
            fprintf(fid,'ISOTIME,');
        else
            fprintf(fid,'%s,',vars{i});
        end
    end
end

for j = 1:length(data.Date)
    
    for i = 1:length(vars)
        
        if i == 1
            fprintf(fid,'%s,',datestr(data.Date(j),'dd/mm/yyyy HH:MM:SS'));
        else
            
            if i == length(vars)
                fprintf(fid,'%4.4f\n',data.(vars{i})(j));
            else
                fprintf(fid,'%4.4f,',data.(vars{i})(j));
            end
        end
    end
end
fclose(fid);

for i = 1:length(vars)
    
    if strcmpi(vars{i},'Date') == 0
        
        xdata = data.Date;
        ydata = data.(vars{i});
        
        
        figure('position',[555 635 1018 343]);
        plot(xdata,ydata,'k');hold on;
        
%         if strcmpi(vars{i},'WL') == 1
%             plot(tt.Date,tt.Data,'r');
%         end
        
        title(regexprep(vars{i},'_',' '));
        
        x_array = xdata(1):(xdata(end)-xdata(1))/5:xdata(end);
        
        set(gca,'xtick',x_array,'xticklabel',datestr(x_array,'mm/yyyy'));
        
        xlim([xdata(1) xdata(end)]);
        
        
        filename = [outdir,vars{i},'.png'];
        
        saveas(gcf,filename);
        
        close
    end
end
        
 create_html_for_directory('Images/');       
