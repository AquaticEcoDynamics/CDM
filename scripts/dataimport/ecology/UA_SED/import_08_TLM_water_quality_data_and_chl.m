clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TLM/';

filename = 'TLM water quality data and chl.xlsx';

[snum,sstr] = xlsread('08_sed_conversion.xlsx','site','A2:D100');

tSites = sstr(:,1);
tSites_Num = snum(:,1);
lat = snum(:,2);
lon = snum(:,3);

[XX,YY] = ll2utm(lat,lon);

[snum,sstr] = xlsread('08_sed_conversion.xlsx','conv','A2:C100');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);

[~,Vars] = xlsread([filepath,filename],'env cond 2004-2020','A2:A9');

[snum,sstr] = xlsread([filepath,filename],'env cond 2004-2020','B2:FS14');

thedata = snum(1:8,:);
site_ID = snum(12,:);
theyear = snum(13,:);

Agency = '08 TLM';

mMonth = [11,12];
mDay = [15,4];

TLM = [];

for i = 1:length(Vars)
    
    sss = find(strcmpi(oldname,Vars{i}) == 1);
    
    if isempty(sss)
        stop;
    end
    
    thevar = newname{sss};
    theconv = conv(sss(1));
    
    if strcmpi(thevar,'Ignore') == 0
        
        for j = 1:size(site_ID,2)
            
            
            sss = find(tSites_Num == site_ID(j));
            if theyear(j) == 2020
                mdate = datenum(theyear(j),mMonth(2),mDay(2));
            else
                mdate = datenum(theyear(j),mMonth(1),mDay(1));
            end
            mdepth = 0;
            mdata = thedata(i,j) * theconv;
            
            msite = regexprep(tSites{sss},' ','_');
            mX = XX(sss);
            mY = YY(sss);
            if ~isfield(TLM,msite)
                
                TLM.(msite).(thevar).Date(:,1) = mdate;
                TLM.(msite).(thevar).Data(:,1) = mdata;
                TLM.(msite).(thevar).Depth(:,1) = mdepth;
                TLM.(msite).(thevar).Agency = Agency;
                TLM.(msite).(thevar).X = mX;
                TLM.(msite).(thevar).Y = mY;
                
            else
                if ~isfield(TLM.(msite),thevar)
                    TLM.(msite).(thevar).Date(:,1) = mdate;
                    TLM.(msite).(thevar).Data(:,1) = mdata;
                    TLM.(msite).(thevar).Depth(:,1) = mdepth;
                    TLM.(msite).(thevar).Agency = Agency;
                    TLM.(msite).(thevar).X = mX;
                    TLM.(msite).(thevar).Y = mY;
                    
                else
                    TLM.(msite).(thevar).Date = [TLM.(msite).(thevar).Date;mdate];
                    TLM.(msite).(thevar).Data = [TLM.(msite).(thevar).Data;mdata];
                    TLM.(msite).(thevar).Depth = [TLM.(msite).(thevar).Depth;mdepth];
                end
            end
        end
    end
end


save('../../../../data/store/ecology/TLM.mat','TLM','-mat');













