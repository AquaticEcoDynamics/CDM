clear;close all;

scen='GEN2_4yrs_lims';
infolder0=['E:\database\Lowerlakes_CEW\C_budgetting\extracted_GEN2_basecase\'];
sites={'NCL','SCL2'};
sitenames={'NCL-4yrs','SCL-4yrs'};

for ss=1:length(sites)
    
    site=sites{ss};
    
    datearray=datenum(2018:2022,1,1);
    t1=datearray(1);t2=datearray(end)-1;
    datess=datestr(datearray,'yyyymmdd');
 %   t1=datenum(2019,1,1);t2=datenum(2020,1,1);
 %   datess={'20190101','20190401','20190701','20191001','20200101'};
    outputfolder=['./Budget_GEN2_4yrs_TN_Dcorr/',site,'/'];
    
    if ~exist(outputfolder,'dir')
        mkdir(outputfolder);
    end
    
    infolder=[infolder0,site,'\'];
    disp(infolder);
    
    %% loading carbon vars
    
    define_nitrogen_outputs_v6;
    
    readdata=1;
    
    if readdata
        data=[];
        preprocessing_vars_nitrogen;
        
        Dtmp=load([infolder,'D.mat']);
        DD=Dtmp.savedata.D;
        % loop through the variables
        D_lim=0.0401;
        data = cal_3D_pool_DD(data,infolder, NPool_3D,t1,t2,NPool_3D_factors,DD,D_lim);
        data = cal_2D_pool_DD(data,infolder, N_BGC_2D,t1,t2,N_BGC_2D_factors,DD,D_lim);
        data = cal_2D_pool_DD(data,infolder, NPool_2D,t1,t2,NPool_2D_factors,DD,D_lim);
        data = cal_3D_pool_DD(data,infolder, N_BGC_3D,t1,t2,N_BGC_3D_factors,DD,D_lim);
%         data = cal_3D_pool(data,infolder, NPool_3D,t1,t2,NPool_3D_factors);
%         data = cal_2D_pool(data,infolder, NPool_2D,t1,t2,NPool_2D_factors);
%         data = cal_3D_pool(data,infolder, N_BGC_3D,t1,t2,N_BGC_3D_factors);
%         data = cal_2D_pool(data,infolder, N_BGC_2D,t1,t2,N_BGC_2D_factors);
        %data = cal_2D_pool_perSecond(data,infolder, N_BGC_2D_perSecond,t1,t2);
        
        flux=load('.\flux\Flux_hchb_GEN2_basecase.mat');
        
        if ss==1
            nsnames={'Coorong_1','Coorong_Parnka_2'};
            nssigns=[1,1];
        elseif ss==2
            nsnames={'South_Creek','Coorong_Parnka_2','Coorong_BC'};
            nssigns=[1,-1,-1];
        end
        data=cal_flux(data,flux,N_flux_vars,nsnames,nssigns,t1,t2);
        save([outputfolder,'data_BC_nitrogen',scen,'_DD.mat'],'data','-mat','-v7.3');

    else
        load([outputfolder,'data_BC_nitrogen',scen,'_DD.mat']);
    end
    %% plotting
    figure(1);
    def.dimensions = [25 30]; % Width & Height in cm
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
    xSize = def.dimensions(1);
    ySize = def.dimensions(2);
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])  ;
    
    clf;
    
    plh=0.18;hlh=0.05;
    plw=0.64;hls=0.82;adj=0.05;
    pos1=[0.1 0.74 plw plh];pos11=[hls 0.76+adj 0.10 hlh];
    pos2=[0.1 0.52 plw plh];pos21=[hls 0.54+adj 0.10 hlh];
    pos3=[0.1 0.30 plw plh];pos31=[hls 0.32+adj 0.10 hlh];
    pos4=[0.1 0.08 plw plh];pos41=[hls 0.10+adj 0.10 hlh];
    
    fs=12; fsl=8;
    axes('Position',pos1);
    
    cc=data.(NPool_vars{1})*NPool_factors(1);
    
    for ii=2:length(NPool_vars)
        cc=[cc;data.(NPool_vars{ii})*NPool_factors(ii)];
    end
    
    hh = bar(t1:t2,cc'*14/1e9,0.9,'stacked');
    for jj=1:length(NPool_vars)
        hh(jj).FaceColor = NPool_colors(jj,:)/255;
    end
    
    set(gca,'xlim',[t1 t2]); %,'ylim',[0 2.5]);
    
    datesv=datenum(datess,'yyyymmdd');
    set(gca,'XTick',datesv,'XTickLabel',datestr(datesv,'mm-yy'));
    xlabel('');ylabel({'nitrogen pools','(tonnes)'});
    set(gca,'FontSize',9);
    title('(a) nitrogen pools','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    hl=legend(NPool_names);
    set(hl,'Fontsize',fsl,'Position',pos11);
    
    
    axes('Position',pos2);
    
    data.PHYTO_BURIAL=data.WQ_DIAG_PHY_PHY_SWI_N-data.MPB_RESXNC;
   % data.PHYTO_BURIAL=-data.WQ_DIAG_PHY_MPB_BEN*10/106*0.2;
        
    cc=data.(N_BGC_vars{1})*N_BGC_signs(1)*N_BGC_factors(1);
    
    for ii=2:length(N_BGC_vars)
        cc=[cc;data.(N_BGC_vars{ii})*N_BGC_signs(ii)*N_BGC_factors(ii)];
    end
    
    hh = bar(t1:t2,cc'*14/1e9,0.9,'stacked');
    for jj=1:length(N_BGC_vars)
        hh(jj).FaceColor = N_BGC_colors(jj,:)/255;
    end
    % t1=datenum(2008,1,1);t2=datenum(2009,1,1);
    set(gca,'xlim',[t1 t2]); %,'ylim',[0 0.3]);
    
    datesv=datenum(datess,'yyyymmdd');
    set(gca,'XTick',datesv,'XTickLabel',datestr(datesv,'mm-yy'));
    title('(b) nitrogen sources and sinks (+ve: into water; -ve: into sediment)','FontWeight','Bold','FontSize',fs);
    xlabel('');ylabel({'nitrogen fluxes','(tonnes/day)'});
    
    set(gca,'FontSize',9);
    box on;grid on;
    
    hl=legend(N_BGC_names);
    set(hl,'Fontsize',fsl,'Position',pos21);
        
    axes('Position',pos3);
  
    data.nsnetflux.IN=data.nsnetflux.NIT_amm+data.nsnetflux.NIT_nit;
    data.nsnetflux.ON=data.nsnetflux.OGM_don+data.nsnetflux.OGM_pon;
    data.nsnetflux.PP=data.nsnetflux.MA2_ulva_IN+data.nsnetflux.PHY_grn*0.16...
        +data.nsnetflux.PHY_crypt*0.151+data.nsnetflux.PHY_diatom*0.1+data.nsnetflux.PHY_dino*0.167;
    
    cc3=data.nsnetflux.(N_flux_names{1});
    
    for ii=2:length(N_flux_names)
        cc3=[cc3;data.nsnetflux.(N_flux_names{ii})];
    end
    
    cc31=cc3;
    cc32=cc3;
    
    for mm=1:size(cc3,1)
        for nn=1:size(cc3,2)
            if cc3(mm,nn)>0
                cc31(mm,nn)=0;
            else
                cc32(mm,nn)=0;
            end
        end
    end
    
    hh1 = bar(t1:t2,cc31'*14/1e9,0.9,'stacked');hold on;
    hh2 = bar(t1:t2,cc32'*14/1e9,0.9,'stacked');hold on;
    
    for jj=1:length(N_flux_names)
        hh1(jj).FaceColor = N_flux_colors(jj,:)/255;
        hh2(jj).FaceColor = N_flux_colors(jj,:)/255;
    end
    
    %t1=datenum(2008,1,1);t2=datenum(2009,1,1);
    set(gca,'xlim',[t1 t2]); %,'ylim',[-15 5]);
    
    datesv=datenum(datess,'yyyymmdd');
    set(gca,'XTick',datesv,'XTickLabel',datestr(datesv,'mm-yy'));
    xlabel('');ylabel({'boundary fluxes','(tonnes/day)'});
    %set(gca,'FontSize',9);
    if ss==1
    title('(c) boundary exchange fluxes (+ve: into NCL; -ve: out of NCL)','FontWeight','Bold','FontSize',fs);
    else
        title('(c) boundary exchange fluxes (+ve: into SCL; -ve: out of SCL)','FontWeight','Bold','FontSize',fs);
    end
    box on;grid on;
    
    hl=legend(N_flux_names2);
    set(hl,'Fontsize',fsl,'Position',pos31);
    
    axes('Position',pos4);
    
    for ii=1:length(NPool_vars)
        if ii==1
            Twat=data.(NPool_vars{ii})*NPool_factors(ii);
        else
            Twat=Twat+data.(NPool_vars{ii})*NPool_factors(ii);
        end
    end
    
    for ii=[2:7 9] %2:length(N_BGC_vars)
        if ii==2
            Tsed=data.(N_BGC_vars{ii})*N_BGC_factors(ii);
        else
            Tsed=Tsed+data.(N_BGC_vars{ii})*N_BGC_factors(ii);
        end
    end
    
    Ttran=data.nsnetflux.IN+data.nsnetflux.ON+data.nsnetflux.PP;
    DeltaWat=zeros(size(Twat));
    Sedacc=zeros(size(Twat));
    for jj=2:length(Twat)
        DeltaWat(jj)=Twat(jj)-Twat(jj-1);
    end
    
    DeltaSed=DeltaWat-Ttran;
     for jj=1:length(DeltaSed)
         if jj==1
             Watacc(jj)=DeltaWat(jj);
             Sedacc(jj)=DeltaSed(jj);
             Sedacc2(jj)=Tsed(jj);
         else
             Watacc(jj)=Watacc(jj-1)+DeltaWat(jj);
        Sedacc(jj)=Sedacc(jj-1)+DeltaSed(jj);
        Sedacc2(jj)=Sedacc2(jj-1)+Tsed(jj);
         end
     end
    
    plot(t1:t2,Watacc*14/1e9,'Color',[67,162,202]./255);
    hold on;
    plot(t1:t2,-Sedacc*14/1e9,'Color',[136,86,167]./255);
    hold on;
%      plot(t1:t2,-Sedacc2*14/1e9,'Color','k');
%     hold on;
    
    str1={['total: ',num2str(Watacc(end)*14/1e9,'%4.2f'),' Tonnes']};
%     xx=[t2+5  t2];
%     yy=[Watacc(end)*14/1e9 Watacc(end)*14/1e9];
%     annotation('textarrow',xx,yy,'String',str1);
    text(t2+5,Watacc(end)*14/1e9,str1, 'Color',[67,162,202]./255);
    hold on;
       str1={['total: ',num2str(-Sedacc(end)*14/1e9,'%4.2f'),' Tonnes']};
%     xx=[t2+5  t2];
%     yy=[Watacc(end)*14/1e9 Watacc(end)*14/1e9];
%     annotation('textarrow',xx,yy,'String',str1);
    text(t2+5,-Sedacc(end)*14/1e9,str1, 'Color',[136,86,167]./255);
    
    set(gca,'xlim',[t1 t2]); %,'ylim',[-15 5]);
    
    datesv=datenum(datess,'yyyymmdd');
    set(gca,'XTick',datesv,'XTickLabel',datestr(datesv,'mm-yy'));
    xlabel('');ylabel({'cumulative changes','(tonnes)'});
    %set(gca,'FontSize',9);
    title('(d) cumulative change in nitrogen pools','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    hl=legend('nitrogen in water','nitrogen in sediment');
    set(hl,'Fontsize',fsl,'Position',pos41);
    
   % outputName=[outputfolder,'nutrient_budget_nitrogen_timeseries.png'];
    outputName=[outputfolder,sitenames{ss},'_nitrogen_budget_timeseries.png'];
    print(gcf,'-dpng',outputName);
    
    
    %% plotting
    figure(2);
    def.dimensions = [25 30]; % Width & Height in cm
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
    xSize = def.dimensions(1);
    ySize = def.dimensions(2);
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])  ;
    
    clf;
    
    plh=0.15;
    pos1=[0.1 0.74 0.8 plh];%pos11=[0.87 0.65 0.10 0.20];
    pos2=[0.1 0.52 0.8 plh];%pos21=[0.87 0.20 0.10 0.20];
    pos3=[0.1 0.30 0.8 plh];
    pos4=[0.1 0.08 0.8 plh];
    
    fs=12;
    axes('Position',pos1);
    
    cc=mean(data.(NPool_vars{1})*NPool_factors(1));
    
    for ii=2:length(NPool_vars)
        cc=[cc;mean(data.(NPool_vars{ii}))*NPool_factors(ii)];
    end
    
    hh = bar(1:length(cc),cc'*14/1e9,0.6,'stacked');
    
    set(gca,'xlim',[0 length(cc)+1],'XTick',1:length(cc),'XTickLabel',NPool_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    ylabel({'Carbon pools','(tonnes)'});
    set(gca,'FontSize',9);
    title('(a) Nitrogen pools','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    
    axes('Position',pos2);
    
    cc=mean(data.(N_BGC_vars{1})*N_BGC_signs(1)*N_BGC_factors(1));
    
    for ii=2:length(N_BGC_vars)
        cc=[cc;mean(data.(N_BGC_vars{ii})*N_BGC_signs(ii)*N_BGC_factors(ii))];
    end
    
    hh = bar(1:length(cc),cc'*14/1e9,0.6,'stacked');
    set(gca,'xlim',[0 length(cc)+1],'XTick',1:length(cc),'XTickLabel',N_BGC_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    
    
    title('(b) Nitrogen fluxes','FontWeight','Bold','FontSize',fs);
    xlabel('');ylabel({'Nitrogen fluxes','(tonnes/day)'});
    
    %set(gca,'FontSize',9);
    box on;grid on;
    
    
    axes('Position',pos3);
    
    
    cc3=mean(data.nsnetflux.(N_flux_names{1}));
    
    for ii=2:length(N_flux_names)
        cc3=[cc3;mean(data.nsnetflux.(N_flux_names{ii}))];
    end
    
    hh1 = bar(1:length(cc3),cc3'*14/1e9,0.6,'stacked');hold on;
    
    
    set(gca,'xlim',[0 length(cc3)+1],'XTick',1:length(cc3),'XTickLabel',N_flux_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    
    xlabel('');ylabel({'Boundary fluxes','(tonnes/day)'});
    %set(gca,'FontSize',9);
    title('(d) Boundary Nitrogen fluxes','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    outputName=[outputfolder,'nutrient_budget_Nitrogen_overall.png'];
    print(gcf,'-dpng',outputName);
    
    %% plotting
    figure(3);
    def.dimensions = [25 30]; % Width & Height in cm
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
    xSize = def.dimensions(1);
    ySize = def.dimensions(2);
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])  ;
    
    clf;
    
    plh=0.15;
    pos1=[0.1 0.74 0.8 plh];%pos11=[0.87 0.65 0.10 0.20];
    pos2=[0.1 0.52 0.8 plh];%pos21=[0.87 0.20 0.10 0.20];
    pos3=[0.1 0.30 0.8 plh];
    pos4=[0.1 0.08 0.8 plh];
    
    fs=12;
    axes('Position',pos1);
    
    tmp=data.(NPool_vars{1})*NPool_factors(1);
    cc=tmp(end)-tmp(1);
    %cc=mean(data.(NPool_vars{1})*NPool_factors(1));
    
    for ii=2:length(NPool_vars)
        tmp=data.(NPool_vars{ii})*NPool_factors(ii);
        cc=[cc;tmp(end)-tmp(1)];
        % cc=[cc;mean(data.(NPool_vars{ii}))*NPool_factors(ii)];
    end
    
    hh = bar(1:length(cc),cc'*14/1e9,0.6,'stacked');
    
    set(gca,'xlim',[0 length(cc)+1],'XTick',1:length(cc),'XTickLabel',NPool_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    ylabel({'Carbon pools','(tonnes)'});
    set(gca,'FontSize',9);
    title('(a) Nitrogen pools','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    
    axes('Position',pos2);
    
    cc=sum(data.(N_BGC_vars{1})*N_BGC_signs(1)*N_BGC_factors(1));
    
    for ii=2:length(N_BGC_vars)
        cc=[cc;sum(data.(N_BGC_vars{ii})*N_BGC_signs(ii)*N_BGC_factors(ii))];
    end
    
    hh = bar(1:length(cc),cc'*14/1e9,0.6,'stacked');
    set(gca,'xlim',[0 length(cc)+1],'XTick',1:length(cc),'XTickLabel',N_BGC_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    
    
    title('(b) Nitrogen fluxes','FontWeight','Bold','FontSize',fs);
    xlabel('');ylabel({'Nitrogen fluxes','(tonnes/day)'});
    
    %set(gca,'FontSize',9);
    box on;grid on;
    
   
    axes('Position',pos3);
        
    cc3=sum(data.nsnetflux.(N_flux_names{1}));
    
    for ii=2:length(N_flux_names)
        cc3=[cc3;sum(data.nsnetflux.(N_flux_names{ii}))];
    end
    
    hh1 = bar(1:length(cc3),cc3'*14/1e9,0.6,'stacked');hold on;
    
    
    set(gca,'xlim',[0 length(cc3)+1],'XTick',1:length(cc3),'XTickLabel',N_flux_names); %,'ylim',[0 2.5]);
    xtickangle(25);
    
    xlabel('');ylabel({'Boundary fluxes','(tonnes/day)'});
    %set(gca,'FontSize',9);
    title('(d) Boundary Nitrogen fluxes','FontWeight','Bold','FontSize',fs);
    box on;grid on;
    
    outputName=[outputfolder,'nutrient_budget_Nitrogen_overall_sum.png'];
    print(gcf,'-dpng',outputName);
    
end
