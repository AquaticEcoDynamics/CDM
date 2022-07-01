clear; close all;

addpath(genpath('tuflowfv'));

scenarios = {...
    'hchb_Gen2_201707_202201_all',...
    'hchb_Gen2_201707_202201_noeWater_all',...
    'hchb_Gen2_201707_202201_noSE_all',...
    'hchb_Gen2_201707_202201_scen3a_all',...
    'hchb_Gen2_201707_202201_scen3b_all',...

    };

scentext = {...
    'HCHB Base Case',...
    'HCHB No e-Water',...
    'HCHB No SE',...
    'HCHB Designed',...
    'HCHB No Barrage',...       
    };

modname = '_hchbRuppiaGen2_';


% outdir2 = ['C:\Users\00101765\AED Dropbox\AED_Coorong_db\7_hchb\Ruppia\Model update trial\'];

min_size = 30000;

 year_array = 2018:2021; % 2018:2019;


%download_files;%(min_size);

for i = 1:length(scenarios)
    
    filename = ['D:\HCHB_GEN2_4yrs_20220620_v2\',scenarios{i},'.nc'];
    
    % determine file size
    
    if exist(filename,'file')
        
        f = dir(filename);
        
        if f.bytes > min_size
%             
%             if scenarios{i}(end-20:end-17) == num2str(2013)
%                 year_array = 2013:2015;
%             else
%                 year_array = 2016:2018;
%             end
                           
            
            for j=1:length(year_array)
                 
                 
                outdir = ['D:\HCHB_GEN2_4yrs_20220620_v2\Plotting_Ruppia\',scenarios{i},'\Sheets\',num2str(year_array(j)),'\'];
                outdirshp = [outdir,'\shp\'];
                
                if ~exist(outdir,'dir')
                    mkdir(outdir);
                end
                
                if ~exist(outdirshp,'dir')
                    mkdir(outdirshp);
                end
                                         
                
%      % Plots to the sheets directory

          %default timeframe
                outdir_malg_f   = [outdir,'\malg\'];               
                outdir_lim1_f   = [outdir,'\1_adult_new\'];
                outdir_lim2_f   = [outdir,'\2_flower_new\'];             
                outdir_lim3_f   = [outdir,'\3_seed_new\'];
                outdir_lim4_f   = [outdir,'\4_turion_new\'];               
                outdir_lim5_f   = [outdir,'\5_sprout_new\'];
                outdir_lim6_f   = [outdir,'\6_viability\'];
                
                
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_1_combo_f(filename,outdir_lim1_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_2_combo_f(filename,outdir_lim2_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_3_combo_f(filename,outdir_lim3_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_4_combo_f(filename,outdir_lim4_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_5_combo_f(filename,outdir_lim5_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_6_combo_f(filename,outdir_lim6_f,scenarios{i},year_array(j));
                plottfv_averaged_4_panel_coorong_sheet_inserts_malg_f(filename,outdir_malg_f,year_array(j));%default is to Nov
                
                % The stand alone plot
                hsi1      = load([outdir,'\1_adult_new\HSI_adult.mat']);
                hsi2      = load([outdir,'\2_flower_new\HSI_flower.mat']);
                hsi3      = load([outdir,'\3_seed_new\HSI_seed.mat']);
                hsi4      = load([outdir,'\4_turion_new\HSI_turion.mat']);
                hsi5      = load([outdir,'\5_sprout_new\HSI_sprout.mat']);
                hsi6      = load([outdir,'\6_viability\HSI_turionviability.mat']);
                hsiulva   = load([outdir,'\malg\ULVA_hsi.mat']);
                biomassulva = load([outdir,'\malg\ULVA_BIOMASS.mat']);
                benthiculva = load([outdir,'\malg\ULVA_BENTHIC.mat']);
                               
                hsi_viab_sprout = min(hsi6.min_cdata, hsi5.min_cdata);
                hsi_seed_sprout = max(hsi3.min_cdata, hsi_viab_sprout);
                hsi_seed_spr_adt = min(hsi_seed_sprout, hsi1.min_cdata);
                
                
        if i == 1   % for basecase validation only      
                                  
              % convert to shp
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_germ_spr',modname, num2str(year_array(j)),'.shp'],'HSI',hsi_seed_sprout); 
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_viab_spr',modname, num2str(year_array(j)),'.shp'],'HSI',hsi_viab_sprout); 
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_adult',modname, num2str(year_array(j)),'.shp'],'HSI',hsi1.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_flower',modname, num2str(year_array(j)),'.shp'],'HSI',hsi2.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_turion', modname,num2str(year_array(j)),'.shp'],'HSI',hsi4.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_viability', modname,num2str(year_array(j)),'.shp'],'HSI',hsi6.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_germ_spr_adt', modname,num2str(year_array(j)),'.shp'],'HSI',hsi_seed_spr_adt);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_ulva', modname,num2str(year_array(j)),'_11.shp'],'HSI',hsiulva.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'BIOMASS_ulva', modname,num2str(year_array(j)),'_11.shp'],'HSI',biomassulva.ave_data);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'BENTHIC_ulva', modname,num2str(year_array(j)),'_11.shp'],'HSI',benthiculva.ave_data);
                
          
          %integrate for 2020-2021 (for validation) (up to end of Oct, in addition to default)
          if year_array(j) == 2020 || year_array(j) == 2021
  
                outdir_lim1_f_n = [outdir,'\1_adult_new_nov\']; %for 2021 only
                outdir_lim2_f_o = [outdir,'\2_flower_new_oct\'];
                outdir_lim4_f_o = [outdir,'\4_turion_new_oct\'];
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_1_combo_f_n(filename,outdir_lim1_f_n,scenarios{i},year_array(j));  %to Nov 
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_2_combo_f_o(filename,outdir_lim2_f_o,scenarios{i},year_array(j)); %Sep to Oct 
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_4_combo_f_o(filename,outdir_lim4_f_o,scenarios{i},year_array(j)); %Sep to Oct 
                
                hsi1_n    = load([outdir,'\1_adult_new_nov\HSI_adult.mat']);
                hsi2_o    = load([outdir,'\2_flower_new_oct\HSI_flower.mat']);
                hsi4_o    = load([outdir,'\4_turion_new_oct\HSI_turion.mat']);
                
                hsi_seed_spr_adt_nov = min(hsi_seed_sprout, hsi1_n.min_cdata);
                
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_germ_spr_adt', modname,num2str(year_array(j)),'_11.shp'],'HSI',hsi_seed_spr_adt_nov);                
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_flower',modname, num2str(year_array(j)),'_10.shp'],'HSI',hsi2_o.min_cdata);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_turion', modname,num2str(year_array(j)),'_10.shp'],'HSI',hsi4_o.min_cdata);
          end      
                
          %integrate for 2018 (for validation) (adult up to end of Jun/Dec, in addition to default)
          if year_array(j) == 2018

                outdir_lim1_f_j   = [outdir,'\1_adult_new_jun\'];
                outdir_lim1_f_d   = [outdir,'\1_adult_new_dec\'];
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_1_combo_f_j(filename,outdir_lim1_f_j,scenarios{i},year_array(j));  %to Jun 30
                plottfv_averaged_4_panel_coorong_sheet_inserts_lims_1_combo_f_d(filename,outdir_lim1_f_d,scenarios{i},year_array(j));  %to Dec
                
                hsi1_j    = load([outdir,'\1_adult_new_jun\HSI_adult.mat']);
                hsi1_d    = load([outdir,'\1_adult_new_dec\HSI_adult.mat']);
                
                hsi_seed_spr_adt_jun = min(hsi_seed_sprout, hsi1_j.min_cdata);
                hsi_seed_spr_adt_dec = min(hsi_seed_sprout, hsi1_d.min_cdata);

                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_germ_spr_adt', modname,num2str(year_array(j)),'_6.shp'],'HSI',hsi_seed_spr_adt_jun);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_germ_spr_adt', modname,num2str(year_array(j)),'_12.shp'],'HSI',hsi_seed_spr_adt_dec);
          end      
        end     

%                                              
% %               %old (Aug-Sep)
% %               outdir_malg_f_s   = [outdir,'\malg_sep\'];
% %               outdir_lim2_f_s = [outdir,'\2_flower_new_sep\'];
% %               outdir_lim4_f_s = [outdir,'\4_turion_new_sep\'];
% %               plottfv_averaged_4_panel_coorong_sheet_inserts_malg_f_s(filename,outdir_malg_f_s,year_array(j));   %to Sep only       
% %               plottfv_averaged_4_panel_coorong_sheet_inserts_lims_2_combo_f_s(filename,outdir_lim2_f_s,scenarios{i},year_array(j)); %Aug to Sep only   
% %               plottfv_averaged_4_panel_coorong_sheet_inserts_lims_4_combo_f_s(filename,outdir_lim4_f_s,scenarios{i},year_array(j)); %Aug to Sep only
%                
% %               hsi2_s    = load([outdir,'\2_flower_new_sep\HSI_flower.mat']);
% %               hsi4_s    = load([outdir,'\4_turion_new_sep\HSI_turion.mat']);
% %               hsiulva_s = load([outdir,'\malg_sep\ULVA_hsi.mat']);
%                 
% %               convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_flower',modname, num2str(year_array(j)),'_9.shp'],'HSI',hsi2_s.min_cdata);
% %               convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_turion', modname,num2str(year_array(j)),'_9.shp'],'HSI',hsi4_s.min_cdata);
% %               convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_ulva', modname,num2str(year_array(j)),'_9.shp'],'HSI',hsiulva_s.min_cdata);
                
%%                
                
                %___________________________________________________________
                %MH BUM
                dat = tfv_readnetcdf(filename,'time',1);
                timesteps = dat.Time;
                dat = tfv_readnetcdf(filename,'timestep',1);
                tt = tfv_readnetcdf(filename,'names',{'cell_A'});
                Area = tt.cell_A;
                
                data = tfv_readnetcdf(filename,'names',{'SAL';'D'});
                
                vert = [];
                faces = [];
                
                vert(:,1) = dat.node_X;
                vert(:,2) = dat.node_Y;
                faces = dat.cell_node';
                faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);
                %MH BUM
                %___________________________________________________________

                
                
                            
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % WHOLE COORONG PLOTS
                chsi=1;
                chsl=0.;
                
                % Sexual whole year %%%%%%%%%%%%%%%%%%''
                
%                 hsi_sexual = [ hsi1.min_cdata hsi2.min_cdata hsi3.min_cdata];
%                 min_cdata = min(hsi_sexual,[],2);
                
        
                hsi_sexual = [ hsi1.min_cdata hsi2.min_cdata hsi_seed_sprout];
                min_cdata = min(hsi_sexual,[],2);

                
                hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
                
                
                axes('position',[ -0.18 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
                set(gca,'box','on');
                
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                camroll(-25)
                
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                cb = colorbar('location','South','orientation','horizontal');
                set(cb,'position',[0.05 0.15 0.25 0.01]);
                
                text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
               
                
                axes('position',[ -0.06 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2.min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.40,0.75,'Flower','Units','Normalized','fontsize',12);
                
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.41,0.75,'Seed','Units','Normalized','fontsize',12);
                
                
                axes('position',[ -0.3 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
                text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',10);
                
                
                axes('position',[ 0.26 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.42,0.95,'HSI (sexual)','Units','Normalized','fontsize',12);
                
                
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                xSize = 18;
                ySize = 20;
                xLeft = (21-xSize)/2;
                yTop = (30-ySize)/2;
                set(gcf,'paperposition',[0 0 xSize ySize])
                
                saveas(gcf,[outdir,'HSI_sexual.png']);
                
                save([outdir,'HSI_sexual.mat'],'min_cdata','-mat');
                export_area([outdir,'HSI_sexual.csv'],min_cdata,Area);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_sexual',modname, num2str(year_array(j)),'_12.shp'],'HSI',min_cdata);
                
%%                
                % Asexual whole year %%%%%%%%%%%%%%%%%%''
                
%                 hsi_asexual = [ hsi1.min_cdata hsi4.min_cdata hsi5.min_cdata];
%                 min_cdata = min(hsi_asexual,[],2);


                hsi_asexual = [ hsi1.min_cdata hsi4.min_cdata hsi_seed_sprout];               
                min_cdata = min(hsi_asexual,[],2);
                chsi=1.0;
                
                %%%%%%%%%%%%%%%%%%''
                hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
                
                
                axes('position',[ -0.18 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
                set(gca,'box','on');
                
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                camroll(-25)
                
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                cb = colorbar('location','South','orientation','horizontal');
                set(cb,'position',[0.05 0.15 0.25 0.01]);
                
                text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
               
                
                axes('position',[ -0.06 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi4.min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.40,0.75,'Turion','Units','Normalized','fontsize',12);
                
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi5.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.40,0.75,'Sprout','Units','Normalized','fontsize',12);
                
                
                axes('position',[ -0.3 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
                text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',10);
                
                
                axes('position',[ 0.26 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.42,0.95,'HSI (asexual)','Units','Normalized','fontsize',12);
                
                
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                xSize = 18;
                ySize = 20;
                xLeft = (21-xSize)/2;
                yTop = (30-ySize)/2;
                set(gcf,'paperposition',[0 0 xSize ySize])
                
                saveas(gcf,[outdir,'HSI_asexual.png']);
                
                save([outdir,'HSI_asexual.mat'],'min_cdata','-mat');
                export_area([outdir,'HSI_asexual.csv'],min_cdata,Area);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_asexual',modname, num2str(year_array(j)),'_12.shp'],'HSI',min_cdata);
             
                         
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %sexual and asexual combined
                hsi_sexual = load ([outdir,'\HSI_sexual.mat']);
                hsi_asexual = load ([outdir,'\HSI_asexual.mat']);
                hsi_combined = max(hsi_sexual.min_cdata, hsi_asexual.min_cdata);
                chsi=1.0;
                
                
                hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
                
                
                
                
                axes('position',[ -0.30 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_sexual.min_cdata);shading flat
                set(gca,'box','on');
                
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                camroll(-25)
                
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                cb = colorbar('location','South','orientation','horizontal');
                set(cb,'position',[0.05 0.15 0.25 0.01]);
                
                text(0.35,0.75,'HSI (sexual)','fontsize',12,'units','normalized');
                text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j))],'Units','Normalized','fontsize',10);
                
    
                
                axes('position',[ -0.06 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_asexual.min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.34,0.75,'HSI (asexual)','Units','Normalized','fontsize',12);
                        
                
                
                axes('position',[ 0.26 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_combined);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.42,0.95,'HSI (combined)','Units','Normalized','fontsize',12);
                
                
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                xSize = 18;
                ySize = 20;
                xLeft = (21-xSize)/2;
                yTop = (30-ySize)/2;
                set(gcf,'paperposition',[0 0 xSize ySize])
                
                saveas(gcf,[outdir,'HSI_combined.png']);
                
                save([outdir,'HSI_combined.mat'],'hsi_combined','-mat');
                export_area([outdir,'HSI_combined.csv'],hsi_combined,Area);
                convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_combined',modname, num2str(year_array(j)),'_12.shp'],'HSI',hsi_combined);
                
 %%
                % Adult plant Jan - Sep (for HCHB scenarios) %%%%%%%%%%%%%%%%%%''
                
                hsi_seed_spr_adt = min(hsi_seed_sprout, hsi1.min_cdata);
                min_cdata = hsi_seed_spr_adt;
%                 hsi_asexual_n = [ hsi1.min_cdata hsi4_o.min_cdata hsi_seed_sprout];               
%                 min_cdata = min(hsi_asexual_n,[],2);
                chsi=1.0;
                
                %%%%%%%%%%%%%%%%%%''
                hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
                
                
                axes('position',[ -0.3 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
                set(gca,'box','on');
                
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                camroll(-25)
                
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                cb = colorbar('location','South','orientation','horizontal');
                set(cb,'position',[0.05 0.15 0.25 0.01]);
                
                text(0.40,0.75,'Germ&Sprout','fontsize',12,'units','normalized');
               
                
                axes('position',[ -0.06 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.40,0.75,'Adult','Units','Normalized','fontsize',12);
                

                
                axes('position',[ 0.26 0.0  1.0 1.0]);
                patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData', min_cdata);shading flat
                set(gca,'box','on');
                set(findobj(gca,'type','surface'),...
                    'FaceLighting','phong',...
                    'AmbientStrength',.3,'DiffuseStrength',.8,...
                    'SpecularStrength',.9,'SpecularExponent',25,...
                    'BackFaceLighting','unlit');
                
                caxis([ chsl chsi]);
                axis equal
                axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
                camroll(-25)
                
                text(0.42,0.95,'HSI (germination+sprout+adult)','Units','Normalized','fontsize',12);
                
                
                set(gcf, 'PaperPositionMode', 'manual');
                set(gcf, 'PaperUnits', 'centimeters');
                xSize = 18;
                ySize = 20;
                xLeft = (21-xSize)/2;
                yTop = (30-ySize)/2;
                set(gcf,'paperposition',[0 0 xSize ySize])
                
                saveas(gcf,[outdir,'HSI_germ_spr_adt.png']);
                
                save([outdir,'HSI_germ_spr_adt.mat'],'min_cdata','-mat');
                export_area([outdir,'HSI_germ_spr_adt.csv'],min_cdata,Area);
%                 convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_asexual',modname, num2str(year_array(j)),'_10.shp'],'HSI',min_cdata);           
                          

                    
 %%         
 
%        if i == 1   % for basecase validation only 
%            
%            
%                 % Sexual up to Oct (for validation) %%%%%%%%%%%%%%%%%%''
%    
%             if year_array(j) == 2020 || year_array(j) == 2021
%                     
%                 hsi_sexual_o = [ hsi1.min_cdata hsi2_o.min_cdata hsi_seed_sprout];
%                 min_cdata = min(hsi_sexual_o,[],2);
% 
%                 
%                 hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
%                 
%                 
%                 axes('position',[ -0.18 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
%                 set(gca,'box','on');
%                 
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 camroll(-25)
%                 
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 cb = colorbar('location','South','orientation','horizontal');
%                 set(cb,'position',[0.05 0.15 0.25 0.01]);
%                 
%                 text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
%                
%                 
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2_o.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.40,0.75,'Flower','Units','Normalized','fontsize',12);
%                 
% %                 axes('position',[ -0.06 0.0  1.0 1.0]);
% %                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3.min_cdata);shading flat
% %                 set(gca,'box','on');
% %                 set(findobj(gca,'type','surface'),...
% %                     'FaceLighting','phong',...
% %                     'AmbientStrength',.3,'DiffuseStrength',.8,...
% %                     'SpecularStrength',.9,'SpecularExponent',25,...
% %                     'BackFaceLighting','unlit');
% %                 
% %                 caxis([ chsl chsi]);
% %                 axis equal
% %                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
% %                 camroll(-25)
% %                 
% %                 text(0.41,0.75,'Seed','Units','Normalized','fontsize',12);
%                 
%                 
%                 axes('position',[ -0.3 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
%                 text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j)),'\_10'],'Units','Normalized','fontsize',10);
%                 
%                 
%                 axes('position',[ 0.26 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.42,0.95,'HSI (sexual)','Units','Normalized','fontsize',12);
%                 
%                 
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 xSize = 18;
%                 ySize = 20;
%                 xLeft = (21-xSize)/2;
%                 yTop = (30-ySize)/2;
%                 set(gcf,'paperposition',[0 0 xSize ySize])
%                 
%                 saveas(gcf,[outdir,'HSI_sexual_oct.png']);
%                 
%                 save([outdir,'HSI_sexual_oct.mat'],'min_cdata','-mat');
%                 export_area([outdir,'HSI_sexual_oct.csv'],min_cdata,Area);
%                 convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_sexual',modname, num2str(year_array(j)),'_10.shp'],'HSI',min_cdata);
% 
%                
%                  % Asexual up to oct (for validation) %%%%%%%%%%%%%%%%%%''
%                 
% 
%                 hsi_asexual_n = [ hsi1.min_cdata hsi4_o.min_cdata hsi_seed_sprout];               
%                 min_cdata = min(hsi_asexual_n,[],2);
%                 chsi=1.0;
%                 
%                 %%%%%%%%%%%%%%%%%%''
%                 hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
%                 
%                 
%                 axes('position',[ -0.18 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
%                 set(gca,'box','on');
%                 
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 camroll(-25)
%                 
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 cb = colorbar('location','South','orientation','horizontal');
%                 set(cb,'position',[0.05 0.15 0.25 0.01]);
%                 
%                 text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
%                
%                 
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi4_o.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.40,0.75,'Turion','Units','Normalized','fontsize',12);
%                 
% %                 axes('position',[ -0.06 0.0  1.0 1.0]);
% %                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi5.min_cdata);shading flat
% %                 set(gca,'box','on');
% %                 set(findobj(gca,'type','surface'),...
% %                     'FaceLighting','phong',...
% %                     'AmbientStrength',.3,'DiffuseStrength',.8,...
% %                     'SpecularStrength',.9,'SpecularExponent',25,...
% %                     'BackFaceLighting','unlit');
% %                 
% %                 caxis([ chsl chsi]);
% %                 axis equal
% %                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
% %                 camroll(-25)
% %                 
% %                 text(0.40,0.75,'Sprout','Units','Normalized','fontsize',12);
%                 
%                 
%                 axes('position',[ -0.3 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
%                 text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j)),'\_10'],'Units','Normalized','fontsize',10);
%                 
%                 
%                 axes('position',[ 0.26 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.42,0.95,'HSI (asexual)','Units','Normalized','fontsize',12);
%                 
%                 
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 xSize = 18;
%                 ySize = 20;
%                 xLeft = (21-xSize)/2;
%                 yTop = (30-ySize)/2;
%                 set(gcf,'paperposition',[0 0 xSize ySize])
%                 
%                 saveas(gcf,[outdir,'HSI_asexual_oct.png']);
%                 
%                 save([outdir,'HSI_asexual_oct.mat'],'min_cdata','-mat');
%                 export_area([outdir,'HSI_asexual_oct.csv'],min_cdata,Area);
%                 convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_asexual',modname, num2str(year_array(j)),'_10.shp'],'HSI',min_cdata);           
%             end   
%        end  
            
                             
%%                   
%                % Sexual up to Sep %%%%%%%%%%%%%%%%%%'' (old)
%    
%                       
%                 hsi_sexual_s = [ hsi1.min_cdata hsi2_s.min_cdata hsi_seed_sprout];
%                 min_cdata = min(hsi_sexual_s,[],2);
% 
%                 
%                 hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
%                 
%                 
%                 axes('position',[ -0.18 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
%                 set(gca,'box','on');
%                 
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 camroll(-25)
%                 
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 cb = colorbar('location','South','orientation','horizontal');
%                 set(cb,'position',[0.05 0.15 0.25 0.01]);
%                 
%                 text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
%                
%                 
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi2_s.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.40,0.75,'Flower','Units','Normalized','fontsize',12);
%                 
% %                 axes('position',[ -0.06 0.0  1.0 1.0]);
% %                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi3.min_cdata);shading flat
% %                 set(gca,'box','on');
% %                 set(findobj(gca,'type','surface'),...
% %                     'FaceLighting','phong',...
% %                     'AmbientStrength',.3,'DiffuseStrength',.8,...
% %                     'SpecularStrength',.9,'SpecularExponent',25,...
% %                     'BackFaceLighting','unlit');
% %                 
% %                 caxis([ chsl chsi]);
% %                 axis equal
% %                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
% %                 camroll(-25)
% %                 
% %                 text(0.41,0.75,'Seed','Units','Normalized','fontsize',12);
%                 
%                 
%                 axes('position',[ -0.3 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
%                 text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j)),'\_9'],'Units','Normalized','fontsize',10);
%                 
%                 
%                 axes('position',[ 0.26 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.42,0.95,'HSI (sexual)','Units','Normalized','fontsize',12);
%                 
%                 
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 xSize = 18;
%                 ySize = 20;
%                 xLeft = (21-xSize)/2;
%                 yTop = (30-ySize)/2;
%                 set(gcf,'paperposition',[0 0 xSize ySize])
%                 
%                 saveas(gcf,[outdir,'HSI_sexual_sep.png']);
%                 
%                 save([outdir,'HSI_sexual_sep.mat'],'min_cdata','-mat');
%                 export_area([outdir,'HSI_sexual_sep.csv'],min_cdata,Area);
%                 convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_sexual',modname, num2str(year_array),'_9.shp'],'HSI',min_cdata);    



%                  % Asexual up to sep %%%%%%%%%%%%%%%%%%''
%                 
% 
%                 hsi_asexual_s = [ hsi1.min_cdata hsi4_s.min_cdata hsi_seed_sprout];               
%                 min_cdata = min(hsi_asexual_s,[],2);
%                 chsi=1.0;
%                 
%                 %%%%%%%%%%%%%%%%%%''
%                 hfig = figure('visible','on','position',[2.7497e+03 406.3333 1.2813e+03 1207.3333]);
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 set(gcf,'paperposition',[0.635 6.35 20.32 30.24])
%                 
%                 
%                 axes('position',[ -0.18 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi1.min_cdata);shading flat
%                 set(gca,'box','on');
%                 
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 camroll(-25)
%                 
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 cb = colorbar('location','South','orientation','horizontal');
%                 set(cb,'position',[0.05 0.15 0.25 0.01]);
%                 
%                 text(0.40,0.75,'Adult','fontsize',12,'units','normalized');
%                
%                 
%                 axes('position',[ -0.06 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi4_s.min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.40,0.75,'Turion','Units','Normalized','fontsize',12);
%                 
% %                 axes('position',[ -0.06 0.0  1.0 1.0]);
% %                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi5.min_cdata);shading flat
% %                 set(gca,'box','on');
% %                 set(findobj(gca,'type','surface'),...
% %                     'FaceLighting','phong',...
% %                     'AmbientStrength',.3,'DiffuseStrength',.8,...
% %                     'SpecularStrength',.9,'SpecularExponent',25,...
% %                     'BackFaceLighting','unlit');
% %                 
% %                 caxis([ chsl chsi]);
% %                 axis equal
% %                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
% %                 camroll(-25)
% %                 
% %                 text(0.40,0.75,'Sprout','Units','Normalized','fontsize',12);
%                 
%                 
%                 axes('position',[ -0.3 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',hsi_seed_sprout);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.33,0.75,'Germ&Sprout','Units','Normalized','fontsize',12);
%                 text(0.35,0.15,[scentext{i},' yr',num2str(year_array(j)),'\_9'],'Units','Normalized','fontsize',10);
%                 
%                 
%                 axes('position',[ 0.26 0.0  1.0 1.0]);
%                 patFig1 = patch('faces',faces,'vertices',vert,'FaceVertexCData',min_cdata);shading flat
%                 set(gca,'box','on');
%                 set(findobj(gca,'type','surface'),...
%                     'FaceLighting','phong',...
%                     'AmbientStrength',.3,'DiffuseStrength',.8,...
%                     'SpecularStrength',.9,'SpecularExponent',25,...
%                     'BackFaceLighting','unlit');
%                 
%                 caxis([ chsl chsi]);
%                 axis equal
%                 axis off;%set(gca,'xticklabel',[],'yticklabel',[]);
%                 camroll(-25)
%                 
%                 text(0.42,0.95,'HSI (asexual)','Units','Normalized','fontsize',12);
%                 
%                 
%                 set(gcf, 'PaperPositionMode', 'manual');
%                 set(gcf, 'PaperUnits', 'centimeters');
%                 xSize = 18;
%                 ySize = 20;
%                 xLeft = (21-xSize)/2;
%                 yTop = (30-ySize)/2;
%                 set(gcf,'paperposition',[0 0 xSize ySize])
%                 
%                 saveas(gcf,[outdir,'HSI_asexual_sep.png']);
%                 
%                 save([outdir,'HSI_asexual_sep.mat'],'min_cdata','-mat');
%                 export_area([outdir,'HSI_asexual_sep.csv'],min_cdata,Area);
%                 convert_2dm_to_shp('CoorongBGC_mesh_26250cells.2dm',[outdirshp, 'HSI_asexual',modname, num2str(year_array),'_9.shp'],'HSI',min_cdata);
  
                

                
            end
            
        end
    end
    close all;
end
