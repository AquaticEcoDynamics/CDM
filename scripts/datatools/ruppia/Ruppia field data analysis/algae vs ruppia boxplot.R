library(readxl)
library(ggplot2)
library(ggpubr)


#______2020 Sep - 2021 Dec survey (in latlong) _________
raw <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/All data w est algal biomass.xlsx",
                  sheet="All 4 season data")

raw$Sites_siteID <- as.factor(raw$Sites_siteID)
raw$Sites_siteDate <- as.Date(raw$Sites_siteDate)

raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
                 ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
                        ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-11-30", "2021-09-01",
                               ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
                                      "NA"))))
raw$YM <- as.Date(raw$YM)
dat <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,Sites_salinity,Sites_waterDepth1,
                       Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                       Sites_algaeCoverProportion,Sites_algaeBiomassEstimate_m2,
                       biomassDW_m2,seedCountR_megacarpa_m2,seedCountR_tuberosa_m2,RuppiasppSeeds_m2,
                       flowerCountAlthenia, flowerCountRuppia_m2, fruitCountRuppia_m2, shootCount_m2, 
                       turionCountTotal_m2, Sites_DEM_1) ~ YM + Sites_siteID, 
                 data=raw,FUN=mean, na.action=na.pass,na.rm=TRUE)

dat$Sites_algaeBiomassEstimate_m2 <- as.factor(dat$Sites_algaeBiomassEstimate_m2)

datrepro <- subset (dat,YM == "2020-09-01" | YM == "2021-09-01" | YM == "2021-12-01")
datdorm <- subset (dat,YM == "2021-03-01")



#all period, but algae is not active during ruppia dormant period so may not be appropriate
all <- dat[which(!is.na(dat$biomassDW_m2) & !is.na(dat$seedCountR_tuberosa_m2)&
                 !is.na(dat$shootCount_m2) & !is.na(dat$turionCountTotal_m2) &
                 !is.na(dat$Sites_algaeBiomassEstimate_m2)),] #remove NA rows

boxplot(all$biomassDW_m2~all$Sites_algaeBiomassEstimate_m2)
boxplot(all$shootCount_m2~all$Sites_algaeBiomassEstimate_m2)
boxplot(all$turionCountTotal_m2~all$Sites_algaeBiomassEstimate_m2)


#reproductive period - may be more appropriate
repro <- datrepro[which(!is.na(datrepro$biomassDW_m2) & !is.na(datrepro$seedCountR_tuberosa_m2)&
                        !is.na(datrepro$flowerCountRuppia_m2) &
                        !is.na(datrepro$shootCount_m2) & !is.na(datrepro$turionCountTotal_m2) &
                        !is.na(datrepro$Sites_algaeBiomassEstimate_m2)),] #remove NA rows

boxplot(repro$biomassDW_m2~repro$Sites_algaeBiomassEstimate_m2)
boxplot(repro$shootCount_m2~repro$Sites_algaeBiomassEstimate_m2)
boxplot(repro$turionCountTotal_m2~repro$Sites_algaeBiomassEstimate_m2)
boxplot(repro$flowerCountRuppia_m2~repro$Sites_algaeBiomassEstimate_m2)


p1 <- ggplot(repro, aes(Sites_algaeBiomassEstimate_m2, biomassDW_m2)) + 
  geom_boxplot()+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())
p2 <- ggplot(repro, aes(Sites_algaeBiomassEstimate_m2, shootCount_m2)) + 
  geom_boxplot()+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())
p3 <- ggplot(repro, aes(Sites_algaeBiomassEstimate_m2, flowerCountRuppia_m2)) + 
  geom_boxplot()+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())
p4 <- ggplot(repro, aes(Sites_algaeBiomassEstimate_m2, turionCountTotal_m2)) + 
  geom_boxplot()+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())

ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
