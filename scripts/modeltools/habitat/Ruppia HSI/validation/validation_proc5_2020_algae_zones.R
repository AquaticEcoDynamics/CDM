library(readxl)
library(rgdal)
library(ggplot2)
library(sf)
library(viridis)
library(ggnewscale)
library(ggsn)
library(ggpubr)
library(stringr)
library(ggrepel)

#_______________process field data________________


#______2020 Sep - 2021 Dec survey (in latlong) _________
raw <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/All data w est algal biomass.xlsx",
                  sheet="All 4 season data")
poly <- readOGR("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/Coorong_regions_001_R.shp")
poly <- st_as_sf(poly)
poly <-st_transform(poly,32754) #zone54S, datum WGS84

#zone <- readOGR("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/31_material_zones.shp")
zone <- readOGR("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/36_material_zones_v06_005.shp") #newMesh
zone <- st_as_sf(zone)
zone <-st_transform(zone,32754) #zone54S, datum WGS84

raw$Sites_siteID <- as.factor(raw$Sites_siteID)
raw$Sites_siteDate <- as.Date(raw$Sites_siteDate)

#option1 - treat 2021.9-11 as a separate period 'vegetative', but this period only has site data (mostly pres/abs)
raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
                 ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
                        ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-11-30", "2021-09-01",
                               ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
                                      "NA"))))

# #option2 - treat 2021.9-12 as one period like in 2020, but only Dec (reproductive) has quantitative data
# raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
#                  ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
#                         ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-12-31", "2021-09-01",
#                                #                               ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
#                                "NA")))
raw$YM <- as.Date(raw$YM)
dat20 <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,Sites_salinity,Sites_waterDepth1,
                         Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                         Sites_algaeCoverProportion,Sites_algaeBiomassEstimate_m2,
                         biomassDW_m2,seedCountR_megacarpa_m2,seedCountR_tuberosa_m2,RuppiasppSeeds_m2,
                         flowerCountAlthenia, flowerCountRuppia_m2, fruitCountRuppia_m2, shootCount_m2, 
                         turionCountTotal_m2, Sites_DEM_1) ~ YM + Sites_siteID, 
                   data=raw,FUN=mean, na.action=na.pass,na.rm=TRUE)
# write.csv(dat20,'C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/for GIS/All data w est algal biomass_ave_m2.csv',
#           row.names = FALSE, na="")
dat20 <- dat20[which(!is.na(dat20$Sites_Latitude1) & !is.na(dat20$Sites_Longitude1)),] #remove rows without coords
dat20 <- st_as_sf(dat20,coords = c("Sites_Longitude1","Sites_Latitude1"),crs=4326) #this is the EPSG code for WGS84
dat20 <-st_transform(dat20,32754) #zone54S, datum WGS84
#_______________________________________________________________________


#______________process model data_____________________

#setwd("D:/newmag_0616/Plotting_Ruppia/eWater2021_basecase_t3_all/Sheets/shp") #set the folder of all the files to be looped
setwd("E:/HCHB_GEN2_4yrs_20220620_v2/Plotting_Ruppia_all/hchb_Gen2_201707_202201_all/Sheets/shp")
listshp <- dir(pattern = "*.shp") #creates a list of all the shp files in the directory
nmod <- list() #creates an empty list for all input data
names <- list()

for (i in 1:length(listshp)){
  
  names <- paste0(tools::file_path_sans_ext(listshp[i])) #set output name the same as input file
  nmod[[names]] <- readOGR(listshp[i], stringsAsFactors = F)
  nmod[[names]] <- st_as_sf(nmod[[names]])
  st_crs(nmod[[names]]) <- st_crs(dat20)
}

#________________________________________________________________________________________


########### validation loop ##############

outdir <- "C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/validation_newMesh_BB_v4/"

#yr <- 2020  #model years

bufsize <- 100 # meters radius

mod <- list()
dat <- list()
dat_buff <- list()
dat_mod <- list()
valid <- list()
df_valid <-list()
valid_S <-list()
df_valid_S <- list()
valid_buff <-list()
mod_zone <- list()
mod_zoneave <- list()
dat_zone <- list()
dat_zoneave<- list()
datlist <- list()

