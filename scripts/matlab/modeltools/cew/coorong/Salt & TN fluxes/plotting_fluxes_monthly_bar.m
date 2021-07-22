
clear; close;

load flux_all.mat;

scens={'Base','Scen1','Scen2'};

    vec1=datevec(fluxdata.(scens{1}).Date);
    vec2=datevec(fluxdata.(scens{2}).Date);
    vec3=datevec(fluxdata.(scens{3}).Date);
    
    cflux1=fluxdata.(scens{1}).south*7200;
    cflux2=fluxdata.(scens{2}).south*7200;
    cflux3=fluxdata.(scens{3}).south*7200;
    
    datearray=datenum(2017,7:1:42,1);
    
    dvec=datevec(datearray);
    
    for i=1:length(datearray)
        
        inds=find(vec1(:,1)==dvec(i,1) & vec1(:,2)==dvec(i,2));
        tflux(i,1)=sum(cflux1(inds));
        
        inds=find(vec2(:,1)==dvec(i,1) & vec2(:,2)==dvec(i,2));
        tflux(i,2)=sum(cflux2(inds));
        
        inds=find(vec3(:,1)==dvec(i,1) & vec3(:,2)==dvec(i,2));
        tflux(i,3)=sum(cflux3(inds));
        
    end
    
    %%
fig=figure(1);clf;
def.dimensions = [16 22]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);

set(gcf,'paperposition',[0 0 xSize ySize])  ;

    clf;
    
    subplot(3,1,1);
    
    bar(tflux(1:12,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(1:3:12),'mmm/yy'));
%     grid on; box on;
     ylabel('Monthly Salinity Flux (PSU)');
     title('(a) Jul/2017 - Jun/2018');
     hl=legend('Base case','Scenario 1','Scenario 2');
     set(hl,'Location','southeast');
    
     subplot(3,1,2);
    
    bar(tflux(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
     ylabel('Monthly Salinity Flux (PSU)');
     title('(a) Jul/2017 - Jun/2018');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(3,1,3);
    
    bar(tflux(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
     ylabel('Monthly Salinity Flux (PSU)');
     title('(a) Jul/2017 - Jun/2018');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
     
    print(fig,'-dpng',['bar_fluxes_NS12.png']);
    
