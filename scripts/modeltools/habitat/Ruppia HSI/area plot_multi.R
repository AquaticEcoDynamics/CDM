library(ggplot2)
library(readxl)
library(tidyr)
library(ggsn)
library(ggpubr)

Ruppia_area <- read.csv("E:/output_basecase_hd_ruppia_new/Plotting_Ruppia/yearlyarea_dual.csv")
#colnames(Ruppia_area)[3]<-"Base"
#data_long <- gather(Ruppia_area, scenario, area, Base:NC5, factor_key=TRUE)
data_long <- Ruppia_area
data_long$stage <- replace(data_long$stage, data_long$stage=='seed_sprout', "germ_sprout")

##bar chart
#for all life stages
data_long$stage_f <- factor(data_long$stage, levels=c('sexual','flower','germ_sprout','viability','adult','turion','asexual')) #set the order of stage groups
#data_long <- data_long[which(!is.na(data_long$stage_f)),] #remove na rows
data_long$Year <- replace(data_long$Year, data_long$Year==2018, "18")
data_long$Year <- replace(data_long$Year, data_long$Year==2019, "19")
data_long$Year <- replace(data_long$Year, data_long$Year==2020, "20")
data_long$Year <- replace(data_long$Year, data_long$Year==2021, "21")

ggplot(data_long, aes(x = Year, y = Basecase,fill = stage_f))+
  geom_col(position = position_dodge())+
  facet_wrap(~stage_f, strip.position = "bottom", nrow=1)+
  scale_fill_manual(values=c('seagreen3','seagreen1','azure3','azure3','azure3','steelblue1','steelblue3'))+
  #scale_fill_brewer(palette="Spectral")+ #, labels=c("all water","no CEW 1 yr","no CEW 2 yrs","no CEW 3 yrs","no CEW 4 yrs", "no CEW 5 yrs"))+
  scale_y_continuous(expand = c(0, 0))+
  theme_classic()+
  guides(fill=guide_legend(title=""))+
  theme(strip.placement = "outside",legend.position = "none")+
  labs(x = "", y = expression ("HSI-weighted habitat area "~km^2))
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_bar.png",
       width = 20, height = 12, units = "cm",dpi = 300)

#for dual, sexual and asexual only
#weighted
dat <- subset(Ruppia_area,(stage=="sexual_only" |stage=="asexual_only"|stage=="dual" ) )
# datnew<-dat[!(dat$Year=="2018" & (dat$scenario=="NC1"|dat$scenario=="NC2"|dat$scenario=="NC3")),]
# datnew<-datnew[!(datnew$Year=="2019" & (datnew$scenario=="NC1"|datnew$scenario=="NC2")),]
# datnew<-datnew[!(datnew$Year=="2020" & datnew$scenario=="NC1"),]
dat$stage_f <- factor(dat$stage, levels=c('asexual_only','sexual_only','dual')) #set the order of stage groups

ggplot(dat, aes(x = Year, y = Basecase, fill = stage_f))+
  geom_bar(position = "stack",stat="identity")+
  #facet_wrap(~Year, strip.position = "bottom", nrow=1, scales="free_x")+
  guides(fill=guide_legend(title=""))+
  scale_fill_manual(values=c('cornflowerblue','palegreen3','yellow3'))+
  # scale_fill_brewer(palette="GnBu", labels=c("all water","no CEW 1 yr","no CEW 2 yrs","no CEW 3 yrs","no CEW 4 yrs", "no CEW 5 yrs"))+
  scale_y_continuous( expand = c(0, 0))+
  theme_classic()+
  theme(strip.placement = "outside")+
  labs(x = "", y = expression ("HSI-weighted habitat area (stacked) "~km^2))
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_stacked_2.png",
       width = 15, height = 9, units = "cm",dpi = 300)


##total area over time
#for all life stages
data_wide <- read.csv("E:/output_basecase_hd_ruppia_new/Plotting_Ruppia/yearlyarea_wide.csv")
ggplot(data_wide)+
  geom_line(aes(x=year,y=sexual,colour="sexual"))+
  geom_line(aes(x=year,y=asexual,colour="asexual"))+
  #geom_line(aes(x=year,y=dual,colour="dual"))+
  geom_line(aes(x=year,y=adult,colour="adult"))+
  geom_line(aes(x=year,y=flower,colour="flower"))+
  geom_line(aes(x=year,y=turion,colour="turion"))+
  geom_line(aes(x=year,y=seed_sprout,colour="seed_sprout"))+
  geom_line(aes(x=year,y=viability,colour="viability"))+
  geom_point(aes(x=year,y=sexual,colour="sexual"))+
  geom_point(aes(x=year,y=asexual,colour="asexual"))+
  #geom_point(aes(x=year,y=dual,colour="dual"))+
  geom_point(aes(x=year,y=adult,colour="adult"))+
  geom_point(aes(x=year,y=flower,colour="flower"))+
  geom_point(aes(x=year,y=turion,colour="turion"))+
  geom_point(aes(x=year,y=seed_sprout,colour="seed_sprout"))+
  geom_point(aes(x=year,y=viability,colour="viability"))+
  scale_colour_discrete(limits=c('viability','seed_sprout','adult','flower','turion','sexual','asexual'))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  xlab("")+
  ylab(expression ("HSI-weighted habitat area "~km^2))
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_years.png",
       width = 15, height = 11, units = "cm",dpi = 300)


