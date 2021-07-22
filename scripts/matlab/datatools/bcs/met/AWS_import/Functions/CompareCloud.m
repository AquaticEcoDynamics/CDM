clc
clear
close all

load('D:\Research in UWA\overview of data available in anvil\all_togehter_plotting\anvil.mat');
load('cloud');
sTime  =  datenum('2015/04/01 00:00:00');    %define the simulation period
eTime  =  datenum('2015/05/31 23:55:00');
dateArray = (sTime :1/24/60*5 : eTime)';
timeTick = {'2015/04/01 00:00:00'...
                  '2015/04/10 00:00:00'...
                  '2015/04/20 00:00:00'...
                  '2015/05/01 00:00:00'...
                  '2015/05/10 00:00:00'...
                  '2015/05/20 00:00:00'...
                  '2015/05/31 00:00:00'}';
 timeLable = {' Apr 01' ' Apr 10'  ' Apr 20'   ' May 01' ' May 10'   ' May 20'  ' May 31'   }';            
figure('PaperType','A4');
%  solar radiation
subplot(6,1,1)
SolRad = anvil.Met.DAFWA.LRD.southPerth.SolRad;
ss = find( sTime <= SolRad.Date &SolRad.Date <= eTime );
pp = plot(SolRad.Date(ss,1), SolRad.Data(ss,1));
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel','','TickLength',[0.005 0.015]);
set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'Solar radiation', '(W/m^{2})'});
%  text( sTime + 8,800,'(a)');
 text(0.01,1.1,'(a)','units','normalized');
 grid on   
 
 %GHI
 subplot(6,1,2);
 ss = find( sTime <= cloud.mDate & cloud.mDate <= eTime );
pp = plot(cloud.mDate(ss,1),cloud.GHI(ss,1) );
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel','','TickLength',[0.005 0.015]);
set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'Global horizontal',' radiation', '(W/m^{2})'});
 grid on  
 text(0.01,1.1,'(b)','units','normalized');
 
% cloud daytime
 subplot(6,1,3);
  ss = find( sTime <= cloud.mDate & cloud.mDate <= eTime );
pp = plot(cloud.mDate(ss,1),cloud.mday(ss,1).*100);
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel','','TickLength',[0.005 0.015]);
set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'cloud cover ','at day time', '(%)'});
 grid on  
  text(0.01,1.1,'(c)','units','normalized');
  
 % cloud cover at night with average of daytime
 subplot(6,1,4);
  ss = find( sTime <= cloud.mDate & cloud.mDate <= eTime );
pp = plot(cloud.mDate(ss,1),cloud.Cave(ss,1).*100);
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel','','TickLength',[0.005 0.015]);
set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'cloud cover', 'average method', '(%)'});
 grid on  
  text(0.01,1.1,'(d)','units','normalized');
  % cloud cover at night with median of daytime
 subplot(6,1,5);
  ss = find( sTime <= cloud.mDate & cloud.mDate <= eTime );
pp = plot(cloud.mDate(ss,1),cloud.Cmedian(ss,1).*100);
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel','','TickLength',[0.005 0.015]);
set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'cloud cover', 'median method', '(%)'});
 grid on  
  text(0.01,1.1,'(e)','units','normalized');
 
   % cloud cover at night with linear of daytime
 subplot(6,1,6);
  ss = find( sTime <= cloud.mDate & cloud.mDate <= eTime );
pp = plot(cloud.mDate(ss,1), cloud.Clinear(ss,1).*100);
set(gca,'XTick',[ datenum(timeTick )],'XTickLabel',timeLable,'TickLength',[0.005 0.015]);

set(pp, 'Color',[0 0 0]); % black
box(gca,'on');
clear ss
xlim([sTime  eTime]);
ylabel({'cloud cover ', ' linear method ', '(%)'});
 grid on  
  text(0.01,1.1,'(f)','units','normalized');
  xlabel('Date (2015)');
 set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 29;
% xLeft = (21-xSize)/2;
% yTop = (29.2-ySize)/2;
% set(gcf,'paperposition',[xleft yTop xSize ySize])
set(gcf,'paperposition',[0  0  xSize ySize])


saveas(gcf,[ '1 CompareCloud'],'png');
 
 