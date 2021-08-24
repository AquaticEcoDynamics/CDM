clear all; close all;

load ../../../data/store/metocean/wave_wind.mat;

load ../../../data/store/metocean/NRM_metdata.mat;


metdata.RMPW18.Wx.Date = metdata.RMPW18.WindSpeed.Date;
metdata.RMPW18.Wy.Date = metdata.RMPW18.WindSpeed.Date;



metdata.RMPW18.Wx.Data = (round(-1.0.*(metdata.RMPW18.WindSpeed.Data).*sin((pi/180).*metdata.RMPW18.WindDir.Data)*1000000)/1000000)/3.6;
metdata.RMPW18.Wy.Data = (round(-1.0.*(metdata.RMPW18.WindSpeed.Data).*cos((pi/180).*metdata.RMPW18.WindDir.Data)*1000000)/1000000)/3.6;


datearray(:,1) = datenum(2020,11,01,00,00,00): 15/(24*60):datenum(2021,04,02,00,00,00);

Wx = interp1(metdata.RMPW18.Wx.Date,metdata.RMPW18.Wx.Data,datearray);
Wy = interp1(metdata.RMPW18.Wy.Date,metdata.RMPW18.Wy.Data,datearray);

Merged(1:length(datearray),1) = 0;

sites = fieldnames(wavewind);

int = 0;

for kk = 1:length(datearray)
    
    for i = 1:length(sites)
        
        Xdate = wavewind.(sites{i}).Wx.Date;
        Xdata = wavewind.(sites{i}).Wx.Data;
        Ydate = wavewind.(sites{i}).Wy.Date;
        Ydata = wavewind.(sites{i}).Wy.Data;
        
        [val,ind] = min(abs(Xdate - datearray(kk)));
        
        if abs(Xdate(ind) - datearray(kk)) < (10/(60*24))
            int = int + 1;
            disp('Found data');
            Wx(kk) = Xdata(ind);
            Wy(kk) = Ydata(ind);
            Merged(kk) = 1;
            
        end
    end
end

fid = fopen('Nurrung_and_wavedata_merged_202011_202104.csv','wt');

fprintf(fid,'ISOTime,Wx,Wy,Chx\n');

for i = 1:length(datearray)
    fprintf(fid,'%s,%4.4f,%4.4f,%i\n',datestr(datearray(i),'dd/mm/yyyy HH:MM:SS'),Wx(i),Wy(i),Merged(i));
end
fclose(fid);




