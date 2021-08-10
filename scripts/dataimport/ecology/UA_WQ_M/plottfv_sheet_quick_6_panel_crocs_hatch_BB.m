clear all; close all; fclose all;

addpath(genpath('tuflowfv'));


%ncfile = 'Z:\Busch\Studysites\Fitzroy\Geike_v3\Output\Fitzroy_wl.nc';
%ncfile = 'K:\Fitzroy\Fitzroy_WL_QN_Long.nc';
ncfile = '../Output/Fitzroy_WL_QN.nc' ;%'K:\Fitzroy\Fitzroy_WL_QN_Long.nc';

outdir = '6 Panel/Crocs/';

imagename = 'Crocs.png';

filename = [outdir,imagename];


%varname = 'WQ_DIAG_LND_SB';
varname1 = 'HATCH';
varname2 = 'WQ_DIAG_HAB_CROCS_HSI_FVEG_3';
varname3 = 'WQ_DIAG_HAB_CROCS_HSI_FSUB_3';
varname4 = 'WQ_DIAG_HAB_CROCS_HSI_FTEM_3';
varname5 = 'WQ_DIAG_HAB_CROCS_HSI_FPSS_3';
varname6 = 'WQ_DIAG_HAB_CROCS_HSI_FDEP_3';

cax1 = [0 1];
cax2 = [0 1];
cax3 = [0 1];
cax4 = [0 1];
cax5 = [0 1];
cax6 = [0 1]

title1 = 'HATCHLING';
title2 = '\Phi_{veg}';
title3 = '\Phi_{sub}';
title4 = '\Phi_{tem}';
title5 = '\Phi_{pss}';
title6 = '\Phi_{dep}';

% These two slow processing down. Only set to 1 if required
create_movie = 1; % 1 to save movie, 0 to just display on screen
save_images = 0;

plot_interval = 4;


%shp = shaperead('Matfiles/Udated_Wetlands.shp');

clip_depth = 999;% In m
%clip_depth = 999;% In m

isTop = 1;

%____________

if create_movie | save_images
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
end


% if create_movie
%     sim_name = [outdir,varname1,'.mp4'];
%     
%     hvid = VideoWriter(sim_name,'MPEG-4');
%     set(hvid,'Quality',100);
%     set(hvid,'FrameRate',12);
%     framepar.resolution = [1024,768];
%     
%     open(hvid);
% end
%__________________


dat = tfv_readnetcdf(ncfile,'time',1);
timesteps = dat.Time;

dat = tfv_readnetcdf(ncfile,'timestep',1);
clear funcions


vert(:,1) = dat.node_X;
vert(:,2) = dat.node_Y;

faces = dat.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

first_plot = 1;

%[~,indBB] = min(abs(timesteps - datenum(2012,07,28)));

%add a search here for your range
sss = find(timesteps >= startdate & timesteps <= enddate)

