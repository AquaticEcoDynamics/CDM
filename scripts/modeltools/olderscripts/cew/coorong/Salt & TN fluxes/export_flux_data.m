
clear; close all;

scens={'Base','Scen1','Scen2'};

for ii=1:length(scens)

infile=['Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\Output\MER_',...
    scens{ii},'_20170701_20200701_FLUX.csv'];
disp(infile);
%T=readtable(infile);

%%
%opts = detectImportOptions(infile);
%preview(infile,opts)
%opts.SelectedVariableNames = [1]; 
%opts.DataRange = '2:11';
M = readmatrix(infile);

%%
[~,time,~]=xlsread(infile,'A2:A13154');
data.Date=zeros(size(time));

for i=1:length(time)
    if length(time{i})<12
        data.Date(i)=datenum(time{i},'dd/mm/yyyy');
    else
    data.Date(i)=datenum(time{i},'dd/mm/yyyy HH:MM:SS');
    end
end

vars={'FLOW','SAL','TEMP','TRACE_1','TRACE_2','NCS_ss1','TRC_age','OXY_oxy',...
    'SIL_rsi','NIT_amm','NIT_nit','PHS_frp','PHS_frp_ads','OGM_doc',...
    'OGM_poc','OGM_don','OGM_pon','OGM_dop','OGM_pop','PHY_grn',...
    'MAG_ulva','MAG_ulva_IN','MAG_ulva_IP'};

for m=1:21
    for n=1:length(vars)
        data.(['NS',num2str(m),'_',vars{n}])=M(:,(m-1)*23+n+1);
    end
end

save(['flux_',scens{ii},'.mat'],'data','-v7.3');
end