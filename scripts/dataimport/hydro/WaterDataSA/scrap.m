clear all; close all;

load sitelist.mat;


thesites = fieldnames(sitelist);


%thesites = {'A4261123'};%,'A4261134','A4261135','A4260633','A4261209','A4261165'};


thedatasets; clear i



shp = shaperead('bounding.shp');


options = weboptions('Timeout',Inf);


for bb = 1:length(thesites)
    
    thesite = thesites{bb};
    
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
        the_size=s.bytes;
        
        if the_size < 100
            delete('temp.csv');
        else
            copyfile('temp.csv',filename, 'f');
            delete('temp.csv');
        end

    end
    toc
end