#____Sep - Dec algae biomass vs Nov BIOMASS____

yr <- 2020:2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("BIOMASS_ulva",a,value=TRUE)  #filter model life stage
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  mod_zone[[y]] <- st_intersection(mod[[y]],zone)  #intersect with zone map
  mod_zone[[y]]$area <- st_area(mod_zone[[y]])  #calculate each cell area
  mod_zone[[y]]$HSI_area <- mod_zone[[y]]$area * mod_zone[[y]]$HSI   # calculate HSI x area
  mod_zoneave[[y]] <- aggregate(cbind(area, HSI_area) ~ Mat, data=mod_zone[[y]],FUN=sum, na.action=na.pass,na.rm=TRUE )  #calculate total area and HSI x area in each zone 
  mod_zoneave[[y]]$HSI_wght <- mod_zoneave[[y]]$HSI_area/mod_zoneave[[y]]$area  #weighted average HSI/biomass in each zone = sum of weighted HSI x area for each zone divided by total area of each zone
  
  if (yr[y] == 2021){
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
    } else {
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
  }
  # dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))
  #dat_buff[[y]] <- st_buffer(dat[[y]],bufsize)
  dat_zone[[y]] <- st_intersection(dat[[y]],zone)  #intersect with zone map
  col <- grep("algaebiomass",colnames(dat_zone[[y]]),ignore.case = TRUE)  #filter field data life stage
  dat_zoneave[[y]] <- aggregate(dat_zone[[y]][,col],by=list(dat_zone[[y]]$Mat),FUN=mean)
  colnames(dat_zoneave[[y]])[1] <- "Mat"
  valid[[y]] <- merge(dat_zoneave[[y]], mod_zoneave[[y]], by = "Mat"  )
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]]$year <- yr[y]
}

alldat <- do.call(rbind, df_valid)

  R <- format(cor(alldat[2],alldat[5],use="complete.obs",method = "spearman"), digits = 2)
  
  ggplot(alldat,aes_string(x=names(alldat)[2],y=names(alldat)[5]))+
    geom_point(aes(colour=factor(year)), #position=position_jitter(h=2, w=2),
                alpha = 0.4, size = 2, show.legend = T)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R), x = -Inf, y = Inf, hjust = -2.3, vjust = 1, colour="grey30")+
    #geom_text(aes(label=Mat),position=position_jitter(width=5,height=5))+ #hjust=0.5, vjust=-0.5, size=3)+
    geom_text_repel(aes(label=Mat), max.overlaps = 100)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled BIOMASS ULVA Nov (g/m2)"))+
    xlab(paste("Field algae biomass Sep-Dec (g/m2)"))
  
  ggsave(paste0(outdir,"algae_biomass_zone_label.png"), 
         width = 12, height = 10, units = "cm",dpi = 300)

  
  
