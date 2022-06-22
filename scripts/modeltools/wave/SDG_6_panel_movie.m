clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));
ncfile = 'X:\CDM/eWater2021_basecase_t3_all.nc';

%%
%titles = {'WVHT','TAUB','PICKUP_TOTAL','TSS'}; %DEPOSITION_TOTAL
titles = {'WQ_DIAG_SDG_OPD','WQ_DIAG_SDG_FOM','WQ_DIAG_OGM_DON_SWI','WQ_DIAG_NIT_NIT_DSF','WQ_DIAG_NIT_AMM_DSF','WQ_DIAG_PHY_PHY_SWI_C'}; %DEPOSITION_TOTAL
titles2 = {'SDG-opd','SDG-FOM','OGM-DON-SWI','NIT-NIT-DSF','NIT-AMM-DSF','PHY-pHY-SWI-c'}; %DEPOSITION_TOTAL
conv = [1 1 1 1 1 1];
caxt = [2 1200 2 0.5 2.5 100];
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
%img_dir = 'X:\CDM\hchb_tfvaed_20201101_20210401_v1\check_MA2\';
img_dir = 'SDG_6_Panel\';

if ~exist(img_dir,'dir')
    mkdir(img_dir);
end

sim_name = [img_dir,'SDG_6_Panel.mp4'];

hvid = VideoWriter(sim_name,'MPEG-4');
set(hvid,'Quality',100);
set(hvid,'FrameRate',8);
framepar.resolution = [1024,768];

open(hvid);






t0=datenum('20210101 00:00','yyyymmdd HH:MM');
tt = find(abs(timesteps-t0)==min(abs(timesteps-t0)));
t1=datenum('20210201 00:00','yyyymmdd HH:MM');
tt1 = find(abs(timesteps-t1)==min(abs(timesteps-t1)));
plot_interval=1;
loc=[0.05 0.65 0.45 0.25 ;...
    0.55 0.65  0.45 0.25;...
    0.05 0.35  0.45 0.25;...
    0.55 0.35  0.45 0.25;...
    0.05 0.05  0.45  0.25;...
    0.55 0.05  0.45 0.25];



cbloc =[0.1 0.91 0.35 0.01;...
        0.6 0.91 0.35 0.01;...
        0.1 0.61 0.35 0.01;...
        0.6 0.61 0.35 0.01;...
        0.1 0.31 0.35 0.01;... 
        0.6 0.31 0.35 0.01];
    
    
loc1=[0.43 0.93 0.3 0.05];
loc2=[0.45 0.45 0.3 0.1];

for i=tt:tt1
    
    tdat = tfv_readnetcdf(ncfile,'timestep',i);
    clf;
    for ddd = 1:2
        hfig = figure('position',[304   195   865   783]);
        %hfig = figure('visible','on','position',[304         166        1271         812]);
        set(gcf,'color','w');
    
        for ii=1:length(titles)
            axes('Position',loc(ii,:))
            cdata0=tdat.(titles{ii});
            cdata0 = cdata0 * conv(ii);
            
%             if ii == 2
%                 cdata0 = cdata0 .* tdat.D;
%             end
            
            mapshow('background.png');hold on
            
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
            
            cb = colorbar('southoutside','position',cbloc(ii,:),...
                 'units','normalized','ycolor','k');
            text(0.1,0.1,titles2{ii},'color','w','fontsize',14,'units','normalized');
            %title(titles2{ii});
             %set(cb,);
            
            %colorTitleHandle = get(cb,'Title');
            %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
            hold on;
            %set(gca,'box','on');
            axis on;
            axis equal;
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
            xlim([329676.54864884          385000.597336445]);
            ylim([6012953.07208745          6044465.04246277]);
            
            % set(gca,'xlim',x_lim,'ylim',y_lim);
        end
        
        %str=['Time: ',datestr(timesteps(i),'yyyy-mm-dd HH:MM')];
        str=[datestr(timesteps(i),'yyyy-mm-dd HH:MM')];
%        text(loc1(1),loc1(2),str,'fontsize',14,'HorizontalAlignment','center');
        
        annotation('textbox',loc1,'String',str,'FitBoxToText','on',...
            'FontWeight','bold','FontSize',13,'LineStyle','none','HorizontalAlignment','left');
        
        img_name =[img_dir,datestr(timesteps(i),'yyyymmddHHMM'),'.png'];
        
        %saveas(gcf,img_name);
        writeVideo(hvid,getframe(hfig));
        
        close
    end
end

%   img_name ='snapshot.png';

%   saveas(gcf,img_name);

close(hvid);