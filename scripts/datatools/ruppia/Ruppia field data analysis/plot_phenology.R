library(readxl)
library(ggplot2)
library(plyr)
library(ggpubr)

#_______________process phenology data 2020 Dec - 2021 Dec survey  ________________

raw1 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/2_5_3 v1 plant phenology all fields 18Apr2022.xlsx",
                  sheet="edited")
raw1$Sites_siteDate <- as.Date(raw1$Sites_siteDate)
raw1 <- subset (raw1,Sites_siteDate <= "2021-12-31" )  #no useful data in 2022
raw1$data <- 'phenology'

# ggplot(dat, aes(cut(Sites_siteDate,breaks="month"), fruitCountRuppia_m2)) + 
#   geom_boxplot()+
#   theme_bw()+
#   theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
#         panel.background = element_blank(),axis.text.x = element_text(angle = 90),
#         axis.title.x=element_blank()) +
#   scale_x_discrete(labels=c("2020-12","2021-01","2021-02","2021-03","2021-04","2021-05","2021-06",
#                             "2021-07","2021-08","2021-09","2021-10","2021-11","2021-12"))
# 


#______process 2020 Sep - 2021 Dec survey core data (in latlong) _________
raw2 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/All data w est algal biomass.xlsx",
                  sheet="All 4 season data")
raw2$Sites_siteDate <- as.Date(raw2$Sites_siteDate)
raw2$data <- 'seasonal'

cols <- c(grep("Sites_siteDate",colnames(raw1),ignore.case = TRUE),
           grep("Sites_algaeBiomassEstimate_m2",colnames(raw1),ignore.case = TRUE),
           grep("biomassDW_m2",colnames(raw1),ignore.case = TRUE),
           grep("seedCountR_tuberosa_m2",colnames(raw1),ignore.case = TRUE),
           grep("flowerCountRuppia_m2",colnames(raw1),ignore.case = TRUE),
           grep("fruitCountRuppia_m2",colnames(raw1),ignore.case = TRUE),
           grep("shootCount_m2",colnames(raw1),ignore.case = TRUE),
           grep("turionCountTotal_m2",colnames(raw1),ignore.case = TRUE),
           grep("biomassAboveDW_m2",colnames(raw1),ignore.case = TRUE),
           grep("biomassReproductiveDW_m2",colnames(raw1),ignore.case = TRUE),
           grep("biomassTurionDWCalc_m2",colnames(raw1),ignore.case = TRUE),
           grep("data",colnames(raw1),ignore.case = TRUE))
phe <- data.frame(raw1[,cols])

cols <- c(grep("Sites_siteDate",colnames(raw2),ignore.case = TRUE),
          grep("Sites_algaeBiomassEstimate_m2",colnames(raw2),ignore.case = TRUE),
          grep("biomassDW_m2",colnames(raw2),ignore.case = TRUE),
          grep("flowerCountRuppia_m2",colnames(raw2),ignore.case = TRUE),
          grep("seedCountR_tuberosa_m2",colnames(raw2),ignore.case = TRUE),
          grep("fruitCountRuppia_m2",colnames(raw2),ignore.case = TRUE),
          grep("shootCount_m2",colnames(raw2),ignore.case = TRUE),
          grep("turionCountTotal_m2",colnames(raw2),ignore.case = TRUE),
          grep("data",colnames(raw2),ignore.case = TRUE))
season <- data.frame(raw2[,cols])

alldat <- rbind.fill(phe,season)

newdat <-  alldat[which(!is.na(alldat$flowerCountRuppia_m2)),]
p1 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), flowerCountRuppia_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())

newdat <-  alldat[which(!is.na(alldat$fruitCountRuppia_m2)),]
p2 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), fruitCountRuppia_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())

newdat <-  alldat[which(!is.na(alldat$seedCountR_tuberosa_m2)),]
p3 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), seedCountR_tuberosa_m2)) + 
  geom_boxplot(aes(colour=data))+
  geom_point(aes(x="2021-03-01", y=41000),colour="turquoise2",shape=3)+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())+
  ylim(c(0,41000))

newdat <-  alldat[which(!is.na(alldat$biomassReproductiveDW_m2)),]
p4 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), biomassReproductiveDW_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())
  # scale_x_discrete(labels=c("2020-09","2020-10","2020-11","2020-12","2021-01","2021-02","2021-03","2021-04","2021-05","2021-06",
  #                           "2021-07","2021-08","2021-09","2021-10","2021-11","2021-12"))

fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
print(fig)
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/phenology_sexual.png", width = 28, height = 18, units = "cm")



newdat <-  alldat[which(!is.na(alldat$turionCountTotal_m2)),]
p1 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), turionCountTotal_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())

newdat <-  alldat[which(!is.na(alldat$biomassTurionDWCalc_m2)),]
p2 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), biomassTurionDWCalc_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())

fig <-  ggarrange(p1,p2, ncol=2,nrow=1,align = "hv")
print(fig)
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/phenology_asexual.png", width = 28, height = 9, units = "cm")


newdat <-  alldat[which(!is.na(alldat$biomassAboveDW_m2)),]
p1 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), biomassAboveDW_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())
#ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/phenology_biomassAbove.png", width = 14, height = 9, units = "cm",dpi = 300)


newdat <-  alldat[which(!is.na(alldat$Sites_algaeBiomassEstimate_m2)),]
p2 <- ggplot(newdat, aes(cut(Sites_siteDate,breaks="month"), Sites_algaeBiomassEstimate_m2)) + 
  geom_boxplot(aes(colour=data))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),axis.text.x = element_text(angle = 90),
        axis.title.x=element_blank(),legend.title = element_blank())
fig <-  ggarrange(p1,p2, ncol=2,nrow=1,align = "hv")
print(fig)
ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/phenology_shoot_algae.png", width = 28, height = 9, units = "cm",dpi = 300)
