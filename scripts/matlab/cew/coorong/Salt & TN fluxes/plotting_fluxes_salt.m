
clear; close;

load flux_all.mat;

scens={'Base','Scen1','Scen2'};

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
    
    subplot(4,1,1);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).barrage);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel('Salinity Flux (PSU/s)');
    title('(a) Barrages');
    
    subplot(4,1,2);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).ocean);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel('Salinity Flux (PSU/s)');
    title('(b) Ocean Input');
    
    subplot(4,1,3);
    plot(fluxdata.(scens{ii}).Date,fluxdata.(scens{ii}).south);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel('Salinity Flux (PSU/s)');
    title('(c) Southward');
    
    subplot(4,1,4);
    
    cflux=fluxdata.(scens{ii}).south*7200;
    
    for j=2:length(cflux)
        cflux(j)=cflux(j-1)+cflux(j)*7200;
    end
    plot(fluxdata.Base.Date,cflux);
    set(gca,'xlim',[datearray(1) datearray(end)],'XTick',datearray,'XTickLabel',datestr(datearray,'mmm/yy'));
    grid on; box on;
    ylabel('Salinity Flux (PSU)');
    title('(d) Cumulative Southward Flux');
    
    
    print(fig,'-dpng',['salt_fluxes',(scens{ii}),'.png']);
    
end