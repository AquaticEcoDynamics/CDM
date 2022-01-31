clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

% Site 	Latitude	Longitude

% Policeman Point Boat Ramp 1	36° 2'59.94"S	139°34'42.97"E
lon1=139+34/60+42.97/60/60;
lat1=36+2/60+59.94/60/60;

[PP1utmx,PP1utmy]=ll2utm(-lat1,lon1);

% Policeman Point Boat Ramp 2	 36° 3'2.98"S	139°34'39.28"E

lon1=139+34/60+39.28/60/60;
lat1=36+3/60+2.98/60/60;

[PP2utmx,PP2utmy]=ll2utm(-lat1,lon1);

% Villa dei Yumpa	 35°56'0.32"S	139°29'1.35"E

lon1=139+29/60+1.35/60/60;
lat1=35+56/60+0.32/60/60;

[VdYutmx,VdYutmy]=ll2utm(-lat1,lon1);


[snum,sstr] = xlsread('../../../../data/incoming/UA/Sonde/Water Quality data_DEC20-MAR21.xlsx','2 hour data_All Combined_R','A2:A100000');

for i = 1:length(sstr)
    line = split(sstr{i},' ');
    
    mdate(i,1) = datenum(sstr{i},['dd/mm/yyyy HH:MM:SS ',line{3}]);% ',line{3}]);
    
end

[snum,sstr] = xlsread('../../../../data/incoming/UA/Sonde/Water Quality data_DEC20-MAR21.xlsx','Vars','A2:D100000');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);
units = sstr(:,4);

[~,headers] = xlsread('../../../../data/incoming/UA/Sonde/Water Quality data_DEC20-MAR21.xlsx','2 hour data_All Combined_R','B1:N1');

[~,Sites] = xlsread('../../../../data/incoming/UA/Sonde/Water Quality data_DEC20-MAR21.xlsx','2 hour data_All Combined_R','O2:O10000');

[data,~,~] = xlsread('../../../../data/incoming/UA/Sonde/Water Quality data_DEC20-MAR21.xlsx','2 hour data_All Combined_R','B2:N63');


usites = unique(Sites);



for i = 1:length(usites)
    
    sss = find(strcmpi(Sites,usites{i}) == 1);
    
    for j = 1:length(headers)
        
        thedata = data(sss,j);
        thedate = mdate(sss);
        
        ttt = find(~isnan(thedata) == 1);
        
        ggg = find(strcmpi(oldname,headers{j}) == 1);
        
        if ~isempty(ttt)
            
            thesite = regexprep(usites{i},' ','_');
            
            if strcmpi(newname{ggg},'Ignore') == 0
            
            ua_sonde.(thesite).(newname{ggg}).Date = thedate;
            ua_sonde.(thesite).(newname{ggg}).Data = thedata * conv(ggg);
            ua_sonde.(thesite).(newname{ggg}).Depth(1:length(sss),1) = 0;
            ua_sonde.(thesite).(newname{ggg}).Agency = 'UA_Sonde';
            ua_sonde.(thesite).(newname{ggg}).Units = units{ggg};
            switch usites{i}
                
                case 'Policeman Point Boat Ramp 1'
                    ua_sonde.(thesite).(newname{ggg}).X = PP1utmx;
                    ua_sonde.(thesite).(newname{ggg}).Y = PP1utmy;
                    
                case 'Policeman Point Boat Ramp 2'
                    ua_sonde.(thesite).(newname{ggg}).X = PP2utmx;
                    ua_sonde.(thesite).(newname{ggg}).Y = PP2utmy;            
            
                 case 'Villa dei Yumpa'
                    ua_sonde.(thesite).(newname{ggg}).X = VdYutmx;
                    ua_sonde.(thesite).(newname{ggg}).Y = VdYutmy;  
                    
                otherwise
                    
                    stop
            end
            end
        end
    end
end

save('../../../../data/store/ecology/ua_sonde.mat','ua_sonde','-mat');
            
        
        
        
        
        
        
        
        
        
    
    









