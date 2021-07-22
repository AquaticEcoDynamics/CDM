
clear; close;

load flux_all_TN_inflow.mat;

scens={'Base','Scen1','Scen2'};

%%
for ii=1:length(scens)
    
fig=figure(1);clf;
def.dimensions = [16 22]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);

set(gcf,'paperposition',[0 0 xSize ySize])  ;
datearray=datenum(2017,7:6:45,1);

    clf;
    
    subplot(5,1,1);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).barrageflow*14/1000000);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel({'TN Flux','(kg N/s)'});
    title('(a) Barrages');
    
    subplot(5,1,2);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).ocean*14/1000000);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel({'TN Flux','(kg N/s)'});
    title('(b) Ocean Input');
    
    subplot(5,1,3);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).north*14/1000000);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel({'TN Flux','(kg N/s)'});
    title('(c) Southward - NS8');

        subplot(5,1,4);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).south*14/1000000);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel({'TN Flux','(kg N/s)'});
    title('(d) Southward - NS12');
    
    subplot(5,1,5);
    
    cflux=fluxdata.(scens{ii}).south;
    cflux2=fluxdata.(scens{ii}).north;
    
    cflux(1)=cflux(1)*7200;
    cflux2(1)=cflux2(1)*7200;
    
    for j=2:length(cflux)
        cflux(j)=cflux(j-1)+cflux(j)*7200;
        cflux2(j)=cflux2(j-1)+cflux2(j)*7200;
    end
    plot(fluxdata.Base.Date,cflux2*14/1000000);
    hold on;
    plot(fluxdata.Base.Date,cflux*14/1000000,'k');
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    hl=legend('NS8','NS12');
    set(hl,'Location','Southeast');
    ylabel({'Total TN','(kg)'});
    title('(e) Cumulative Southward Flux');
    
    
    print(fig,'-dpng',['TN_fluxes',(scens{ii}),'_flows.png']);
    
end