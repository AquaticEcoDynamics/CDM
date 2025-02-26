clear all; close all;

load UAraw.mat;

[snum,sstr] = xlsread('ConversionPH.xlsx','A2:D500');

conv = snum(:,1);

oldname = sstr(:,1);
newname = sstr(:,2);
units = sstr(:,3);

sites = fieldnames(UAraw);

UA = [];

for i = 1:length(sites)
    
    vars = fieldnames(UAraw.(sites{i}));
    
    for j = 1:length(vars)
    
        ss = find(strcmpi(oldname,vars{j}) == 1);
        
        if strcmpi(newname{ss},'Ignore') == 0;
            
            UA.([sites{i}]).([newname{ss}]) = UAraw.(sites{i}).(oldname{ss});
            UA.([sites{i}]).([newname{ss}]).Data = UA.([sites{i}]).([newname{ss}]).Data * conv(ss);
            UA.([sites{i}]).([newname{ss}]).Units = units(ss);
            UA.([sites{i}]).([newname{ss}]).Agency = 'UA WQ';
        end
    end
end

save C:\Users\00065525\GITHUB\CDM\data\store\ecology\UA_Coorong_Compiled_WQ.mat UA -mat;
            