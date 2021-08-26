clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
ncfile = 'X:\CDM\hchb_tfvaed_20201101_20210401_v1\output\hchb_wave_20201101_20210401_wq_all.nc';

%%
%titles = {'WVHT','TAUB','PICKUP_TOTAL','TSS'}; %DEPOSITION_TOTAL
titles = {'WVHT','WQ_DIAG_NCS_D_TAUB','WQ_DIAG_NCS_RESUS','WQ_DIAG_TOT_TSS'}; %DEPOSITION_TOTAL
titles2 = {'Wave Height (m)','TAUB','Resuspension (g /m^2/s)','TSS (mg/L)'}; %DEPOSITION_TOTAL
conv = [1 1 86400 1];
caxt = [0.1 0.005 10 20];
%bedmass=ncread(ncfile,'BED_MASS_LAYER_1');

clip_depth = 0.05;% In m
%clip_depth = 999;% In m

%____________


dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

dat = tfv_readnetcdf(ncfile,'timestep',1);
clear funcions

vert(:,1) = dat.node_X;
vert(:,2) = dat.node_Y;

faces = dat.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

%% plotting
img_dir = 'X:\CDM\hchb_tfvaed_20201101_20210401_v1\check_resuspension\';
%img_dir = 'check_resuspension\';

if ~exist(img_dir,'dir')
    mkdir(img_dir);
end


hfig = figure('visible','on','position',[304         166        1271         812]);

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'paperposition',[0.635 6.35 20.32 15.24])


t0=datenum('20201101 00:00','yyyymmdd HH:MM');
tt = find(abs(timesteps-t0)==min(abs(timesteps-t0)));
t1=datenum('20211110 00:00','yyyymmdd HH:MM');
tt1 = find(abs(timesteps-t1)==min(abs(timesteps-t1)));
plot_interval=1;
loc=[0.05 0.6 0.42 0.32;...
    0.55 0.6 0.42 0.32;...
    0.05 0.10 0.42 0.32;...
    0.55 0.10 0.42 0.32];

loc1=[0.40 0.48 0.3 0.05];
loc2=[0.45 0.45 0.3 0.1];

for i=tt:tt1
    
    tdat = tfv_readnetcdf(ncfile,'timestep',i);
    clf;
       
    
    for ii=1:4
        axes('Position',loc(ii,:))
        cdata0=tdat.(titles{ii});
        cdata0 = cdata0 * conv(ii);
        patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata0);shading flat;
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
    %x_lim = [151.12 151.25]; %get(gca,'xlim');
    %y_lim = [-23.82 -23.74]; % get(gca,'ylim');
    %x_lim = get(gca,'xlim');
    %y_lim = get(gca,'ylim');
        
    
        
       caxis([0 caxt(ii)]);
        
        cb = colorbar;
        title(titles2{ii});
        %  set(cb,'position',[0.9 0.1 0.01 0.25],...
        %      'units','normalized','ycolor','k');
        
        %colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
        hold on;
        set(gca,'box','on');
        axis on;
        axis equal;
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        xlim([341475.531003163          397058.488835934]);
        ylim([5995175.029595          6026190.96939533]);
        
       % set(gca,'xlim',x_lim,'ylim',y_lim);
    end
    
    str=['Time: ',datestr(timesteps(i),'yyyy-mm-dd HH:MM')];
    annotation('textbox',loc1,'String',str,'FitBoxToText','on',...
        'FontWeight','bold','FontSize',16,'LineStyle','none');
    
    img_name =[img_dir,datestr(timesteps(i),'yyyymmddHHMM'),'.png'];
    
    saveas(gcf,img_name);
   % writeVideo(hvid,getframe(hfig));
end

%   img_name ='snapshot.png';

%   saveas(gcf,img_name);

%close(hvid);