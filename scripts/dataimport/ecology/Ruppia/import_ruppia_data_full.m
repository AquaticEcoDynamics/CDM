clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_2/UA_Ruppia/';

filename = '2_5_3 v1 plant phenology all fields 18Apr2022.xlsx';

sheetname = 'phenology data';

%______________________________________


[snum,sstr] = xlsread('ruppia_conv.xlsx','A2:C14');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);

%______________________________________________

[~,sites] = xlsread([filepath,filename],sheetname,'C2:C10000');sites = regexprep(sites,' ','_');

[snum,~] = xlsread([filepath,filename],sheetname,'G2:H10000');

[X,Y] = ll2utm(snum(:,1),snum(:,2));

usites = unique(sites);

for i = 1:length(usites)
    
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    uX(i) = X(sss(1));
    uY(i) = Y(sss(1));
end

[snum,sstr] = xlsread([filepath,filename],sheetname,'E2:F10000');

mdates = datenum(sstr(:,1),'dd/mm/yyyy') + snum(:,1);


[~,~,raw] = xlsread([filepath,filename],sheetname,'J2:V1672');




for i = 1:length(newname)
    
    if strcmpi(newname{i},'Ignore') == 0
        
        for j = 1:length(usites)
            
            sss = find(strcmpi(sites,usites{j}));
            
            
            thedata_raw = raw(sss,i);
            thedata = [];
            for k = 1:length(thedata_raw)
                thedata(k,1) = thedata_raw{k};
            end
            
            
            phenology.(usites{j}).(newname{i}).Date = mdates(sss);
            phenology.(usites{j}).(newname{i}).Data = thedata * conv(i);
            phenology.(usites{j}).(newname{i}).Depth(1:length(sss),1) = 0;
            phenology.(usites{j}).(newname{i}).Agency = 'UA HCHB';
            phenology.(usites{j}).(newname{i}).X = uX(j);
            phenology.(usites{j}).(newname{i}).Y = uY(j);
            
            if isnan(phenology.(usites{j}).(newname{i}).X)
                stop
            end
            
            phenology.(usites{j}).(newname{i}).Site_Name = usites{j};
            
        end
    end
end

%______________________________________


[snum,sstr] = xlsread('ruppia_conv.xlsx','A15:C80');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);

%______________________________________________

[~,sites] = xlsread([filepath,filename],sheetname,'Y2:Y10000');sites = regexprep(sites,'–','_');

[snum,~] = xlsread([filepath,filename],sheetname,'AA2:AB10000');
[snum1,~] = xlsread([filepath,filename],sheetname,'G2:H10000');

sss = find(snum(:,1) == 0);
snum(sss,1) = snum1(sss,1);
sss = find(snum(:,2) == 0);
snum(sss,2) = snum1(sss,2);

[X,Y] = ll2utm(snum(:,1),snum(:,2));


usites = unique(sites);

clear uX uY;

for i = 1:length(usites)
    
    sss = find(strcmpi(sites,usites{i}) == 1);
    
    uX(i) = X(sss(1));
    uY(i) = Y(sss(1));
end



[snum,sstr] = xlsread([filepath,filename],sheetname,'Z2:Z10000');

mdates = datenum(sstr(:,1),'dd/mm/yyyy');% + snum(:,1);


[~,~,raw] = xlsread([filepath,filename],sheetname,'W2:CJ1672');




for i = 1:length(newname)
    
    if strcmpi(newname{i},'Ignore') == 0
        
        for j = 1:length(usites)
            
            sss = find(strcmpi(sites,usites{j}));
            
            
            thedata_raw = raw(sss,i);
            
            thedata = [];
            
            for k = 1:length(thedata_raw)
                if isnumeric(thedata_raw{k})
                    thedata(k,1) = thedata_raw{k};
                else
                    thedata(k,1) = str2double(thedata_raw{k});
                end
                
            end
            
            tdate = mdates(sss);
            tdata = thedata * conv(i);
            tdepth(1:length(sss),1) = 0;
            
            ttt= find(~isnan(tdata) == 1);
            
            if ~isempty(ttt)
                phenology.(usites{j}).(newname{i}).Date = tdate(ttt);
                phenology.(usites{j}).(newname{i}).Data = tdata(ttt);
                phenology.(usites{j}).(newname{i}).Depth = tdepth(ttt);
                phenology.(usites{j}).(newname{i}).Agency = 'UA HCHB';
                phenology.(usites{j}).(newname{i}).X = X(j);
                phenology.(usites{j}).(newname{i}).Y = Y(j);
                phenology.(usites{j}).(newname{i}).Site_Name = usites{j};
                
            if isnan(phenology.(usites{j}).(newname{i}).X)
                stop
            end
                
            end
            
        end
    end
end



asites = fieldnames(phenology);

% for j = 1:length(asites)
%
%     if isfield(phenology.(asites{j}),'D') & ...
%             isfield(phenology.(asites{j}),'D2')
%
%         phenology.(usites{j}).D.Date = [phenology.(usites{j}).D.Date;phenology.(usites{j}).D2.Date];
%         phenology.(usites{j}).D.Data = [phenology.(usites{j}).D.Data;phenology.(usites{j}).D2.Data];
%         phenology.(usites{j}).D.Depth = [phenology.(usites{j}).D.Depth;phenology.(usites{j}).D2.Depth];
%
%         [phenology.(usites{j}).D.Date,ind] = sort(phenology.(usites{j}).D.Date);
%         phenology.(usites{j}).D.Data = phenology.(usites{j}).D.Data(ind);
%         phenology.(usites{j}).D.Depth = phenology.(usites{j}).D.Depth(ind);
%
%         phenology.(asites{j}) = rmfield(phenology.(asites{j}),'D2');
%     end
% end

for j = 1:length(asites)
    vars = fieldnames(phenology.(asites{j}));
    
    for i = 1:length(vars)
        
        
        
        [phenology.(asites{j}).(vars{i}).Date,ind] = sort(phenology.(asites{j}).(vars{i}).Date);
        phenology.(asites{j}).(vars{i}).Data = phenology.(asites{j}).(vars{i}).Data(ind);
        phenology.(asites{j}).(vars{i}).Depth = phenology.(asites{j}).(vars{i}).Depth(ind);
        
    end
end



save('../../../../data/store/ecology/phenology.mat','phenology','-mat');











