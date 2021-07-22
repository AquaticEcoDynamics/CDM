
clear; close;

load flux_all_TN_inflow.mat;

scens={'Base','Scen1','Scen2'};

    vec1=datevec(fluxdata.(scens{1}).Date);
    vec2=datevec(fluxdata.(scens{2}).Date);
    vec3=datevec(fluxdata.(scens{3}).Date);
    
    cflux1=fluxdata.(scens{1}).south*7200*14/1000000;
    cflux2=fluxdata.(scens{2}).south*7200*14/1000000;
    cflux3=fluxdata.(scens{3}).south*7200*14/1000000;
    
    cflux1n=fluxdata.(scens{1}).north*7200*14/1000000;
    cflux2n=fluxdata.(scens{2}).north*7200*14/1000000;
    cflux3n=fluxdata.(scens{3}).north*7200*14/1000000;
    
    datearray=datenum(2017,7:1:42,1);
    
    dvec=datevec(datearray);
    
    for i=1:length(datearray)
        
        inds=find(vec1(:,1)==dvec(i,1) & vec1(:,2)==dvec(i,2));
        tflux(i,1)=sum(cflux1(inds));
        tfluxn(i,1)=sum(cflux1n(inds));
        
        inds=find(vec2(:,1)==dvec(i,1) & vec2(:,2)==dvec(i,2));
        tflux(i,2)=sum(cflux2(inds));
        tfluxn(i,2)=sum(cflux2n(inds));
        
        inds=find(vec3(:,1)==dvec(i,1) & vec3(:,2)==dvec(i,2));
        tflux(i,3)=sum(cflux3(inds));
        tfluxn(i,3)=sum(cflux3n(inds));
        
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
     ylabel({'TN Flux', '(kg, monthly)'});
     title('(a) Jul/2017 - Jun/2018');
     hl=legend('Base case','Scenario 1','Scenario 2');
     set(hl,'Location','southeast');
    
     subplot(3,1,2);
    
    bar(tflux(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(b) Jul/2018 - Jun/2019');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(3,1,3);
    
    bar(tflux(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(c) Jul/2019 - Jun/2020');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
     
    print(fig,'-dpng',['TN_bar_fluxes_NS12.png']);
    

        %%
fig=figure(1);clf;
def.dimensions = [16 22]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);

set(gcf,'paperposition',[0 0 xSize ySize])  ;

    clf;
    
    subplot(4,1,1);
    
    bar(tflux(1:12,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(1:3:12),'mmm/yy'));
%     grid on; box on;
     ylabel({'TN Flux', '(kg, monthly)'});
     title('(a) Jul/2017 - Jun/2018');
     hl=legend('Base case','Scenario 1','Scenario 2');
     set(hl,'Position',[0.65 0.75 0.2 0.1]);
    
     subplot(4,1,2);
    
    bar(tflux(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(b) Jul/2018 - Jun/2019');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(4,1,3);
    
    hb=bar(tflux(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(c) Jul/2019 - Jun/2020');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
             subplot(4,1,4);
             
             tcflux1=cflux1;
             tcflux2=cflux2;
             tcflux3=cflux3;
             
             for j=2:length(cflux1)
                 tcflux1(j)=tcflux1(j-1)+cflux1(j);
                 tcflux2(j)=tcflux2(j-1)+cflux2(j);
                 tcflux3(j)=tcflux3(j-1)+cflux3(j);
             end
    
    plot(fluxdata.Base.Date,tcflux1,'Color',[0    0.4470    0.7410]);
    hold on;
     plot(fluxdata.Scen1.Date,tcflux2,'Color',[0.8500    0.3250    0.0980]);
    hold on;
     plot(fluxdata.Scen2.Date,tcflux3,'Color',[0.9290    0.6940    0.1250]);
    hold on;
    
    datearray2=datenum(2017,7:6:45,1);
    set(gca,'xlim',[datearray2(1) datearray2(end)],'XTick',datearray2,'XTickLabel',datestr(datearray2,'mmm/yy'));
%     grid on; box on;
      ylabel({'Cumulative TN Flux', '(kg)'});
     title('(d) Cumulative TN Flux');
     hl=legend('Base case','Scenario 1','Scenario 2');
    set(hl,'Position',[0.179 0.182 0.2 0.1]);
    

     
    print(fig,'-dpng',['TN_bar_fluxes_cumulative_NS12.png']);
    
            %%
fig=figure(1);clf;
def.dimensions = [16 22]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);

set(gcf,'paperposition',[0 0 xSize ySize])  ;

    clf;
    
    subplot(4,1,1);
    
    bar(tfluxn(1:12,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(1:3:12),'mmm/yy'));
%     grid on; box on;
     ylabel({'TN Flux', '(kg, monthly)'});
     title('(a) Jul/2017 - Jun/2018');
     hl=legend('Base case','Scenario 1','Scenario 2');
     set(hl,'Position',[0.65 0.75 0.2 0.1]);
    
     subplot(4,1,2);
    
    bar(tfluxn(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(b) Jul/2018 - Jun/2019');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(4,1,3);
    
    hb=bar(tfluxn(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(c) Jul/2019 - Jun/2020');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
             subplot(4,1,4);
             
             tcflux1n=cflux1n;
             tcflux2n=cflux2n;
             tcflux3n=cflux3n;
             
             for j=2:length(cflux1)
                 tcflux1n(j)=tcflux1n(j-1)+cflux1n(j);
                 tcflux2n(j)=tcflux2n(j-1)+cflux2n(j);
                 tcflux3n(j)=tcflux3n(j-1)+cflux3n(j);
             end
    
    plot(fluxdata.Base.Date,tcflux1n,'Color',[0    0.4470    0.7410]);
    hold on;
     plot(fluxdata.Scen1.Date,tcflux2n,'Color',[0.8500    0.3250    0.0980]);
    hold on;
     plot(fluxdata.Scen2.Date,tcflux3n,'Color',[0.9290    0.6940    0.1250]);
    hold on;
    
    datearray2=datenum(2017,7:6:45,1);
    set(gca,'xlim',[datearray2(1) datearray2(end)],'XTick',datearray2,'XTickLabel',datestr(datearray2,'mmm/yy'));
%     grid on; box on;
      ylabel({'Cumulative TN Flux', '(kg)'});
     title('(d) Cumulative TN Flux');
     hl=legend('Base case','Scenario 1','Scenario 2');
    set(hl,'Position',[0.179 0.182 0.2 0.1]);
    

     
    print(fig,'-dpng',['TN_bar_fluxes_cumulative_NS8.png']);
    
                %%
fig=figure(1);clf;
def.dimensions = [25 22]; % Width & Height in cm
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters','PaperOrientation', 'Portrait');
xSize = def.dimensions(1);
ySize = def.dimensions(2);

set(gcf,'paperposition',[0 0 xSize ySize])  ;

    clf;
    
    subplot(4,2,1);
    
    bar(tfluxn(1:12,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(1:3:12),'mmm/yy'));
%     grid on; box on;
     ylabel({'TN Flux', '(kg, monthly)'});
     title('(a) Jul/2017 - Jun/2018, NS8 (Long Point)');
     hl=legend('Base case','Scenario 1','Scenario 2');
     set(hl,'Position',[0.28 0.75 0.1 0.1],'FontSize',8);
    
     subplot(4,2,3);
    
    bar(tfluxn(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(b) Jul/2018 - Jun/2019, NS8 (Long Point)');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(4,2,5);
    
    hb=bar(tfluxn(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(c) Jul/2019 - Jun/2020, NS8 (Long Point)');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
             subplot(4,2,7);
           
    plot(fluxdata.Base.Date,tcflux1n,'Color',[0    0.4470    0.7410]);
    hold on;
     plot(fluxdata.Scen1.Date,tcflux2n,'Color',[0.8500    0.3250    0.0980]);
    hold on;
     plot(fluxdata.Scen2.Date,tcflux3n,'Color',[0.9290    0.6940    0.1250]);
    hold on;
    
    datearray2=datenum(2017,7:6:45,1);
    set(gca,'xlim',[datearray2(1) datearray2(end)],'XTick',datearray2,'XTickLabel',datestr(datearray2,'mmm/yy'));
%     grid on; box on;
      ylabel({'Cumulative TN Flux', '(kg)'});
     title('(d) Cumulative TN Flux, NS8 (Long Point)');
     hl=legend('Base case','Scenario 1','Scenario 2');
    set(hl,'Position',[0.179 0.182 0.1 0.1],'FontSize',8);
    
    subplot(4,2,2);
    
    bar(tflux(1:12,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(1:3:12),'mmm/yy'));
%     grid on; box on;
     ylabel({'TN Flux', '(kg, monthly)'});
     title('(e) Jul/2017 - Jun/2018, NS12 (Parnka Point)');
%      hl=legend('Base case','Scenario 1','Scenario 2');
%      set(hl,'Position',[0.65 0.75 0.2 0.1]);
%     
     subplot(4,2,4);
    
    bar(tflux(13:24,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(13:3:24),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(f) Jul/2018 - Jun/2019, NS12 (Parnka Point)');
   %  hl=legend('Base case','Scenario 1','Scenario 2');
   %  set(hl,'Location','southeast');
     
         subplot(4,2,6);
    
    hb=bar(tflux(25:36,:));
    set(gca,'XTick',1:3:12,'XTickLabel',datestr(datearray(25:3:36),'mmm/yy'));
%     grid on; box on;
      ylabel({'TN Flux', '(kg, monthly)'});
     title('(g) Jul/2019 - Jun/2020, NS12 (Parnka Point)');
    % hl=legend('Base case','Scenario 1','Scenario 2');
    % set(hl,'Location','southeast');
     
             subplot(4,2,8);

    plot(fluxdata.Base.Date,tcflux1,'Color',[0    0.4470    0.7410]);
    hold on;
     plot(fluxdata.Scen1.Date,tcflux2,'Color',[0.8500    0.3250    0.0980]);
    hold on;
     plot(fluxdata.Scen2.Date,tcflux3,'Color',[0.9290    0.6940    0.1250]);
    hold on;
    
    datearray2=datenum(2017,7:6:45,1);
    set(gca,'xlim',[datearray2(1) datearray2(end)],'XTick',datearray2,'XTickLabel',datestr(datearray2,'mmm/yy'));
%     grid on; box on;
      ylabel({'Cumulative TN Flux', '(kg)'});
     title('(h) Cumulative TN Flux, NS12 (Parnka Point)');
%      hl=legend('Base case','Scenario 1','Scenario 2');
%     set(hl,'Position',[0.179 0.182 0.2 0.1]);
    

     
    print(fig,'-dpng',['TN_bar_fluxes_cumulative_all.png']);