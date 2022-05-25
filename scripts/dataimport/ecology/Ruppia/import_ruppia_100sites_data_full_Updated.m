clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_2/UA_Ruppia/Ruppia_2-2-4_Database/';

filename = 'All data w est algal biomass.xlsx';

sheetname = 'All 4 season data';

%______________________________________


[snum,sstr] = xlsread('ruppia_conv.xlsx','Sheet1','N2:P54');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);

%______________________________________________

[~,sites] = xlsread([filepath,filename],sheetname,'C2:C10000');sites = regexprep(sites,'–','_');sites = regexprep(sites,'-','_');

[snum,~] = xlsread([filepath,filename],sheetname,'F2:G10000');

[X,Y] = ll2utm(snum(:,1),snum(:,2));

usites = unique(sites);

for i = 1:length(usites)
    
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    uX(i) = X(sss(1));
    uY(i) = Y(sss(1));
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'D2:E10000');

mtime = snum(:,1);

mtime(isnan(mtime)) = 10/24;

mdates = datenum(sstr(:,1),'dd/mm/yyyy') + mtime;


[~,~,raw] = xlsread([filepath,filename],sheetname,'J2:BJ4846');




for i = 1:length(newname)
    
    if strcmpi(newname{i},'Ignore') == 0
        
        for j = 1:length(usites)
            
            sss = find(strcmpi(sites,usites{j}));
            
            
            thedata_raw = raw(sss,i);
            thedata = [];
            for k = 1:length(thedata_raw)
                thedata(k,1) = thedata_raw{k};
            end
            
            tdate = mdates(sss);
            tdata = thedata * conv(i);
            tdepth(1:length(sss),1) = 0;
            
            ttt= find(~isnan(tdata) == 1);
            
            if ~isempty(ttt)
                baseline_ruppia_all.(usites{j}).(newname{i}).Date = tdate(ttt);
                baseline_ruppia_all.(usites{j}).(newname{i}).Data = tdata(ttt);
                baseline_ruppia_all.(usites{j}).(newname{i}).Depth = tdepth(ttt);
                
                
                baseline_ruppia_all.(usites{j}).(newname{i}).Agency = 'UA HCHB 100';
                baseline_ruppia_all.(usites{j}).(newname{i}).X = uX(j);
                baseline_ruppia_all.(usites{j}).(newname{i}).Y = uY(j);
                baseline_ruppia_all.(usites{j}).(newname{i}).Site_Name = usites{j};
            end
            
        end
    end
end




asites = fieldnames(baseline_ruppia_all);


for i = 1:length(asites)
    if isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_ALTHENIA_NSEED') & ...
            isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_RUPPIA_NSEED')
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NSEED = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_ALTHENIA_NSEED;
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NSEED.Data = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_ALTHENIA_NSEED.Data + ...
            baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_RUPPIA_NSEED.Data;
    end
    
    
    
    
    
    if isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_ALTHENIA_NFLOWER') & ...
            isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_RUPPIA_NFLOWER')
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NFLOWER = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_ALTHENIA_NFLOWER;
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NFLOWER.Data = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_ALTHENIA_NFLOWER.Data + ...
            baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_RUPPIA_NFLOWER.Data;
    end
    
    
    
    
    if isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_MAC_NTURION1') & ...
            isfield(baseline_ruppia_all.(asites{i}),'WQ_DIAG_MAC_MAC_NTURION2')
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NTURION = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NTURION1;
        
        baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NTURION.Data = baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NTURION1.Data + ...
            baseline_ruppia_all.(asites{i}).WQ_DIAG_MAC_MAC_NTURION2.Data;
    end
    
    
end

for j = 1:length(asites)
    vars = fieldnames(baseline_ruppia_all.(asites{j}));
    
    for i = 1:length(vars)
        
        
        
        [baseline_ruppia_all.(asites{j}).(vars{i}).Date,ind] = sort(baseline_ruppia_all.(asites{j}).(vars{i}).Date);
        baseline_ruppia_all.(asites{j}).(vars{i}).Data = baseline_ruppia_all.(asites{j}).(vars{i}).Data(ind);
        baseline_ruppia_all.(asites{j}).(vars{i}).Depth = baseline_ruppia_all.(asites{j}).(vars{i}).Depth(ind);
        
    end
end



save('../../../../data/store/ecology/baseline_ruppia_all.mat','baseline_ruppia_all','-mat');











