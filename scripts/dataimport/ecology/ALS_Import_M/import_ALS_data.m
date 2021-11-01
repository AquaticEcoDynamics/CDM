clear all; close all;

filename = 'ALS_Data.csv';
fid = fopen(filename,'rt');

x  = 7;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

sites = datacell{3};

sites = regexprep(sites,'Villa du Yumpa','Villa de Yumpa');
sites = regexprep(sites,'Morella Creek @ Guage','Morella Creek @ gauge');
sites = regexprep(sites,'Tilley Swamp D/S Nth Outlet','Tilley Swamp Drain D/S Northern Outlet');
sites = regexprep(sites,'Tilley Swamp Watercourse Outlet','Tilley Swamp Watercourse Outlet Channel');
sites = regexprep(sites,'Tilley Swamp Outlet Drain','Tilley Swamp Drain U/S Morella' );
sites = regexprep(sites,'Tilley Swamp Drain D/S Nth Outlet','Tilley Swamp Drain D/S Northern Outlet');
sites = regexprep(sites,'Tilley Swamp Drain W/C Outlet','Tilley Swamp Watercourse Outlet Channel');
sites = regexprep(sites,'Tilley Swamp Drain Watercourse Outlet','Tilley Swamp Watercourse Outlet Channel');


vars = datacell{4};
units = datacell{5};
dates = datacell{6};
mdates = datenum(dates,'dd/mm/yyyy HH:MM:SS');
data = str2double(datacell{7});

[snum,sstr] = xlsread('Site_Conv.csv','A2:D10000');

oldsite = sstr(:,1);
newsite = sstr(:,2);
X = snum(:,1);
Y = snum(:,2);

[snum,sstr] = xlsread('Var_Conv.csv','A2:E10000');

oldvar = sstr(:,1);
newvar = sstr(:,3);
newunits = sstr(:,4);
conv = snum(:,1);


%_______________________________________________________________________
ALS = [];

for i = 1:length(data)
    
    if ~isnan(data(i))
        
        
        sss = find(strcmpi(oldsite,sites{i}) == 1);
        ttt = find(strcmpi(oldvar,vars{i}) == 1);
        sites{i}
        if isempty(sss)
            stop;
        end
        if isempty(ttt)
            stop;
        end
        
        if strcmpi(newvar{ttt(1)},'Ignore') == 0
            filesite = [newsite{sss(1)}];
            
            
            if isfield(ALS,filesite)
                
                if isfield(ALS.(filesite),newvar{ttt(1)})
                    
                    ALS.(filesite).(newvar{ttt(1)}).Date = [ALS.(filesite).(newvar{ttt(1)}).Date;mdates(i)];
                    ALS.(filesite).(newvar{ttt(1)}).Data = [ALS.(filesite).(newvar{ttt(1)}).Data;data(i) * conv(ttt(1))];
                    ALS.(filesite).(newvar{ttt(1)}).Depth = [ALS.(filesite).(newvar{ttt(1)}).Depth;0];
                    
                else
                    ALS.(filesite).(newvar{ttt(1)}).Date = mdates(i);
                    ALS.(filesite).(newvar{ttt(1)}).Data = data(i) * conv(ttt(1));
                    ALS.(filesite).(newvar{ttt(1)}).Depth = 0;
                    ALS.(filesite).(newvar{ttt(1)}).X = X(sss(1));
                    ALS.(filesite).(newvar{ttt(1)}).Y = Y(sss(1));
                    ALS.(filesite).(newvar{ttt(1)}).Units = newunits{ttt(1)};
                    ALS.(filesite).(newvar{ttt(1)}).Name = oldsite{sss(1)};
                    ALS.(filesite).(newvar{ttt(1)}).OldVar = oldvar{ttt(1)};
                    ALS.(filesite).(newvar{ttt(1)}).OldUnits = units{i};
                    ALS.(filesite).(newvar{ttt(1)}).Agency = 'ALS';
                    
                end
                
            else
                ALS.(filesite).(newvar{ttt(1)}).Date = mdates(i);
                ALS.(filesite).(newvar{ttt(1)}).Data = data(i) * conv(ttt(1));
                ALS.(filesite).(newvar{ttt(1)}).Depth = 0;
                ALS.(filesite).(newvar{ttt(1)}).X = X(sss(1));
                ALS.(filesite).(newvar{ttt(1)}).Y = Y(sss(1));
                ALS.(filesite).(newvar{ttt(1)}).Units = newunits{ttt(1)};
                ALS.(filesite).(newvar{ttt(1)}).Name = oldsite{sss(1)};
                ALS.(filesite).(newvar{ttt(1)}).OldVar = oldvar{ttt(1)};
                ALS.(filesite).(newvar{ttt(1)}).OldUnits = units{i};
                ALS.(filesite).(newvar{ttt(1)}).Agency = 'ALS';
                
            end
        end
    end
end

ALS = reorder_data(ALS);

save('../../../../data/store/ecology/ALS.mat','ALS','-mat');











