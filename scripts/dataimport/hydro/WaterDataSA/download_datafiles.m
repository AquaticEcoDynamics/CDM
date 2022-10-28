clear all; close all;
addpath(genpath('Functions'));

sdata =  download_Site_Info;


shp = shaperead('bounding.shp');


thesites = [];

allsites = fieldnames(sdata);

for i = 1:length(allsites)
    
    if inpolygon(sdata.(allsites{i}).X,sdata.(allsites{i}).Y,shp.X,shp.Y)
        thesites = [thesites;allsites(i)];
    end
end

%thesites = {'A4261159'};

%thesites = fieldnames(sitelist);


%thesites = {'A4261123'};%,'A4261134','A4261135','A4260633','A4261209','A4261165'};

theinterval = 'Hourly';%'Points'

switch theinterval
    case 'Hourly'
        thedatasets_hourly; clear i
    case 'Points'
        thedatasets; clear i
    otherwise
        stop;
end


shp = shaperead('bounding.shp');


options = weboptions('Timeout',Inf);


for bb = 1:length(thesites)
    thesite = thesites{bb};
    if strcmpi(thesite,'A4261075') == 1
        
        outdir = ['Output/',thesite,'/'];
        
        if ~exist(outdir,'dir')
            mkdir(outdir);
        end
        
        
        disp(thesite);
        
        tic
        for i = 1:length(dataset)
            
            filename = [outdir,dataset(i).Name{1},'.csv'];
            
            
            
            theaddress = [header,dataset(i).Name{2},thesite,dataset(i).Name{3}];
            
            try
                outfilename = websave('temp.csv',theaddress,options);
            catch
                % Continue on error
            end
            
            
            
            s=dir('temp.csv');
            try
                the_size=s.bytes;
                
                if the_size < 1000
                    delete('temp.csv');
                else
                    copyfile('temp.csv',filename, 'f');
                    delete('temp.csv');
                end
            catch
                
            end
            
        end
        
    end
    toc
end
switch theinterval
    case 'Hourly'
        import_datafiles_hourly;
    case 'Points'
        import_datafiles;
    otherwise
        stop;
end
