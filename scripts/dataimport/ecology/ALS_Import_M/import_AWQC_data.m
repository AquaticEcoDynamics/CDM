clear all; close all;

filename = 'AWQC_Data.csv';
fid = fopen(filename,'rt');

x  = 7;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

sites = datacell{3};
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
AWQC = [];

for i = 1:length(data)
    
    if ~isnan(data(i))
        
        sss = find(strcmpi(oldsite,sites{i}) == 1);
        ttt = find(strcmpi(oldvar,vars{i}) == 1);
        if isempty(sss)
            stop;
        end
        if isempty(ttt)
            stop;
        end
        
        
        if strcmpi(newvar{ttt(1)},'Ignore') == 0
            
            
            filesite = [newsite{sss(1)}];
            
            
            if isfield(AWQC,filesite)
                
                if isfield(AWQC.(filesite),newvar{ttt(1)})
                    
                    AWQC.(filesite).(newvar{ttt(1)}).Date = [AWQC.(filesite).(newvar{ttt(1)}).Date;mdates(i)];
                    AWQC.(filesite).(newvar{ttt(1)}).Data = [AWQC.(filesite).(newvar{ttt(1)}).Data;data(i) * conv(ttt(1))];
                    AWQC.(filesite).(newvar{ttt(1)}).Depth = [AWQC.(filesite).(newvar{ttt(1)}).Depth;0];
                    
                else
                    AWQC.(filesite).(newvar{ttt(1)}).Date = mdates(i);
                    AWQC.(filesite).(newvar{ttt(1)}).Data = data(i) * conv(ttt(1));
                    AWQC.(filesite).(newvar{ttt(1)}).Depth = 0;
                    AWQC.(filesite).(newvar{ttt(1)}).X = X(sss(1));
                    AWQC.(filesite).(newvar{ttt(1)}).Y = Y(sss(1));
                    AWQC.(filesite).(newvar{ttt(1)}).Units = newunits{ttt(1)};
                    AWQC.(filesite).(newvar{ttt(1)}).Name = oldsite{sss(1)};
                    AWQC.(filesite).(newvar{ttt(1)}).OldVar = oldvar{ttt(1)};
                    AWQC.(filesite).(newvar{ttt(1)}).OldUnits = units{i};
                    AWQC.(filesite).(newvar{ttt(1)}).Agency = 'AWQC (DEW)';
                    
                end
                
            else
                AWQC.(filesite).(newvar{ttt(1)}).Date = mdates(i);
                AWQC.(filesite).(newvar{ttt(1)}).Data = data(i) * conv(ttt(1));
                AWQC.(filesite).(newvar{ttt(1)}).Depth = 0;
                AWQC.(filesite).(newvar{ttt(1)}).X = X(sss(1));
                AWQC.(filesite).(newvar{ttt(1)}).Y = Y(sss(1));
                AWQC.(filesite).(newvar{ttt(1)}).Units = newunits{ttt(1)};
                AWQC.(filesite).(newvar{ttt(1)}).Name = oldsite{sss(1)};
                AWQC.(filesite).(newvar{ttt(1)}).OldVar = oldvar{ttt(1)};
                AWQC.(filesite).(newvar{ttt(1)}).OldUnits = units{i};
                AWQC.(filesite).(newvar{ttt(1)}).Agency = 'AWQC (DEW)';
                
            end
        end
        
    end
end

AWQC = reorder_data(AWQC);

save('../../../../data/store/ecology/AWQC_1.mat','AWQC','-mat');











