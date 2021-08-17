clear al; close all;

addpath(genpath('Functions'));

disp('Downloading site information');
sdata =  download_Site_Info;

disp('DONE');


clipdate = datenum(2016,01,01,00,00,00);



[snum,sstr]  =xlsread('Vars.xlsx','A2:D100');

oldnames = sstr(:,1);
newnames = sstr(:,2);
conv = snum(:,2);
isSonde = snum(:,1);

maindir = 'Output/';

dirlist = dir(maindir);


dew = [];

for i = 3:length(dirlist)
    
    thesite = dirlist(i).name;
    
    
    
    thefiles = dir([maindir,thesite,'/*.csv']);
    
    X = sdata.(thesite).X;
    Y = sdata.(thesite).Y;
    sName = sdata.(thesite).disc;
    
    
    disp(thesite);
    
    for j = 1:length(thefiles)
        
        thevar = regexprep(thefiles(j).name,'.csv','');
        
        tt = find(strcmpi(oldnames,thevar) == 1);
        
        
        fid = fopen([maindir,thesite,'/',thefiles(j).name],'rt');
        
        
        x  = 2;
        textformat = [repmat('%s ',1,x)];
        % read single line: number of x-values
        datacell = textscan(fid,textformat,'Headerlines',5,'Delimiter',',');
        fclose(fid);
        
        thedate = datenum(datacell{1},'yyyy-mm-dd HH:MM:SS');
        thedata = str2doubleq(datacell{2});
        thedata = thedata * conv(tt);
        
        sss = find(thedate >= clipdate);
        
        
        if isSonde(tt)
            
            dew.([thesite,'s']).(newnames{tt}).Date = thedate(sss);
            dew.([thesite,'s']).(newnames{tt}).Data = thedata(sss);
            dew.([thesite,'s']).(newnames{tt}).Depth(1:length(thedata(sss)),1) = 0;
            dew.([thesite,'s']).(newnames{tt}).X = X;
            dew.([thesite,'s']).(newnames{tt}).Y = Y;
            dew.([thesite,'s']).(newnames{tt}).Name = sName;
            dew.([thesite,'s']).(newnames{tt}).Agency = 'DEW Sonde';
            
        else
            dew.([thesite]).(newnames{tt}).Date = thedate(sss);
            dew.([thesite]).(newnames{tt}).Data = thedata(sss);
            dew.([thesite]).(newnames{tt}).Depth(1:length(thedata(sss)),1) = 0;
            dew.([thesite]).(newnames{tt}).X = X;
            dew.([thesite]).(newnames{tt}).Y = Y;
            dew.([thesite]).(newnames{tt}).Name = sName;
            dew.([thesite]).(newnames{tt}).Agency = 'DEW';
            
        end
    end
    
    
end

disp('Calculating SAL')

sites = fieldnames(dew);

for i = 1:length(sites)
    
    vars = fieldnames(dew.(sites{i}));
    
    tt = sum(ismember(vars,'TEMP'));
    yy = sum(ismember(vars,'COND'));
    
    if tt == 1 & yy == 1
        
        COND = dew.(sites{i}).COND.Data;
        COND_DATE = dew.(sites{i}).COND.Date;
        TEMP = dew.(sites{i}).TEMP.Data;
        TEMP_DATE = dew.(sites{i}).TEMP.Date;
        
        dew.(sites{i}).SAL = dew.(sites{i}).COND;
        dew.(sites{i}).SAL.Data = conductivity2salinity(COND);
        % Matching arrays
        
        [~,condmatch,tempmatch] = intersect(COND_DATE,TEMP_DATE);
        
        
        if ~isempty(condmatch)
            dew.(sites{i}).SAL.Data(condmatch) = conductivity2salinity_withtemp(COND(condmatch),TEMP(tempmatch));
        end
        
        
    else
        
        if tt == 0 & yy == 1
            dew.(sites{i}).SAL = dew.(sites{i}).COND;
            dew.(sites{i}).SAL.Data = conductivity2salinity(COND);
        end
    end
        
end










save ../../../../data/store/hydro/dew_WaterDataSA.mat dew -mat -v7.3;

