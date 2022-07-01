
library(readxl)
library(ngnn)


#_______________process field data 2020 Sep - 2021 Dec survey  ________________

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

datrepro <- subset (raw,YM == "2020-09-01" | YM == "2021-09-01" | YM == "2021-12-01")  #2021-09 has no quantitative data except algae
datdorm <- subset (raw,YM == "2021-03-01")


####### reproductive period data ####### for flower, turion, algae
repro <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,Sites_salinity,Sites_waterDepth1,
                         Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                         Sites_algaeCoverProportion,Sites_algaeBiomassEstimate_m2,
                         biomassDW_m2,seedCountR_megacarpa_m2,seedCountR_tuberosa_m2,RuppiasppSeeds_m2,
                         flowerCountAlthenia, flowerCountRuppia_m2, fruitCountRuppia_m2, shootCount_m2, 
                         turionCountTotal_m2, Sites_DEM_1) ~ Sites_siteID, 
                   data=datrepro,FUN=mean, na.action=na.pass,na.rm=TRUE)


# for Ruppia
ruppia <- repro[which(!is.na(repro$Sites_salinity) & !is.na(repro$Sites_waterDepth1)&
                        !is.na(repro$biomassDW_m2) & !is.na(repro$seedCountR_tuberosa_m2)&
                        !is.na(repro$flowerCountRuppia_m2) & !is.na(repro$fruitCountRuppia_m2) &
                        !is.na(repro$shootCount_m2) & !is.na(repro$turionCountTotal_m2) &
                        !is.na(repro$Sites_algaeBiomassEstimate_m2)),] #remove NA rows


spe <- ruppia[,14:22] #dependant variables
id <- ruppia[,c(5,6)] #environmental conditions
i<- sample(1:nrow(spe), size=floor(0.9*nrow(spe)))
spe <-spe[i,]
idi <- id[i,]           
ido <- id[-i,]
nm <- c('Sites_salinity','Sites_waterDepth1')
#nm <- c('Sites_salinity','Est_algalbiomassm2')

res_npmr <- npmr(spe, idi, ido, nm, nmulti=20)
summary(res_npmr)
npmr_sens(obj=res_npmr, pick = 9, nm)


png(file="C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/NPMR_turion.png",width=500, height=400)
plot(res_npmr, pick=c(9), nm)
dev.off()



# for algae
algae <- repro[which(!is.na(repro$Sites_salinity) & !is.na(repro$Sites_waterDepth1)&
                       !is.na(repro$Sites_algaeBiomassEstimate_m2) & !is.na(repro$Sites_algaeCoverProportion)),]

spe <- algae[,12:13] #if chosen only one column you need a dummy 2nd column just so that spe is generated as a dataframe instead of values
id <- algae[,5:6]
i<- sample(1:nrow(spe), size=floor(0.9*nrow(spe)))
spe <- spe[i,]
idi <- id[i,]           
ido <- id[-i,]
nm <- c('Sites_salinity','Sites_waterDepth1')

res_npmr <- npmr(spe, idi, ido, nm, nmulti=20)
summary(res_npmr)
npmr_sens(obj=res_npmr, pick = 1, nm)

png(file="C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/NPMR_algaecover.png",width=500, height=400)
plot(res_npmr, pick=c(1), nm)
dev.off()



####### all period data ####### for shoot/biomass, seed?
all <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,Sites_salinity,Sites_waterDepth1,
                       Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                       Sites_algaeCoverProportion,Sites_algaeBiomassEstimate_m2,
                       biomassDW_m2,seedCountR_megacarpa_m2,seedCountR_tuberosa_m2,RuppiasppSeeds_m2,
                       flowerCountAlthenia, flowerCountRuppia_m2, fruitCountRuppia_m2, shootCount_m2, 
                       turionCountTotal_m2, Sites_DEM_1) ~ Sites_siteID, 
                 data=datrepro,FUN=mean, na.action=na.pass,na.rm=TRUE)

# for Ruppia
ruppia <- all[which(!is.na(all$Sites_salinity) & !is.na(all$Sites_waterDepth1)&
                        !is.na(all$biomassDW) & !is.na(all$seedCountR_tuberosa)&
                        !is.na(all$shootCount)),] #remove NA rows
spe <- ruppia[,c(14,16,21),] #dependant variables
id <- ruppia[,c(5:6)] #environmental conditions
i<- sample(1:nrow(spe), size=floor(0.9*nrow(spe)))
spe <-spe[i,]
idi <- id[i,]           
ido <- id[-i,]
nm <- c('Sites_salinity','Sites_waterDepth1')
#nm <- c('Sites_salinity','Est_algalbiomassm2')

res_npmr <- npmr(spe, idi, ido, nm, nmulti=20)
summary(res_npmr)
npmr_sens(obj=res_npmr, pick = 1, nm)

png(file="C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/NPMR_seagrassbiomass_allperiod.png",width=500, height=400)
plot(res_npmr, pick=c(1), nm)
dev.off()




####### dormant period data ####### for seed?
dorm <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,
                       Sites_salinity,Sites_waterDepth1,Est_algalbiomassm2,Sites_DEM_1,
                       Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                       Sites_algaeCoverProportion,
                       biomassDW,seedCountR_megacarpa,seedCountR_tuberosa,
                       flowerCountAlthenia, flowerCountRuppia, fruitCountRuppia, shootCount, 
                       turionT2Count,turionT1Count) ~ Sites_siteID, 
                 data=datdorm,FUN=mean, na.action=na.pass,na.rm=TRUE)
dorm$turionT12Count <- dorm$turionT1Count + dorm$turionT2Count

# for Ruppia
ruppia <- dorm[which(!is.na(dorm$Sites_salinity) & !is.na(dorm$Sites_waterDepth1)&
                      !is.na(dorm$seedCountR_tuberosa) & !is.na(dorm$turionT12Count)),] #remove NA rows
spe <- ruppia[,c(17,24),] #dependant variables
id <- ruppia[,c(5:6)] #environmental conditions
i<- sample(1:nrow(spe), size=floor(0.75*nrow(spe)))
spe <-spe[i,]
idi <- id[i,]           
ido <- id[-i,]
nm <- c('Sites_salinity','Sites_waterDepth1')
#nm <- c('Sites_salinity','Est_algalbiomassm2')

res_npmr <- npmr(spe, idi, ido, nm, nmulti=20)
summary(res_npmr)
plot(res_npmr, pick=c(2), nm)

npmr_sens(obj=res_npmr, pick = 10, nm)
