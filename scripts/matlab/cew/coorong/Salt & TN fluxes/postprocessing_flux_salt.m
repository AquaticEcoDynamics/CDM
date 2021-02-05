
clear; close;

scens={'Base','Scen1','Scen2'};
scens2={'Basecase','Scen1','Scen2'};

flowdir='Z:\Busch\Studysites\Lowerlakes\Ruppia\MER_Coorong_eWater_2020_v1\BC\Inflows\';
bars={'Goolwa','Boundary','Ewe','Mundoo','Tauwitchere'};

barrages=2:6;
ocean=18;
south=12;
north=8;

for ii=1:length(scens)
    
    load(['flux_',scens{ii},'.mat']);
    fluxdata.(scens{ii}).barrage=data.NS2_SAL;
    
    for j=3:6
        fluxdata.(scens{ii}).barrage=fluxdata.(scens{ii}).barrage+data.(['NS',num2str(j),'_SAL']);
    end
    
    fluxdata.(scens{ii}).ocean=data.NS18_SAL;
    fluxdata.(scens{ii}).south=-data.NS12_SAL;
    fluxdata.(scens{ii}).north=data.NS8_SAL;
    fluxdata.(scens{ii}).Date=data.Date;
    
    infile=[flowdir,scens2{ii},'\',bars{1},'_Extended_2020.csv'];
    flowdata=tfv_readBCfile_ISOTime(infile);
    salflux=flowdata.flow.*flowdata.sal;
    tmp=interp1(flowdata.Date,salflux,data.Date);
    fluxdata.(scens{ii}).barrageflow=tmp;
    
    for jj=2:length(bars)
        infile=[flowdir,scens2{ii},'\',bars{jj},'_Extended_2020.csv'];
        disp(infile);
    flowdata=tfv_readBCfile_ISOTime(infile);
    salflux=flowdata.flow.*flowdata.sal;
    tmp=interp1(flowdata.Date,salflux,data.Date);
    fluxdata.(scens{ii}).barrageflow=fluxdata.(scens{ii}).barrageflow+tmp;
    end
end

save(['flux_all_inflows.mat'],'fluxdata','-v7.3');