clear all; close all;

[~,headers] = xlsread('Sediment Zones.xlsx','A4:A100');

[vals,~] = xlsread('Sediment Zones.xlsx','B4:AF100');

fid = fopen('aed_sedflux.txt','wt');

fprintf(fid,'n_zones = %d    ! check match to TFV material zones\n',size(vals,2));

fprintf(fid,'\n');

for i = 1:length(headers)
    fprintf(fid,'%s = ',headers{i});
    
    for j = 1:size(vals,2)
        if j == size(vals,2)
            
            if vals(i,j) < -100000
                fprintf(fid,'%2.1e\n',vals(i,j));
            else
                fprintf(fid,'%4.4f\n',vals(i,j));
            end
        else
            if vals(i,j) < -100000
                fprintf(fid,'%2.1e,',vals(i,j));
            else
                fprintf(fid,'%4.4f,',vals(i,j));
            end
        end
    end
end
fclose(fid);