clear all; close all;

addpath(genpath('../../../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

old = tfv_readBCfile('VH_20120101_20221101_Plim.csv');
%bk = tfv_readBCfile('BK_20120101_20230601.csv');
%load('../../../../data/store/hydro/dew_tide_VH_2023.mat');


gap1 = readtable("C:\Users\00065525\Github\CDM\data\incoming\DEW\hydrology\compiled\vh_Nov2022-Jan2023\Tide_Level_Encoder_202211.csv");

gap2 = readtable("C:\Users\00065525\Github\CDM\data\incoming\DEW\hydrology\compiled\vh_Nov2022-Jan2023\Tide_Level_Encoder_202212.csv");

gap3 = readtable("C:\Users\00065525\Github\CDM\data\incoming\DEW\hydrology\compiled\vh_Nov2022-Jan2023\Tide_Level_Encoder_202301.csv");

gap1.mdate = datenum(gap1.Var1);
gap2.mdate = datenum(gap2.Var1);
gap3.mdate = datenum(gap3.Var1);


%tt = readtable('../../../../data/incoming/DEW/hydrology/compiled/vh1990-2022pred_10Nov2022/vh1990-2022pred_10Nov2022.csv');%,'A2:D500000');
tt = readtable("C:\Users\00065525\Github\CDM\data\incoming\DEW\hydrology\compiled\VH_Tide_MAHD_2023.csv");%,'A2:D500000');

tt.mdate = datenum(tt.x_BulkExport_PointsAsRecorded);


%vh = readtable('Tide_Prediction (2).csv');

%vh.mdate = datenum(vh.Var1);

%[vh.mdate,ind] = unique(vh.mdate);
%vh.H = vh.Var2(ind);


%plot(bk.Date,bk.WL);hold on


plot(tt.mdate,tt.Var2 - 0.58);hold on

plot(old.Date,old.WL);hold on

plot(gap1.mdate,gap1.Var2 - 0.58);hold on
plot(gap2.mdate,gap2.Var2 - 0.58);hold on
plot(gap3.mdate,gap3.Var2 - 0.58);hold on

[gap1.mdate,ind] = unique(gap1.mdate);
gap1.Var2 = gap1.Var2(ind);
[gap2.mdate,ind] = unique(gap2.mdate);
gap2.Var2 = gap2.Var2(ind);
[gap3.mdate,ind] = unique(gap3.mdate);
gap3.Var2 = gap3.Var2(ind);

tide.Date = old.Date;
tide.WL = old.WL;

sss = find(gap1.mdate > tide.Date(end));
tide.Date = [tide.Date;gap1.mdate(sss)];
tide.WL = [tide.WL;gap1.Var2(sss) - 0.58];

sss = find(gap2.mdate > tide.Date(end));
tide.Date = [tide.Date;gap2.mdate(sss)];
tide.WL = [tide.WL;gap2.Var2(sss) - 0.58];


sss = find(gap3.mdate > tide.Date(end));
tide.Date = [tide.Date;gap3.mdate(sss)];
tide.WL = [tide.WL;gap3.Var2(sss) - 0.58];


sss = find(tt.mdate > tide.Date(end));
tide.Date = [tide.Date;tt.mdate(sss)];
tide.WL = [tide.WL;tt.Var2(sss) - 0.58];


save merged_tide.mat tide -mat;

%plot(vh.mdate,vh.H - 0.58);hold on

%plot(tide.VH.H.Date,tide.VH.H.Data- 0.58);



%plot(tt.mdate,tt.vh_gre);hold on

%plot(tt.mdate + 0.395833333372138,tt.vh_gob - 0.58);hold on

plot(tide.Date,tide.WL);hold on

xlim([datenum(2022,01,01) datenum(2024,01,01)]);

ylim([-2 2]);

set(gca,'xtick',datenum(2022,01:04:28,01),'xticklabel',datestr(datenum(2022,01:04:28,01),'mm-yyyy'));

%legend({'BK';'VH Download';'PREP from BOM';'Current BC';'VH Residual'});
legend({'Tide from WDSA';'Current BC';});