#____Sep - Dec algae biomass vs Nov HSI____  
  
  yr <- 2020:2021  #model years
  for (y in 1:length(yr)){
    a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
    b <- grep("HSI_ulva",a,value=TRUE)  #filter model life stage
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    mod_zone[[y]] <- st_intersection(mod[[y]],zone)  #intersect with zone map
    mod_zone[[y]]$area <- st_area(mod_zone[[y]])  #calculate each cell area
    mod_zone[[y]]$HSI_area <- mod_zone[[y]]$area * mod_zone[[y]]$HSI   # calculate HSI x area
    mod_zoneave[[y]] <- aggregate(cbind(area, HSI_area) ~ Mat, data=mod_zone[[y]],FUN=sum, na.action=na.pass,na.rm=TRUE )  #calculate total area and HSI x area in each zone 
    mod_zoneave[[y]]$HSI_wght <- mod_zoneave[[y]]$HSI_area/mod_zoneave[[y]]$area  #weighted average HSI/biomass in each zone = sum of weighted HSI x area for each zone divided by total area of each zone
    mod_zoneave[[y]]$HSI_scale <- mod_zoneave[[y]]$HSI_wght/max(mod_zoneave[[y]]$HSI_wght)
    
    if (yr[y] == 2021){
      dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
      } else {
      dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
    }
    #dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))
    #dat_buff[[y]] <- st_buffer(dat[[y]],bufsize)
    dat_zone[[y]] <- st_intersection(dat[[y]],zone)  #intersect with zone map
    col <- grep("algaebiomass",colnames(dat_zone[[y]]),ignore.case = TRUE)  #filter field data life stage
    dat_zoneave[[y]] <- aggregate(dat_zone[[y]][,col],by=list(dat_zone[[y]]$Mat),FUN=mean)
    colnames(dat_zoneave[[y]])[1] <- "Mat"
    valid[[y]] <- merge(dat_zoneave[[y]], mod_zoneave[[y]], by = "Mat"  )
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    df_valid[[y]]$year <- yr[y]
  }
  
  alldat <- do.call(rbind, df_valid)
  
  R <- format(cor(alldat[2],alldat[6],use="complete.obs",method = "spearman"), digits = 2)
  
  ggplot(alldat,aes_string(x=names(alldat)[2],y=names(alldat)[6]))+
    geom_point(aes(colour=factor(year)),show.legend = T)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=Mat),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled HSI ULVA Nov (g/m2)"))+
    xlab(paste("Field algae biomass Sep-Dec (g/m2)"))
  
  ggsave(paste0(outdir,"HSI_biomass_zone.png"), 
         width = 12, height = 10, units = "cm",dpi = 300)
 
  
#____Sep - Dec algae biomass vs Nov BIOMASS Benthic____
  
  yr <- 2020:2021  #model years
  for (y in 1:length(yr)){
    a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
    b <- grep("BENTHIC_ulva",a,value=TRUE)  #filter model life stage
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    mod_zone[[y]] <- st_intersection(mod[[y]],zone)  #intersect with zone map
    mod_zone[[y]]$area <- st_area(mod_zone[[y]])  #calculate each cell area
    mod_zone[[y]]$HSI_area <- mod_zone[[y]]$area * mod_zone[[y]]$HSI   # calculate HSI x area
    mod_zoneave[[y]] <- aggregate(cbind(area, HSI_area) ~ Mat, data=mod_zone[[y]],FUN=sum, na.action=na.pass,na.rm=TRUE )  #calculate total area and HSI x area in each zone 
    mod_zoneave[[y]]$HSI_wght <- mod_zoneave[[y]]$HSI_area/mod_zoneave[[y]]$area  #weighted average HSI/biomass in each zone = sum of weighted HSI x area for each zone divided by total area of each zone

    if (yr[y] == 2021){
      dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
      } else {
      dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
    }
    #dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))
    #dat_buff[[y]] <- st_buffer(dat[[y]],bufsize)
    dat_zone[[y]] <- st_intersection(dat[[y]],zone)  #intersect with zone map
    col <- grep("algaebiomass",colnames(dat_zone[[y]]),ignore.case = TRUE)  #filter field data life stage
    dat_zoneave[[y]] <- aggregate(dat_zone[[y]][,col],by=list(dat_zone[[y]]$Mat),FUN=mean)
    colnames(dat_zoneave[[y]])[1] <- "Mat"
    valid[[y]] <- merge(dat_zoneave[[y]], mod_zoneave[[y]], by = "Mat"  )
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    df_valid[[y]]$year <- yr[y]
  }
  
  alldat <- do.call(rbind, df_valid)
  
  R <- format(cor(alldat[2],alldat[5],use="complete.obs",method = "spearman"), digits = 2)
  
  ggplot(alldat,aes_string(x=names(alldat)[2],y=names(alldat)[5]))+
    geom_point(aes(colour=factor(year)),show.legend = T)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=Mat),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled BENTHIC ULVA Nov (g/m2)"))+
    xlab(paste("Field algae biomass Sep-Dec (g/m2)"))
  
  ggsave(paste0(outdir,"algae_benthic_zone.png"), 
         width = 12, height = 10, units = "cm",dpi = 300)
  
  