
clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));


filename = '../../../../data/incoming/TandI_2/UA_Ruppia/Ruppia_2-3-3_Database/01FEB2021 Aquatic Plant seasonal sampling.csv';

fid = fopen(filename,'rt');

fline = fgetl(fid);
fline = fgetl(fid);
linesplit = split(fline,',');

int = 1;
while ~feof(fid)
    
    if ~isempty(linesplit{1})
    
        S(int).lat = str2double(linesplit{2});
        S(int).lon = str2double(linesplit{3});
        
        [S(int).X,S(int).Y] = ll2utm(S(int).lat,S(int).lon);
        
        S(int).Bag = regexprep(linesplit{1},'–','-');
        S(int).Code = regexprep(linesplit{4},'–','-');
        S(int).AED_Code = ['db233_',num2str(int)];
        S(int).Geometry = 'Point';
        
%         if int == 2
%             stop
%         end
        
        int = int + 1;
    end
    
    fline = fgetl(fid);
    linesplit = split(fline,',');
    
end
shapewrite(S,'../../../../gis/summary/Ruppia_2-3-3_Database_v2.shp');


% 
% [snum,sstr] = xlsread(filename,'A2:D1359');
% 
% int = 1;
% 
% for i = 1:length(snum)
%     
%     if ~isnan(snum(i,1))
%         
%         S(int).lat = snum(i,1);
%         S(int).lon = snum(i,2);
%         
%         [S(int).X,S(int).Y] = ll2utm(S(int).lat,S(int).lon);
%         
%         S(int).Bag = sstr{i,1};
%         S(int).Code = regexprep(sstr{i,4},' ','');
%         S(int).AED_Code = ['db233_',num2str(int)];
%         S(int).Geometry = 'Point';
%         int = int + 1;
%     end
% end
% 

    