for i = 1:length(sss)%1:plot_interval:length(timesteps)
    
    tdat = tfv_readnetcdf(ncfile,'timestep',sss(i));
    clear functions
    
 
    
    if isTop
      if strcmpi(varname1,'H') == 0
      %  
      %  cdata1 = tdat.(varname1)(tdat.idx3(tdat.idx3 > 0));
      %  cdata2 = tdat.(varname2)(tdat.idx3(tdat.idx3 > 0));
      %  cdata3 = tdat.(varname3)(tdat.idx3(tdat.idx3 > 0));
        
      %elseif strcmpi(varname1,'PLANT') == 0

 
        tdat.NEST(:,i) = min(double([tdat.WQ_DIAG_HAB_CROCS_HSI_FTEM_1,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FSUB_1,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVEG_1,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVWC_1,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FDEP_1,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FPSS_1]),[],2);
        tdat.EGGS(:,i) = min(double([tdat.WQ_DIAG_HAB_CROCS_HSI_FTEM_2,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FSUB_2,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVEG_2,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVWC_2,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FDEP_2,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FPSS_2]),[],2);
        tdat.HATCH(:,i) = min(double([tdat.WQ_DIAG_HAB_CROCS_HSI_FTEM_3,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FSUB_3,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVEG_3,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FVWC_3,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FDEP_3,...
          tdat.WQ_DIAG_HAB_CROCS_HSI_FPSS_3]),[],2);

        cdata1(:,i) = tdat.(varname1)(tdat.idx3(tdat.idx3 > 0));
        cdata2(:,i) = tdat.(varname2)(tdat.idx3(tdat.idx3 > 0));
        cdata3(:,i) = tdat.(varname3)(tdat.idx3(tdat.idx3 > 0));
        cdata4(:,i) = tdat.(varname4)(tdat.idx3(tdat.idx3 > 0));
        cdata5(:,i) = tdat.(varname5)(tdat.idx3(tdat.idx3 > 0));
        cdata6(:,i) = tdat.(varname6)(tdat.idx3(tdat.idx3 > 0));

      else
          
        cdata1(:,i) = tdat.(varname1);
        cdata2(:,i) = tdat.(varname2);
        cdata3(:,i) = tdat.(varname3);
        cdata4(:,i) = tdat.(varname4);
        cdata5(:,i) = tdat.(varname5);
        cdata6(:,i) = tdat.(varname6);
        
      end
    else
    
    bottom_cells(1:length(tdat.idx3)-1) = tdat.idx3(2:end) - 1;
    bottom_cells(length(tdat.idx3)) = length(tdat.idx3);
    
    cdata1(:,i) = tdat.(varname1)(bottom_cells);
    cdata2(:,i) = tdat.(varname2)(bottom_cells);
    cdata3(:,i) = tdat.(varname3)(bottom_cells);
    cdata4(:,i) = tdat.(varname4)(bottom_cells);
    cdata5(:,i) = tdat.(varname5)(bottom_cells);
    cdata6(:,i) = tdat.(varname6)(bottom_cells);
    
    end
    
   Depth = tdat.D;
    
    
    if clip_depth < 900
    
        Depth(Depth < clip_depth) = 0;
    
        cdata1(Depth == 0,i) = NaN;
        cdata2(Depth == 0,i) = NaN;
        cdata3(Depth == 0,i) = NaN;
        cdata4(Depth == 0,i) = NaN;
        cdata5(Depth == 0,i) = NaN;
        cdata6(Depth == 0,i) = NaN;
    end
    
    if strcmpi(varname1,'WQ_TRC_RET') == 1
        cdata1(:,i) = cdata1(:,i) ./ 86400;
    end
    
    
end
  
