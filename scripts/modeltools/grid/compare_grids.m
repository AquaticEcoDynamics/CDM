clear all; close all;

addpath(genpath('../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


file1 = 'Y:\CDM2022\CDM22_newMesh_newMZ_testing\output_basecase_005\eWater_basecase_newMesh_BB_TEST_all.nc';
file2 = 'Y:\CDM2022\CDM22_newMesh_newMZ_testing\output_basecase_005\eWater_basecase_newMesh_BB_TEST_v3_all.nc';

dat1 = tfv_readnetcdf(file1,'time',1);
dat2 = tfv_readnetcdf(file1,'time',1);

 [~,ind11] = min(abs(dat1.Time - datenum(2021,10,01)));
% [~,ind2] = min(abs(dat2.Time - datenum(2021,10,01)));

ind1 = find(dat1.Time >= datenum(2021,09,01) & dat1.Time <= datenum(2021,12,01));
ind2 = find(dat2.Time >= datenum(2021,09,01) & dat2.Time <= datenum(2021,12,01));


H1 = ncread(file1,'H');
H2 = ncread(file2,'H');

Hmean1 = mean(H1(:,ind1),2);
Hmean2 = mean(H2(:,ind2),2);

cdata1 = Hmean1 - Hmean2;
data1 = tfv_readnetcdf(file1,'timestep',ind11);
% data2 = tfv_readnetcdf(file2,'timestep',ind2);



% sss = find(cdata1 <= 0.000); 
% 
% cdata1(sss) = NaN;


vert(:,1) = data1.node_X;
vert(:,2) = data1.node_Y;

faces = data1.cell_node';

%--% Fix the triangles
faces(faces(:,4)== 0,4) = faces(faces(:,4)== 0,1);

% cdata1 = data1.H;
% cdata2 = data2.H;

% cdata3 = cdata1 - cdata2;


hfig = figure('visible','on','position',[304         166        1271         812]);

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'paperposition',[0.635 6.35 20.32 15.24])

%axes('position',[0 0 0.33 1]);
axes('position',[0 0 1 1]);


patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata1);shading flat
set(gca,'box','on');hold on


%         plot(281633.0, 6212426.0,'*k');
%         plot(281838.05, 6212888.35,'*r');

set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit');


caxis([0 0.2]);


% 
% %______________________________________________________________________
% axes('position',[0.33 0 0.33 1]);
% 
% 
% 
% patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata2);shading flat
% set(gca,'box','on');hold on
% 
% 
% %         plot(281633.0, 6212426.0,'*k');
% %         plot(281838.05, 6212888.35,'*r');
% 
% set(findobj(gca,'type','surface'),...
%     'FaceLighting','phong',...
%     'AmbientStrength',.3,'DiffuseStrength',.8,...
%     'SpecularStrength',.9,'SpecularExponent',25,...
%     'BackFaceLighting','unlit');
% 
% caxis([0.2 0.6]);
% 
% %______________________________________________________________________
% axes('position',[0.66 0 0.33 1]);
% 
% 
% cdata3(cdata3 == 0) = NaN;
% patFig = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata3);shading flat
% set(gca,'box','on');hold on
% 
% 
% %         plot(281633.0, 6212426.0,'*k');
% %         plot(281838.05, 6212888.35,'*r');
% 
% set(findobj(gca,'type','surface'),...
%     'FaceLighting','phong',...
%     'AmbientStrength',.3,'DiffuseStrength',.8,...
%     'SpecularStrength',.9,'SpecularExponent',25,...
%     'BackFaceLighting','unlit');
% 
% %caxis([0.2 0.6]);
% colorbar


