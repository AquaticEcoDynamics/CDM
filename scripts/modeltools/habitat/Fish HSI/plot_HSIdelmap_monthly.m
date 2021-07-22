clear; close all;

scenario = {...
    'Scen1',...  
    };

%  'Base',...
%  'Scen2',...

fish = {...
    'mullowayHSI_del_2019',...
    'breamHSI_del_2019',...
    'gobyHSI_del_2019',...
    'flounderHSI_del_2019',...
    'mulletHSI_del_2019',...
    'congolliHSI_del_2019',...
    'hardyheadHSI_del_2019',...
%  
%     'mullowayHSI_del_2018',...
%     'breamHSI_del_2018',...
%     'gobyHSI_del_2018',...
%     'flounderHSI_del_2018',...
%     'mulletHSI_del_2018',...
%     'congolliHSI_del_2018',...
%     'hardyheadHSI_del_2018',...
% 
%     'mullowayHSI_del_2017',...
%     'breamHSI_del_2017',...
%     'gobyHSI_del_2017',...
%     'flounderHSI_del_2017',...
%     'mulletHSI_del_2017',...
%     'congolliHSI_del_2017',...
%     'hardyheadHSI_del_2017',...
};
  

    
% yrst='2019';
% yrfin='2010';

for n = 1:length(scenario)
for m = 1:length(fish)
    
    dataHSI=load(['E:\Lowerlakes\fishHSI\MER_Coorong_eWater_2020_v1\mat\',scenario{n}, '\',fish{m},'.mat']);


    outdir=['E:\Lowerlakes\fishHSI\MER_Coorong_eWater_2020_v1\plots\',scenario{n},'\'];


    %% plotting S
    hfig = figure('visible','on','position',[304         166        1800         900]);

    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf,'paperposition',[0.635 6.35 36 18])

    %load geo.mat;
    ncfile=['E:\Lowerlakes\Busch_Ruppia_modeloutput\MER_',scenario{n},'_20170701_20200701.nc'];
    dat = tfv_readnetcdf(ncfile,'timestep',1);

    vert(:,1) = dat.node_X;
    vert(:,2) = dat.node_Y;
    faces = dat.cell_node';

    %--% Fix the triangles
    faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

     pos9=[0.96 0.28 0.01 0.3];
     dim=[0.94 0.53 0.1 0.1];

     %%
     var=fieldnames(dataHSI);
     time=dataHSI.(var{1}).(['scen_',scenario{n}]).mdates;

    %time=breamHSI.(['scen_',scens{ii}]).mdates;
    dv=datevec(time);
    dm=dv(:,2); %month
    dy=dv(:,1);  %year
    months={'Jan2020','Feb2020','Mar2020','Apr2020','May2020','Jun2020','Jul2019','Aug2019','Sep2019','Oct2019','Nov2019','Dec2019'};
%     months={'Jan2019','Feb2019','Mar2019','Apr2019','May2019','Jun2019','Jul2018','Aug2018','Sep2018','Oct2018','Nov2018','Dec2018'};
%     months={'Jan2018','Feb2018','Mar2018','Apr2018','May2018','Jun2018','Jul2017','Aug2017','Sep2017','Oct2017','Nov2017','Dec2017'};
    annos={'delMap'};%'overall','salt','temp','DO','Amm',};
    vars={'del'};%'HSI','fS','fT','fO','fA'};
    seasons={'summer','autumn','winter','spring'};

    cax=[0 1];

    for kk=1:length(vars)
        data=dataHSI.(var{1}).(['scen_',scenario{n}]).(vars{kk});
        %data=breamHSI.(['scen_',scens{ii}]).(vars{kk});

    for vv=1:12
    %clf;
    
    
    if vv<7 %to swap jan-jun to bottom, jul-dec to top
    subplot(2,6,vv+6) %2 rows, 6 coloumns, index of figs
    else
        subplot(2,6,vv-6);
    end
    
    
    
    inds=find(dm==vv); %find month in all years
    cdata=mean(data(:,inds),2); 
    %HSIdata.(annos{vv}).(months{sinds(1)})=cdata;
    patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat;
    set(gca,'box','on');

    set(findobj(gca,'type','surface'),...
        'FaceLighting','phong',...
        'AmbientStrength',.3,'DiffuseStrength',.8,...
        'SpecularStrength',.9,'SpecularExponent',25,...
        'BackFaceLighting','unlit');

    caxis(cax);
    axis off;        axis equal;

    text(0.1,0.9,months{vv},...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',12,...
        'fontweight','Bold',...
        'color','k');

    if vv==12
    cb = colorbar;

    set(cb,'position',pos9,...
        'units','normalized','ycolor','k','fontsize',6);

    end
    %annotation('textbox',dim,'String',[annos{vv},' HSI'],'FitBoxToText','on','FontSize',10,'LineStyle','none');

    end


    
    img_name =[fish{m},annos{kk},'_',scenario{n},'.png'];

    
    saveas(gcf,[outdir,img_name]);

    end
    
end   
end