%Now you have to compress everything down to one timestep.......


    
    
    %if first_plot
        
        hfig = figure('visible','on','position',[10.67          10.33                      1450          1080]);
        
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf,'paperposition',[0.635 6.35 20.32 15.24])
        
        axes('position',[0 0.5 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on
        
        patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata1);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        %mapshow(shp,'EdgeColor','k','facecolor','none');hold on
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax1);
        
        cb = colorbar;
        
        set(cb,'position',[0.27 0.6 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
                axis off
        axis equal
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);

        
        text(0.1,0.8,title1,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');
        
        txtDate = text(0.4,0.1,datestr(timesteps(i),'dd mmm yyyy HH:MM'),...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',21,...
            'color','k');
        
        
        
        %_____________________________________
        
        axes('position',[0.3334 0.5 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on  
        
        patFig2 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata2);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
         
        
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax2);
        
        cb = colorbar;
        
        set(cb,'position',[0.6 0.2 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
        
        
        axis off
        axis equal
        
        text(0.1,0.8,title2,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');
        
%         txtDate = text(0.1,0.1,datestr(timesteps(i),'dd mmm yyyy HH:MM'),...
%             'Units','Normalized',...
%             'Fontname','Candara',...
%             'Fontsize',21,...
%             'color','k');
        
        
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);

        
        %_____________________________________
        
        axes('position',[0.6667 0.5 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on  
        
        patFig3 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata3);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
         
        
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax3);
        
        cb = colorbar;
        
        set(cb,'position',[0.94 0.6 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
        
        
        axis off
        axis equal
        
        text(0.1,0.8,title3,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');
        
%         txtDate = text(0.1,0.1,datestr(timesteps(i),'dd mmm yyyy HH:MM'),...
%             'Units','Normalized',...
%             'Fontname','Candara',...
%             'Fontsize',21,...
%             'color','k');
        
        
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);
        
        
        
        
      %%%  NEXT LAYER
        
        
             axes('position',[0 0.0 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on
        
        patFig4 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata4);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
        %mapshow(shp,'EdgeColor','k','facecolor','none');hold on
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax4);
        
        cb = colorbar;
        
        set(cb,'position',[0.27 0.1 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
                axis off
        axis equal
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);

        
        text(0.1,0.8,title4,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');
        
%         txtDate = text(0.4,0.1,datestr(timesteps(i),'dd mmm yyyy HH:MM'),...
%             'Units','Normalized',...
%             'Fontname','Candara',...
%             'Fontsize',21,...
%             'color','k');
%         
        %_____________________________________
        
        axes('position',[0.3334 0.0 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on  
        
        patFig5 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata5);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
         
        
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax5);
        
        cb = colorbar;
        
        set(cb,'position',[0.6 0.1 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);
        
        
        axis off
        axis equal
        
        text(0.1,0.8,title5,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');
        
%         txtDate = text(0.1,0.1,datestr(timesteps(i),'dd mmm yyyy HH:MM'),...
%             'Units','Normalized',...
%             'Fontname','Candara',...
%             'Fontsize',21,...
%             'color','k');
        
        
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);

        
        %_____________________________________
        
        axes('position',[0.6667 0.0 0.333 0.5]);
        
        mapshow('BW_Background.jpg');hold on  
        
        patFig6 = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata6);shading flat
        set(gca,'box','on');
        
        set(findobj(gca,'type','surface'),...
            'FaceLighting','phong',...
            'AmbientStrength',.3,'DiffuseStrength',.8,...
            'SpecularStrength',.9,'SpecularExponent',25,...
            'BackFaceLighting','unlit');
        
         
        
        
        x_lim = get(gca,'xlim');
        y_lim = get(gca,'ylim');
        
        caxis(cax6);
        
        cb = colorbar;
        
        set(cb,'position',[0.94 0.1 0.01 0.22],...
            'units','normalized','ycolor','k');
        
        colorTitleHandle = get(cb,'Title');
        %set(colorTitleHandle ,'String',regexprep(varname,'_',' '),'color','k','fontsize',10);       
        
        axis off
        axis equal
        
        text(0.1,0.8,title6,...
            'Units','Normalized',...
            'Fontname','Candara',...
            'Fontsize',16,...
            'fontweight','Bold',...
            'color','k');        
        
        xlim([ 785004.723618963         791126.213209792]);
        ylim([7995666.8354314          8001892.95856345]);
        
        
        
        
        
        
        
        
        
        first_plot = 0;
        
        

    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'paperposition',[0.635                      6.35                     20.32                     15.24])

    
    print(gcf,'-dpng',filename,'-opengl');
    
    %     else
%         
%         set(patFig1,'Cdata',cdata1);
%         drawnow;
%         set(patFig2,'Cdata',cdata2);
%         drawnow;
%         set(patFig3,'Cdata',cdata3);
%         drawnow;
%         set(patFig4,'Cdata',cdata4);
%         drawnow;
%         set(patFig5,'Cdata',cdata5);
%         drawnow;
%         set(patFig6,'Cdata',cdata6);
%         drawnow;
%         
%         set(txtDate,'String',datestr(timesteps(i),'dd mmm yyyy HH:MM'));
%         
%        % caxis(cax);
% 
%     end
%     
%     if create_movie
%         
%        % F = fig2frame(hfig,framepar); % <-- Use this
%         
%         % Add the frame to the video object
%     writeVideo(hvid,getframe(hfig));
%     end
%     
%     if save_images
%     
%         img_dir = [outdir,varname,'/'];
%         if ~exist(img_dir,'dir')
%             mkdir(img_dir);
%         end
%         
%         img_name =[img_dir,datestr(timesteps(i),'yyyymmddHHMM'),'.png'];
%         
%         saveas(gcf,img_name);
%         
%     end
%     clear data cdata
% end
% 
% if create_movie
%     % Close the video object. This is important! The file may not play properly if you don't close it.
%     close(hvid);
% end
% 
% clear all;