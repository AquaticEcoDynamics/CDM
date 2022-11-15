clear all; close all;

load cllmm.mat;


plot(cllmm.A4261207.SAL.Date,cllmm.A4261207.SAL.Data)

datearray = datenum(2012:2020,01,01);

xlim([datearray(1) datearray(end)]);

set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'mm-yy'));