##transect for a chosen year 2020
#for all life stages
trans <- read_excel("E:/output_basecase_hd_ruppia_new/Plotting_Ruppia/yearlyarea_poly_2.xlsx",
                    sheet="Sheet1")
trans <- as.data.frame(sapply(trans[3:22,c(2:107)],as.numeric))
trans <- trans[which(trans$totalarea_m2>1000000),] #remove the dodgy tiny polygon
trans20 <- trans[,c(1:2,55:67)]
p1 <- ggplot(trans20)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020sexual`,colour="sexual"),size=1)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020asexual`,colour="asexual"),size=1)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020adult`,colour="adult"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020flower`,colour="flower"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020turion`,colour="turion"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020seed_sprout`,colour="germ_sprout"),linetype=5,size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020viability`,colour="viability"),linetype=3,size=0.5)+
  scale_colour_manual(limits=c('viability','germ_sprout','adult','flower','sexual','turion','asexual'),
                      values=c('grey25','grey25','grey25','seagreen1','seagreen3','steelblue1','steelblue3'))+
  guides(color = guide_legend(override.aes = list(linetype=c(3,5,1,1,1,1,1),size=c(0.5,0.5,0.5,0.5,1,0.5,1) ) ) )+
  annotate("segment",x=62,y=27,xend=62,yend=25.2, arrow=arrow(length=unit(0.3,"cm")))+
  annotate("text",label="Parnka Point",x=62,y=28)+
  annotate("text", label= "north lagoon",vjust=0,x = 28, y = 25.5)+
  annotate("text", label= "south lagoon",vjust=0,x = 88, y = 25.5)+
  coord_cartesian(ylim=c(0,24),clip="off") +
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.title.x=element_blank())+
  theme(plot.margin = unit(c(1,0,0,0), "cm"))+ # This widens the top margin
  #       axis.text.x=element_blank())+
  # xlab("Distance from mouth (km)")+
  ylab(expression ("HSI-weighted habitat area "~km^2))
# ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_transect2020.png",
#        width = 15, height = 9, units = "cm",dpi = 300)

##transect normalised
p2 <- ggplot(trans20)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020sexual`/(trans20$totalarea_m2/1000000)*100,colour="sexual"),size=1)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020asexual`/(trans20$totalarea_m2/1000000)*100,colour="asexual"),size=1)+
  #geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020dual`/(trans20$totalarea_m2/1000000)*100,colour="dual"))+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020adult`/(trans20$totalarea_m2/1000000)*100,colour="adult"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020flower`/(trans20$totalarea_m2/1000000)*100,colour="flower"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020turion`/(trans20$totalarea_m2/1000000)*100,colour="turion"),size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020seed_sprout`/(trans20$totalarea_m2/1000000)*100,colour="germ_sprout"),linetype=5,size=0.5)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020viability`/(trans20$totalarea_m2/1000000)*100,colour="viability"),linetype=3,size=0.5)+
  scale_colour_manual(limits=c('viability','germ_sprout','adult','flower','sexual','turion','asexual'),
                      values=c('grey25','grey25','grey25','seagreen1','seagreen3','steelblue1','steelblue3'))+
  guides(color = guide_legend(override.aes = list(linetype=c(3,5,1,1,1,1,1) ,size=c(0.5,0.5,0.5,0.5,1,0.5,1)) ) )+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  xlab("Distance from Murray Mouth (km)")+
  ylab(expression ("%area containing suitable habitat"))
fig <-  ggarrange(p1,p2, ncol=1, align = "hv",
                  common.legend = TRUE, legend="right",labels = c("(A)","(B)"),hjust=-0.3, vjust=19)
print(fig)
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_transect2020_ab.png",
       width = 18, height = 15, units = "cm",dpi = 300)

#for dual
trans20dual <- trans[,c(1:2,65:67)]
trans20dual_long <- gather(trans20dual,stage, area, `2020dual`:`2020asexual_only`, factor_key=F)
trans20dual_long$stage <- replace(trans20dual_long$stage, trans20dual_long$stage=='2020asexual_only', "asexual_only")
trans20dual_long$stage <- replace(trans20dual_long$stage, trans20dual_long$stage=='2020sexual_only', "sexual_only")
trans20dual_long$stage <- replace(trans20dual_long$stage, trans20dual_long$stage=='2020dual', "dual")
trans20dual_long$stage_f <- factor(trans20dual_long$stage, levels=c('asexual_only','sexual_only','dual')) 

ggplot(trans20dual_long,aes(x=`Distance from mouth`,y=area,fill=stage_f))+
  geom_area(position = "stack",stat="identity")+
  scale_fill_manual(values=c('cornflowerblue','palegreen3','yellow3'))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  xlab("Distance from Murray Mouth (km)")+
  ylab(expression ("HSI-weighted habitat area (stacked) "~km^2))
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_stacked_transect2020_dual_2.png",
       width = 20, height = 9, units = "cm",dpi = 300)



#dual normalised
ggplot(trans20)+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020sexual_only`/(trans20$totalarea_m2/1000000),colour="sexual_only"))+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020asexual_only`/(trans20$totalarea_m2/1000000),colour="asexual_only"))+
  geom_line(aes(x=trans20$`Distance from mouth`,y=trans20$`2020dual`/(trans20$totalarea_m2/1000000),colour="dual"))+
  scale_colour_manual(values=c('darkgreen','palegreen3','grey25'),
                      breaks=c('dual','sexual_only', 'asexual_only'))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  xlab("Distance from Murray Mouth (km)")+
  ylab(expression ("Annual average suitable habitat (normalised)"~km^2))
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_transect2020_dual_norm.png",
       width = 18, height = 10, units = "cm",dpi = 300)




##transect for a chosen year 2021
#for all life stages
trans <- read_excel("E:/output_basecase_hd_ruppia_new/Plotting_Ruppia/yearlyarea_poly_2.xlsx",
                    sheet="Sheet1")
trans <- as.data.frame(sapply(trans[3:22,c(2:107)],as.numeric))
trans <- trans[which(trans$totalarea_m2>1000000),] #remove the dodgy tiny polygon
trans21 <- trans[,c(1:2,81:93)]
p1 <- ggplot(trans20)+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021sexual`,colour="sexual"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021asexual`,colour="asexual"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021adult`,colour="adult"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021flower`,colour="flower"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021turion`,colour="turion"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021seed_sprout`,colour="germ_sprout"),linetype=5)+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021viability`,colour="viability"),linetype=3)+
  scale_colour_manual(limits=c('viability','germ_sprout','adult','flower','sexual','turion','asexual'),
                      values=c('grey25','grey25','grey25','seagreen1','seagreen3','steelblue1','steelblue3'))+
  guides(color = guide_legend(override.aes = list(linetype=c(3,5,1,1,1,1,1) ) ) )+
  annotate("segment",x=62,y=27,xend=62,yend=25.2, arrow=arrow(length=unit(0.3,"cm")))+
  annotate("text",label="Parnka Point",x=62,y=28)+
  annotate("text", label= "north lagoon",vjust=0,x = 28, y = 25.5)+
  annotate("text", label= "south lagoon",vjust=0,x = 88, y = 25.5)+
  coord_cartesian(ylim=c(0,24),clip="off") +
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  theme(axis.title.x=element_blank())+
  theme(plot.margin = unit(c(1,0,0,0), "cm"))+ # This widens the top margin
  #       axis.text.x=element_blank())+
  # xlab("Distance from mouth (km)")+
  ylab(expression ("HSI-weighted habitat area "~km^2))
# ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_transect2021.png",
#        width = 15, height = 9, units = "cm",dpi = 300)

##transect normalised
p2 <- ggplot(trans21)+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021sexual`/(trans21$totalarea_m2/1000000)*100,colour="sexual"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021asexual`/(trans21$totalarea_m2/1000000)*100,colour="asexual"))+
  #geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021dual`/(trans21$totalarea_m2/1000000)*100,colour="dual"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021adult`/(trans21$totalarea_m2/1000000)*100,colour="adult"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021flower`/(trans21$totalarea_m2/1000000)*100,colour="flower"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021turion`/(trans21$totalarea_m2/1000000)*100,colour="turion"))+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021seed_sprout`/(trans21$totalarea_m2/1000000)*100,colour="germ_sprout"),linetype=5)+
  geom_line(aes(x=trans21$`Distance from mouth`,y=trans21$`2021viability`/(trans21$totalarea_m2/1000000)*100,colour="viability"),linetype=3)+
  scale_colour_manual(limits=c('viability','germ_sprout','adult','flower','sexual','turion','asexual'),
                      values=c('grey25','grey25','grey25','seagreen1','seagreen3','steelblue1','steelblue3'))+
  guides(color = guide_legend(override.aes = list(linetype=c(3,5,1,1,1,1,1) ) ) )+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  theme(legend.title = element_blank()) +
  xlab("Distance from mouth (km)")+
  ylab(expression ("%area containing suitable habitat"))
fig <-  ggarrange(p1,p2, ncol=1, align = "hv",
                  common.legend = TRUE, legend="right",labels = c("(A)","(B)"),hjust=-0.3, vjust=19)
print(fig)
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/area/area_transect2021_ab.png",
       width = 18, height = 15, units = "cm",dpi = 300)
