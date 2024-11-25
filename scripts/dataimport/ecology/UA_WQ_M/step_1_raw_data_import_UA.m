clear all; close all;

filename = '../../../../data/incoming/TandI_1/Data to modellers 5 June 2020\Water quality data collation\Coorong Data 1995_2020_Final.xlsx';

sheetname = 'Collated_Data';

[~,sdate] = xlsread(filename,sheetname,'B2:B1228');
[~,ssites] = xlsread(filename,sheetname,'A2:A1228');
[X,~] = xlsread(filename,sheetname,'DT2:DT1228');
[Y,~] = xlsread(filename,sheetname,'DU2:DU1228');
[~,headers] = xlsread(filename,sheetname,'C1:DS1');
[~,~,TN] = xlsread(filename,sheetname,'DW2:DW1228');
headers(end+1) = {'TN'};
[~,~,dataraw] = xlsread(filename,sheetname,'C2:DS1228');
dataraw(:,end+1) = TN;


headers = regexprep(headers,'-','_');
headers = regexprep(headers,'%','perc');
headers = regexprep(headers,' ','_');

ssites = regexprep(ssites,' ','_');
ssites = regexprep(ssites,'1.8km_west_of_Salt_Creek','Salt_Creek_1p8km_west');
ssites = regexprep(ssites,'3.2km_south_of_Salt_Ck','Salt_Creek_3p2km_west');

mdate(1:length(sdate),1) = NaN;
%clean up the dates

for i = 1:length(sdate)
    ff = split(sdate{i});

    switch length(ff)
        case 1
            mdate(i,1) = datenum(sdate{i},'dd/mm/yyyy');
        case 2
            mdate(i,1) = datenum(sdate{i},'dd/mm/yyyy HH:MM:SS');
    
        case 3
        mdate(i,1) = datenum(sdate{i},['dd/mm/yyyy HH:MM:SS ',ff{3}]);
        
        otherwise
            stop
    end
end

UAraw = [];

for i = 1:length(ssites)
    
    

    for j = 1:length(headers)
        
        thedata = dataraw{i,j};
        
        if ~isnan(thedata)
        
            if ~isfield(UAraw,ssites{i})
            
                %There is no previous data
                
                UAraw.(ssites{i}).(headers{j}).Date(1,1) = mdate(i);
                UAraw.(ssites{i}).(headers{j}).Data(1,1) = thedata;
                UAraw.(ssites{i}).(headers{j}).Depth(1,1) = 0;
                UAraw.(ssites{i}).(headers{j}).X = X(i);
                UAraw.(ssites{i}).(headers{j}).Y = Y(i);
                
            else
                if ~isfield(UAraw.(ssites{i}),headers{j})
                    % There is no variable
                    UAraw.(ssites{i}).(headers{j}).Date(1,1) = mdate(i);
                    UAraw.(ssites{i}).(headers{j}).Data(1,1) = thedata;
                    UAraw.(ssites{i}).(headers{j}).Depth(1,1) = 0;
                    UAraw.(ssites{i}).(headers{j}).X = X(i);
                    UAraw.(ssites{i}).(headers{j}).Y = Y(i);
                    
                else
                    UAraw.(ssites{i}).(headers{j}).Date = [UAraw.(ssites{i}).(headers{j}).Date;mdate(i)];
                    UAraw.(ssites{i}).(headers{j}).Data = [UAraw.(ssites{i}).(headers{j}).Data;thedata];
                    UAraw.(ssites{i}).(headers{j}).Depth = [UAraw.(ssites{i}).(headers{j}).Depth;0];
%                     UAraw.(ssites{i}).(headers{j}).X = X(i);
%                     UAraw.(ssites{i}).(headers{j}).Y = Y(i);
                end
            end
        end
    end
end

save UAraw.mat UAraw -mat;
                
                
                
                
        
        


    
    