
% check waves
clear; close all;
metfile='C:\Users\00065525\Github\CDM\models\HCHB\hchb_swan_v1\TFV\Nurrung_and_wavedata_merged_202011_202104.csv';
metfile2='C:\Users\00065525\Github\CDM\models\HCHB\hchb_swan_v1\TFV\Narrung_met_20160201_20210401.csv';

wavefile='X:\CDM\Coorong_swn_20201101_20210401_UA_Wind_200g_2000w\04_results\WAVE.nc';
wavefile2='X:\CDM\Coorong_swn_20201101_20210401\04_results\WAVE.nc';

lon1=139+34/60+39.59/60/60;
lat1=36+3/60+2.95/60/60;
[utmx,utmy]=ll2utm(-lat1,lon1);
%[utmx,utmy]=ll2utm(lon1,-lat1);
%_________________________


t1=datenum(2020,12,1);
t2=datenum(2020,12,5);


metdata=tfv_readBCfile(metfile);
metdata2=tfv_readBCfile(metfile2);


[time2,wst,hs,t3,x1,y1,depth]   = process_wavedata(wavefile,t1,t2,utmx,utmy);
[time22,wst2,hs2,t32,x12,y12,depth2]   = process_wavedata(wavefile2,t1,t2,utmx,utmy);

%_________________________


%load hs.mat;
load wave.mat;

aa=strfind(data.Site,'Villa dei Yumpa');
%%
hfig = figure('visible','on','position',[304 166 1500 900]);

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'paperposition',[0.635 6.35 18 18])


subplot(3,1,1);

ws=sqrt(metdata.Wx.^2+metdata.Wy.^2);
ws2=sqrt(metdata2.Wx.^2+metdata2.Wy.^2);

plot(metdata.Date,ws,'b');
hold on;
plot(metdata2.Date,ws2,'k');

plot(time2,squeeze(wst(1,1,1:length(time2))),'r');

datearray=datenum(2020,12,1:5);

set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'dd/mmm'));
hl=legend('Nurrung and wavedata merged 202011 202104','Narrung met 20160201 20210401','model output');set(hl,'Location','Northeast');
ylabel('wind speed (m/s)');

title('(a) wind speed at Policeman Point');

subplot(3,1,2);

wh=squeeze(hs(x1,y1,:));
wh2=squeeze(hs2(x12,y12,:));

%t3=time2(ind1:ind2-1);
plot(t3,wh,'b');
hold on;
plot(t32,wh2,'k');
hold on;

plot(data.Date(1:745),data.Significantwaveheight(1:745),'r');
hold on;

set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'dd/mmm'));
hl=legend('Coorong swn 20201101 20210401 UA Wind 200g 2000w','Coorong swn 20201101 20210401','observations');set(hl,'Location','Northeast');
ylabel('wave height (m)');
title('(b) significant wave height at Policeman Point');

subplot(3,1,3);

plot(time2,squeeze(depth(1,1,1:length(time2))),'b');
hold on;
plot(time22,squeeze(depth2(1,1,1:length(time22))),'k');
hold on;

set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'dd/mmm'));
hl=legend('Coorong Level 0.25','Coorong Level 0.5');set(hl,'Location','Northeast');
ylabel('Depth (m)');
title('(c) depth at Policeman Point');



img_name ='compare_wave_Policeman_v2_2000w_0.25level.png';

saveas(gcf,img_name);

