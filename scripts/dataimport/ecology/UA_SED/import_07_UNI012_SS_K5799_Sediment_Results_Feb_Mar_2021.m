clear all; close all;
addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

filepath = '../../../../data/incoming/TandI_1/Sediment/';

filename = 'UNI012-SS-K5799 Sediment Results Feb-Mar 2021 Leslie_Luke.xlsx';

[snum,sstr] = xlsread('05_Sites.csv','A2:D100');

Sites = sstr(:,1); Sites = regexprep(Sites,'\s','_');
tSites = sstr(:,2);
lat = snum(:,1);
lon = snum(:,2);

[XX,YY] = ll2utm(lat,lon);


[snum,sstr] = xlsread('07_sed_conversion.xlsx','A2:C6');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);


mdate = datenum(2021,02,01);

agency = 'UA Sediment';


[~,fsites] = xlsread([filepath,filename],'Data','A9:A28');

[data,~] = xlsread([filepath,filename],'Data','C9:G28');

for i = 1:length(fsites)
    
    sp = split(fsites{i},' ');
    
    sss = find(strcmpi(tSites,sp{1}) == 1);
    
    fullname = [Sites{sss},'_',sp{2}];
    
    mX = XX(sss);
    mY = YY(sss);
    
    for j = 1:size(data,2)
        
        if ~isnan(data(i,j))
            
            union.(fullname).(newname{j}).Date = mdate;
            union.(fullname).(newname{j}).Data = data(i,j) * conv(j);
            union.(fullname).(newname{j}).Depth = 0;
            union.(fullname).(newname{j}).Agency = agency;
            union.(fullname).(newname{j}).X = mX;
            union.(fullname).(newname{j}).Y = mY;
            
        end
    end
end

%____________________________________________________________

[snum,sstr] = xlsread('07_sed_conversion.xlsx','A7:D27');

oldname = sstr(:,1);
newname = sstr(:,2);
conv = snum(:,1);
add_depth = snum(:,2);

[~,nameconv] = xlsread('07_name_conversion.xlsx','A1:D17');


[~,fsites] = xlsread([filepath,filename],'Data2','A9:A25');

[data,~] = xlsread([filepath,filename],'Data2','C9:W25');

for i = 1:length(fsites)
    
    for j = 1:size(data,2)
        if strcmpi(newname{j},'Ignore') == 0
            if ~isnan(data(i,j))
                
                switch add_depth(j)
                    case 0
                        thevar = newname{j};
                    case 1
                        thevar = [newname{j},regexprep(nameconv{i,4},'a','')];
                end
                
                if ~isempty(nameconv{i,3})
                    
                    thesite = [nameconv{i,2},'_',nameconv{i,3}];
                    
                else
                    thesite = nameconv{i,2};
                end
                
                
                sss = find(strcmpi(Sites,nameconv{i,2}) == 1);
                
                mX = XX(sss);
                mY = YY(sss);
                
                if ~isfield(union,thesite)
                    union.(thesite).(thevar).Date = mdate;
                    union.(thesite).(thevar).Data = data(i,j) * conv(j);
                    union.(thesite).(thevar).Depth = 0;
                    union.(thesite).(thevar).Agency = agency;
                    union.(thesite).(thevar).X = mX;
                    union.(thesite).(thevar).Y = mY;
                else
                    if ~isfield(union.(thesite),thevar)
                        union.(thesite).(thevar).Date = mdate;
                        union.(thesite).(thevar).Data = data(i,j) * conv(j);
                        union.(thesite).(thevar).Depth = 0;
                        union.(thesite).(thevar).Agency = agency;
                        union.(thesite).(thevar).X = mX;
                        union.(thesite).(thevar).Y = mY;
                        
                    else
                        union.(thesite).(thevar).Date = [union.(thesite).(thevar).Date;mdate];
                        union.(thesite).(thevar).Data = [union.(thesite).(thevar).Data;data(i,j) * conv(j)];
                        union.(thesite).(thevar).Depth =[union.(thesite).(thevar).Depth;0];
                    end
                end
                
            end
            
        end
    end
end


save('../../../../data/store/ecology/union.mat','union','-mat');























