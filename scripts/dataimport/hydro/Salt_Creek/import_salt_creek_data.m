clear all; close all;

filename = '../../../../data/incoming/DEW/hydrology/compiled/FINAL_compiledSaltCkData_1990-2021.xlsx';

[snum,sstr] = xlsread(filename,'A2:C11505');


mdate = datenum(sstr(:,1),'dd/mm/yyyy');


salt.Flow.Date = mdate;
salt.Flow.Data = snum(:,1);

salt.SAL.Date = mdate;
salt.SAL.Data = snum(:,2);

subplot(2,1,1)

plot(salt.Flow.Date,salt.Flow.Data);hold on


legend('Salt Creek Flow');

datetick('x');

xlabel('Date');
ylabel('Flow (M^3/s)');
title('Salt Creek Flow: 1990 - 2021');

subplot(2,1,2)

plot(salt.SAL.Date,salt.SAL.Data);hold on


legend('Salt Creek Salinity');

datetick('x');

xlabel('Date');
ylabel('Salinity (PSU)');
title('Salt Creek Salinity: 1990 - 2021');


save('../../../../data/store/hydro/dew_saltcreek.mat','salt','-mat');
