clear all; close all;
addpath(genpath('Functions'));

% runsites = 1;
% 
% fidout = fopen('theaddress.txt','wt');
% 
% if runsites
% 
%     %sdata =  download_Site_Info;
%     load siteinfo.mat;
% 
%     shp = shaperead('Bounding_Small.shp');
% 
%     clipsites = 0;
% 
%     thesites = [];
% 
%     allsites = fieldnames(sdata);
% 
% 
% 
%     for i = 1:length(allsites)
%         if clipsites
%             if inpolygon(sdata.(allsites{i}).X,sdata.(allsites{i}).Y,shp.X,shp.Y)
%                 thesites = [thesites;allsites(i)];
%             end
%         else
%             thesites = [thesites;allsites(i)];
%         end
%     end
% 
% else
% 
%     thesites = [];
% 
%     thesites = {'A4261204'};
% end
% %thesites = fieldnames(sitelist);
% 
% 
% %thesites = {'A4261123'};%,'A4261134','A4261135','A4260633','A4261209','A4261165'};
% 
% theinterval = 'Hourly';%'Points'
% 
% switch theinterval
%     case 'Hourly'
%         thedatasets_hourly; clear i
%     case 'Points'
%         thedatasets; clear i
%     otherwise
%         stop;
% end
% 
% 
% shp = shaperead('bounding.shp');
% 
% 
% options = weboptions('Timeout',Inf);
% 
% 
% for bb = 1:length(thesites)
%     thesite = thesites{bb};
%     %if strcmpi(thesite,'A4261156') == 1
% 
%     outdir = ['Output/',thesite,'/'];
% 
%     if ~exist(outdir,'dir')
%         mkdir(outdir);
%     end
% 
% 
%     disp(thesite);
% 
% 
%     for i = 1:length(dataset)
% 
%         filename = [outdir,dataset(i).Name{1},'.csv'];
% 
% 
% 
%         theaddress = [header,dataset(i).Name{2},thesite,dataset(i).Name{3}];
%         theaddress
%         try
%             outfilename = websave('temp.csv',theaddress,options);
%         catch
%             % Continue on error
%         end
% 
% 
% 
%         s=dir('temp.csv');
%         try
%             the_size=s.bytes;
% 
%             if the_size < 1000
%                 delete('temp.csv');
% 
%                 theaddress = regexprep(theaddress,'Aggregate&Datasets','Instantaneous&Datasets');
%                 try
%                     outfilename = websave('temp.csv',theaddress,options);
%                 catch
%                     % Continue on error
%                 end
%                 s=dir('temp.csv');
%                 try
%                     the_size=s.bytes;
% 
%                     if the_size < 1000
%                         delete('temp.csv');
%                     else
%                         %stop
%                         fprintf(fidout,'%s,%s\n',thesite,theaddress);
%                         copyfile('temp.csv',filename, 'f');
%                         delete('temp.csv');
%                     end
% 
%                 catch
%                 end
% 
% 
%             else
% 
%                 fprintf(fidout,'%s,%s\n',thesite,theaddress);
% 
%                 copyfile('temp.csv',filename, 'f');
%                 delete('temp.csv');
%             end
%         catch
% 
%         end
% 
%     end
% 
% end


theinterval = 'Hourly';%'Points'

switch theinterval
    case 'Hourly'
        import_datafiles_hourly;
    case 'Points'
        import_datafiles;
    otherwise
        stop;
end
