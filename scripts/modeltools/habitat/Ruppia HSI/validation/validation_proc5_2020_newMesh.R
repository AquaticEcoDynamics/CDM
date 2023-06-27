library(readxl)
library(rgdal)
library(ggplot2)
library(sf)
library(viridis)
library(ggnewscale)
library(ggsn)
library(ggpubr)
library(stringr)

#_______________process field data________________


#______2020 Sep - 2021 Dec survey (in latlong) _________
raw <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/All data w est algal biomass.xlsx",
                  sheet="All 4 season data")
poly <- readOGR("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/Coorong_regions_001_R.shp")
poly <- st_as_sf(poly)
poly <-st_transform(poly,32754) #zone54S, datum WGS84

raw$Sites_siteID <- as.factor(raw$Sites_siteID)
raw$Sites_siteDate <- as.Date(raw$Sites_siteDate)

# #option1 - treat 2021.9-11 as a separate period 'vegetative', but this period only has site data (mostly pres/abs) #this option is better for algae
# raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
#                  ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
#                         ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-11-30", "2021-09-01",
#                                ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
#                                       "NA"))))

# #option2 - treat 2021.9-12 as one period like in 2020, but only Dec (reproductive) has quantitative data
raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
                 ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
                        ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-12-31", "2021-09-01",
                               #                               ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
                               "NA")))
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

#setwd("E:/HCHB_GEN2_4yrs_20220620_v2/Plotting_Ruppia_all/hchb_Gen2_201707_202201_all/Sheets/shp") #set the folder of all the files to be looped
setwd("E:/CDM22_newMesh_BB/Plotting_Ruppia/eWater_basecase_newMesh_BB_TEST_v4_all/Sheets/shp")
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
dir.create(file.path(outdir))

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


## New sexual HSI area weighted vs field flower/seed count  
##__________________________________

#____Sep 2020 flower count____
yr <- 2020  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_10"))),listshp,value=TRUE) #filter model year
  b <- grep("_sexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("flowerCountRuppia",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) #intersect with polygon so we know which sites are in North or South
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  # df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
  #                                                    probs=c(0.2,0.4,0.6,0.8,1)  #bin data into 4 groups by equal count
  # )),
  # include.lowest = TRUE,dig.lab=5)  #grouping by quantile does not work in this case as too many zeros in field data
  # df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],breaks= c(0,1,100,200,400,700),
  # include.lowest = TRUE,dig.lab=10)
  # 
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],breaks= 4,
                             include.lowest = TRUE,dig.lab=3) #4 groups by equal interval
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="loess",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Oct",yr[y]))+
    xlab(paste("Field flower count Sep-Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Oct",yr[y]))+
    xlab(paste("Field flower count Sep-Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  # df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2], 
  #                                                                             probs=c(0,0.2,0.4,0.6,0.8,1)  
  # )),
  # include.lowest = TRUE,dig.lab=10)  #ceiling is to round up  #bin data into 5 groups by equal count
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],breaks=4,include.lowest = TRUE,dig.lab=3) #can't cut by quantile as breaks are not unique
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="loess",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Oct",yr[y]))+
    xlab(paste("Field flower count Sep-Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Oct",yr[y]))+
    xlab(paste("Field flower count Sep-Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"flower2020_sexual2020.png"),
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}


#____Dec 2021 flower count____
yr <- 2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("_sexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("flowerCountRuppia",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) #intersect with polygon so we know which sites are in North or South
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  #  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
  #                                                    probs=c(0,0.2,0.4,0.6,0.8,1)  #bin data into 5 groups by equal count
  #  )),
  #  include.lowest = TRUE,dig.lab=10)
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],breaks= 4,
                             include.lowest = TRUE,dig.lab=3) #4 groups by equal interval
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +     
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field flower count Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field flower count Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  # df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
  #                                                          probs=c(0,0.2,0.4,0.6,0.8,1)
  # )),
  # include.lowest = TRUE,dig.lab=10)  #ceiling is to round up  #bin data into 5 groups by equal count
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],breaks= 4,
                               include.lowest = TRUE,dig.lab=3) #4 groups by equal interval
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)   
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")   
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field flower count Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field flower count Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"flower2021_sexual2021.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____March 2021 seed count____  
yr <- 2020  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("_sexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y]+1,"-03-01"),fixed=TRUE))  #gsub removes space between year and -03-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("seedCountR_tuberosa",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 4 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Mar",yr[y]+1))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Mar",yr[y]+1))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5)  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)   
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")   
  P <- format(test$p.value, digits =2)
  #R <- format(cor(df_valid_S[[y]][5],log(df_valid_S[[y]][2]+1),use="complete.obs"), digits = 2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI Dec sexual",yr[y]))+
    xlab(paste("Field seed count Mar",yr[y]+1))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI Dec sexual",yr[y]))+
    xlab(paste("Field seed count Mar",yr[y]+1))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  ggsave(paste0(outdir,"seed2021_sexual2020.png"),
         width = 20, height = 20, units = "cm",dpi = 300)
  print(fig)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Dec 2021 seed count____ (timing not ideal)
yr <- 2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("_sexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("seedCountR_tuberosa",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) #intersect with polygon so we know which sites are in North or South
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  # df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
  #                                                    probs=c(0,0.2,0.4,0.6,0.8,1)  #bin data into 5 groups by equal count
  # )),
  # include.lowest = TRUE,dig.lab=10)
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],breaks= 3,
                             include.lowest = TRUE,dig.lab=3) #4 groups by equal interval
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  # df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
  #                                                                             probs=c(0,0.2,0.4,0.6,0.8,1)
  # )),
  # include.lowest = TRUE,dig.lab=10)  #ceiling is to round up  #bin data into 5 groups by equal count
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],breaks= 3,
                               include.lowest = TRUE,dig.lab=3) #4 groups by equal interval
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)   
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")   
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ###geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI sexual Dec",yr[y]))+
    xlab(paste("Field seed count Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"seed2021_sexual2021.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}






## new asexual HSI area weighted vs field turion count
##__________________________________


#____Sep turion count____
yr <- 2020  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_10"))),listshp,value=TRUE) #filter model year
  b <- grep("asexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("turionCountTotal",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0.2,0.4,0.6,0.8,1)  #bin data into 4 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  # df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],breaks= 4,
  #                            include.lowest = TRUE,dig.lab=5) #4 groups by equal interval
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm", se = FALSE,show.legend = FALSE, colour="grey30")+
    #geom_smooth(method="lm",formula=y~log(x+1), se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    #scale_x_continuous(trans = "log")+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Oct",yr[y]))+
    xlab(paste("Field turion count Sep-Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Oct",yr[y]))+
    xlab(paste("Field turion count Sep-Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],  #ceiling is to round up
                                                                    probs=c(0.2,0.4,0.6,0.8,1)  #bin data into 4 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  # df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],breaks= 4,
  #                            include.lowest = TRUE,dig.lab=5) #4 groups by equal interval
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  #R <- format(cor(df_valid_S[[y]][5],log(df_valid_S[[y]][2]+1),use="complete.obs"), digits = 2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    #geom_smooth(method="lm",formula=y~log(x+1),se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Oct",yr[y]))+
    xlab(paste("Field turion count Sep-Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Oct",yr[y]))+
    xlab(paste("Field turion count Sep-Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"turion2020_asexual2020.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Dec 2021 turion count____

yr <- 2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("asexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("turionCountTotal",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 5 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5) #dig.lab - number of digits used, so it's not in scientific notation
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = F)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5) #dig.lab - number of digits used, so it's not in scientific notation  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  #R <- format(cor(df_valid_S[[y]][5],log(df_valid_S[[y]][2]+1),use="complete.obs"), digits = 2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"turion2021_asexual2021.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}


#____Mar turion count____  

yr <- 2020  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("asexual",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y]+1,"-03-01"),fixed=TRUE))  #gsub removes space between year and -03-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("turionCountTotal",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 5 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Mar",yr[y]+1))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Mar",yr[y]+1))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5)  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Mar",yr[y]+1))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI asexual Dec",yr[y]))+
    xlab(paste("Field turion count Mar",yr[y]+1))
  
  fig <-  ggarrange(p1,p2,p3,p4,ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"turion2021_asexual2020.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}




## germination_sprouting_adult HSI area weighted vs field shoot count Sep
##__________________________________


#____Sep 2020 shoot count____
yr <- 2020  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],".shp"))),listshp,value=TRUE) #filter model year
  b <- grep("germ_spr_adt",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("shootCount",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 5 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Sep-Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Sep-Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5)  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Sep-Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Sep-Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"shoot2020_germspradt2020.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Dec 2021 shoot count____
yr <- 2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],".shp"))),listshp,value=TRUE) #filter model year
  b <- grep("germ_spr_adt",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("shootCount",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 5 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5)  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    ##geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"shoot2021_germspradt2021.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}


#____Dec 2021 shoot count vs HSI Nov____
yr <- 2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("germ_spr_adt",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("shootCount",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$HSI_wght >=0.8 & valid[[y]]$HSI_wght<=1,"0.8-1",
  #                                ifelse(valid[[y]]$HSI_wght >=0.6 & valid[[y]]$HSI_wght<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$HSI_wght >=0.4 & valid[[y]]$HSI_wght<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$HSI_wght >=0.2 & valid[[y]]$HSI_wght<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
  df_valid[[y]]$obsqt <- cut(df_valid[[y]][,2],ceiling(quantile(df_valid[[y]][,2],  #ceiling is to round up
                                                                probs=c(0,0.25,0.5,0.75,1)  #bin data into 5 groups by equal count
  )),
  include.lowest = TRUE,dig.lab=5)
  ticks <- levels(df_valid[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med <- median(unlist(df_valid[[y]][2]))
  sight <- sum(df_valid[[y]][5]>=0.5 & df_valid[[y]][2]>med)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid[[y]][2]>med) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid[[y]][5]>=0.5)/nrow(df_valid[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid[[y]][5]<0.5 & df_valid[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin <- ifelse(med ==0,min(df_valid[[y]][2][df_valid[[y]][2] > 0]),med)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_rect(aes(xmin = xmin, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
  df_valid_S[[y]]$obsqt <- cut(df_valid_S[[y]][,2],ceiling(quantile(df_valid_S[[y]][,2],
                                                                    probs=c(0,0.25,0.5,0.75,1)
  )),
  include.lowest = TRUE,dig.lab=5)  #ceiling is to round up  #bin data into 4 groups by equal count
  ticks <- levels(df_valid_S[[y]]$obsqt)
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=,)"),"0",ticks[1]) #to change the negative number in first group to 0
  ticks[1] <- gsub(str_extract(ticks[1], "(\\d)+(?=.)"),"0",ticks[1])
  newticks <- gsub("[[]", "", ticks) #change tick labels manually for plotting later
  newticks <- gsub("[-]", "", newticks)
  newticks <- gsub("[]]", "", newticks)
  newticks <- gsub("[(]", "", newticks)
  newticks <- sub(",","-",  newticks)
  newticks <- sub("0.0","0",  newticks)
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  med_S <- median(unlist(df_valid_S[[y]][2]))
  sight <- sum(df_valid_S[[y]][5]>=0.5 & df_valid_S[[y]][2]>med_S)  # #event of major sightings (population size>=median, or >median if med=0) within preferred habitat (HSI>=0.5). 
  prop1 <- sight/sum(df_valid_S[[y]][2]>med_S) #proportion of major sightings within preferred habitat 
  prop2 <- sum(df_valid_S[[y]][5]>=0.5)/nrow(df_valid_S[[y]]) #proportion of survey area (#sites) containing preferred habitat
  score <- format(prop1/prop2, digits=3)
  
  TP <- sight  #true positive
  TN <- sum(df_valid_S[[y]][5]<0.5 & df_valid_S[[y]][2]<=med) #true negative
  fit <- format((TP+TN)/nrow(df_valid_S[[y]])*100, digits=2)  #proportion of TP&TN in the whole sample
  
  xmin_S <- ifelse(med_S ==0,min(df_valid_S[[y]][2][df_valid_S[[y]][2] > 0]),med_S)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_rect(aes(xmin = xmin_S, xmax = Inf), ymin = 0.5, ymax = Inf, fill = "gray95")+
    geom_rect(aes(xmin = -Inf, xmax = xmin_S), ymin = -Inf, ymax = 0.5, fill = "gray85")+
    geom_vline(xintercept = xmin_S, linetype="dashed", colour="gray30")+
    geom_hline(yintercept = 0.5, linetype="dashed", colour="gray30")+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score, ", fit = ", fit, "%"), 
             x = -Inf, y = Inf, hjust = -0.25, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylim(c(0,1))+
    ylab(paste("Modelled HSI germ, spr & adt Sep",yr[y]))+
    xlab(paste("Field shoot count Dec",yr[y]))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"shoot2021_germspradt2021_11.png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}



## ULVA HSI/biomass area weighted vs field algae proportion
##__________________________________

#for algae the field data dates raw$YM needs to go with option 1

#option1 - treat 2021.9-11 as a separate period 'vegetative', but this period only has site data (mostly pres/abs) #this option is better for algae
raw$YM <- ifelse(raw$Sites_siteDate <= "2020-12-31", "2020-09-01",
                 ifelse(raw$Sites_siteDate >= "2021-03-01" & raw$Sites_siteDate <= "2021-04-30", "2021-03-01",
                        ifelse(raw$Sites_siteDate >= "2021-08-01" & raw$Sites_siteDate <= "2021-11-30", "2021-09-01",
                               ifelse(raw$Sites_siteDate >= "2021-12-01" & raw$Sites_siteDate <= "2021-12-31", "2021-12-01",
                                      "NA"))))
raw$YM <- as.Date(raw$YM)
dat20 <- aggregate(cbind(Sites_Latitude1,Sites_Longitude1,DFMM_rounded,Sites_salinity,Sites_waterDepth1,
                         Sites_plantsPresent,Sites_flowersRuppia,Sites_flowersAlthenia,Sites_fruitRuppia,Sites_seedsRuppia,
                         Sites_algaeCoverProportion,Sites_algaeBiomassEstimate_m2,
                         biomassDW_m2,seedCountR_megacarpa_m2,seedCountR_tuberosa_m2,RuppiasppSeeds_m2,
                         flowerCountAlthenia, flowerCountRuppia_m2, fruitCountRuppia_m2, shootCount_m2, 
                         turionCountTotal_m2, Sites_DEM_1) ~ YM + Sites_siteID, 
                   data=raw,FUN=mean, na.action=na.pass,na.rm=TRUE)
dat20 <- dat20[which(!is.na(dat20$Sites_Latitude1) & !is.na(dat20$Sites_Longitude1)),] #remove rows without coords
dat20 <- st_as_sf(dat20,coords = c("Sites_Longitude1","Sites_Latitude1"),crs=4326) #this is the EPSG code for WGS84
dat20 <-st_transform(dat20,32754) #zone54S, datum WGS84

#____Sep - Dec algae biomass vs Nov BIOMASS____
yr <- 2020:2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("BIOMASS_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  
  if (yr[y] == 2021){
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
  } else {
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
  }
  #dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algaebiomass",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeBiomassEstimate_m2)),] #remove NA rows 
  valid[[y]]$algae_range <- as.factor(valid[[y]]$Sites_algaeBiomassEstimate_m2)
  valid[[y]]$algae_range <- factor(valid[[y]]$algae_range,c("0","3.7","36.8","184.1","368.2","736.5")) #reorder factor levels
  
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  if (yr[y] == 2021){ 
    xlab <- paste("Field algae biomass Dec",yr[y],"(g/m2)")
  } else {
    xlab <- paste("Field algae biomass Sep-Dec",yr[y],"(g/m2)")
  }
  
  ylab <- paste("Modelled BIOMASS ULVA Nov",yr[y],"(g/m2)")
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[6],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  #    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[6],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  #    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"algae_biomass_",yr[y],".png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Sep - Dec algae biomass vs Nov Benthic BIOMASS____
yr <- 2020:2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("BENTHIC_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  
  if (yr[y] == 2021){ 
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
  } else {
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
  }
  #  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algaebiomass",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeBiomassEstimate_m2)),] #remove NA rows 
  valid[[y]]$algae_range <- as.factor(valid[[y]]$Sites_algaeBiomassEstimate_m2)
  valid[[y]]$algae_range <- factor(valid[[y]]$algae_range,c("0","3.7","36.8","184.1","368.2","736.5")) #reorder factor levels
  
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  if (yr[y] == 2021){ 
    xlab <- paste("Field algae biomass Dec",yr[y],"(g/m2)")
  } else {
    xlab <- paste("Field algae biomass Sep-Dec",yr[y],"(g/m2)")
  }
  
  ylab <- paste("Modelled BIOMASS ULVA Nov",yr[y],"(g/m2)")
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[6],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  #    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[6],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  #    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"algae_benthicbiomass_",yr[y],".png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Sep - Dec algae prop vs Nov HSI ____
yr <- 2020:2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("HSI_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  
  if (yr[y] == 2021){ 
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
  } else {
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
  }
  # dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algaeCoverProportion",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]]$HSI_scale <- valid[[y]]$HSI_wght/max(valid[[y]]$HSI_wght)
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeCoverProportion)),] #remove NA rows 
  valid[[y]]$algae_range <- ifelse(valid[[y]]$Sites_algaeCoverProportion >= 80 & valid[[y]]$Sites_algaeCoverProportion<=100,"80-100",
                                   ifelse(valid[[y]]$Sites_algaeCoverProportion >=60 & valid[[y]]$Sites_algaeCoverProportion<80, "60-80",
                                          ifelse(valid[[y]]$Sites_algaeCoverProportion >=40 & valid[[y]]$Sites_algaeCoverProportion<60, "40-60",
                                                 ifelse(valid[[y]]$Sites_algaeCoverProportion >=20 & valid[[y]]$Sites_algaeCoverProportion<40, "20-40",
                                                        "0-20"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid[[y]][6],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  if (yr[y] == 2021){ 
    xlab <- paste("Field algae cover Dec",yr[y],"(%)")
  } else {
    xlab <- paste("Field algae cover Sep-Dec",yr[y],"(%)")
  }
  
  ylab <- paste("Modelled HSI ULVA Nov",yr[y],"(g/m2)")
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[6]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[6]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[6]))+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[6]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"algaecover_HSI_",yr[y],".png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}


#____Sep - Dec algae biomass vs Nov HSI____   
yr <- 2020:2021  #model years
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_11"))),listshp,value=TRUE) #filter model year
  b <- grep("HSI_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  if (yr[y] == 2021){ 
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-12-01"),fixed=TRUE))
  } else {
    dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE)) #gsub removes space between year and -09-01
  }
  # dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algaebiomass",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]]$HSI_scale <- valid[[y]]$HSI_wght/max(valid[[y]]$HSI_wght)
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeBiomassEstimate_m2)),] #remove NA rows 
  # valid[[y]]$algae_range <- ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==0,"0",
  #                                  ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==3.7, "3.7",
  #                                         ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==36.8, "36.8",
  #                                                ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==184.1, "184.1",
  #                                                       ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==368.2, "368.2",
  #                                                              ifelse(valid[[y]]$Sites_algaeBiomassEstimate_m2 ==736.5, "736.5",
  #                                                                     "NA"))))))
  valid[[y]]$algae_range <- as.factor(valid[[y]]$Sites_algaeBiomassEstimate_m2)
  valid[[y]]$algae_range <- factor(valid[[y]]$algae_range,c("0","3.7","36.8","184.1","368.2","736.5")) #reorder factor levels
  
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid[[y]][6],df_valid[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid[[y]][5]),unlist(df_valid[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  if (yr[y] == 2021){ 
    xlab <- paste("Field algae biomass Dec",yr[y],"(g/m2)")
  } else {
    xlab <- paste("Field algae biomass Sep-Dec",yr[y],"(g/m2)")
  }
  
  ylab <- paste("Modelled HSI ULVA Nov",yr[y],"(g/m2)")
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[6]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[6]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs",method = "spearman"), digits = 2)
  test <- cor.test(unlist(df_valid_S[[y]][5]),unlist(df_valid_S[[y]][2]),use="complete.obs",method = "spearman")
  P <- format(test$p.value, digits =2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    #geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("rs = ",R, ", score = ", score), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[6]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave(paste0(outdir,"biomass_HSI",yr[y],".png"), 
         width = 20, height = 20, units = "cm",dpi = 300)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}





#____Sep algae biomass vs Sep HSI____   #not in use
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_9"))),listshp,value=TRUE) #filter model year
  b <- grep("HSI_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algalbiomass",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Est_algalbiomassm2)),] #remove NA rows 
  valid[[y]]$algae_range <- ifelse(valid[[y]]$Est_algalbiomassm2 ==0,"0",
                                   ifelse(valid[[y]]$Est_algalbiomassm2 ==3.7, "3.7",
                                          ifelse(valid[[y]]$Est_algalbiomassm2 ==36.8, "36.8",
                                                 ifelse(valid[[y]]$Est_algalbiomassm2 ==184.1, "184.1",
                                                        ifelse(valid[[y]]$Est_algalbiomassm2 ==368.2, "368.2",
                                                               ifelse(valid[[y]]$Est_algalbiomassm2 ==736.5, "736.5",
                                                                      "NA"))))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs"), digits = 2)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae biomass Sep",yr[y],"(g/m2)"))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[6],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae biomass Sep",yr[y],"(g/m2)"))+
    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs"), digits = 2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae biomass Sep",yr[y],"(g/m2)"))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[6],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae biomass Sep",yr[y],"(g/m2)"))+
    scale_x_discrete(limits=c("0", "3.7", "36.8","184.1","368.2","736.5"))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#____Sep algae prop vs Sep HSI____  #not in use
for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_9"))),listshp,value=TRUE) #filter model year
  b <- grep("HSI_ulva",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("algaeCoverProportion",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Sites_siteID),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Sites_siteID),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeCoverProportion)),] #remove NA rows 
  valid[[y]]$algae_range <- ifelse(valid[[y]]$Sites_algaeCoverProportion >= 80 & valid[[y]]$Sites_algaeCoverProportion<=100,"80-100",
                                   ifelse(valid[[y]]$Sites_algaeCoverProportion >=60 & valid[[y]]$Sites_algaeCoverProportion<80, "60-80",
                                          ifelse(valid[[y]]$Sites_algaeCoverProportion >=40 & valid[[y]]$Sites_algaeCoverProportion<60, "40-60",
                                                 ifelse(valid[[y]]$Sites_algaeCoverProportion >=20 & valid[[y]]$Sites_algaeCoverProportion<40, "20-40",
                                                        "0-20"))))
  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly)
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs"), digits = 2)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[6],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs"), digits = 2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[6],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(paste("Modelled HSI ULVA Sep",yr[y]))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

##____________________________________________________________________

## ULVA biomass vs field algae proportion   !script needs updating
##__________________________________
#yr <- 2020  #model years

#____Sep algae prop____
for (y in 1:length(yr)){
  a <- grep(yr[y],listshp,value=TRUE) #filter model year
  b <- grep("BIOMASS_ULVA",a,value=TRUE)  #filter model life stage
  
  #  if (length(b)>0 & length(grep(as.character(yr[y]+1),dat20$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(dat20, YM == gsub(" ","",paste(yr[y],"-09-01"),fixed=TRUE))  #gsub removes space between year and -09-01
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  
  col <- grep("algaeCoverProportion",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- aggregate(cbind(dat_mod[[y]][,col],dat_mod[[y]]$HSI),by=list(dat_mod[[y]]$Sites_siteID),FUN=mean)
  valid[[y]] <- valid[[y]][which(!is.na(valid[[y]]$Sites_algaeCoverProportion)),] #remove NA rows 
  
  # valid[[y]]$HSI_range <- ifelse(valid[[y]]$dat_mod..y...HSI >=0.8 & valid[[y]]$dat_mod..y...HSI<=1,"0.8-1",
  #                                ifelse(valid[[y]]$dat_mod..y...HSI >=0.6 & valid[[y]]$dat_mod..y...HSI<0.8, "0.6-0.8",
  #                                       ifelse(valid[[y]]$dat_mod..y...HSI >=0.4 & valid[[y]]$dat_mod..y...HSI<0.6, "0.4-0.6",
  #                                              ifelse(valid[[y]]$dat_mod..y...HSI >=0.2 & valid[[y]]$dat_mod..y...HSI<0.4, "0.2-0.4",
  #                                                     "0-0.2"))))
  valid[[y]]$algae_range <- ifelse(valid[[y]]$Sites_algaeCoverProportion >= 80 & valid[[y]]$Sites_algaeCoverProportion<=100,"80-100",
                                   ifelse(valid[[y]]$Sites_algaeCoverProportion >=60 & valid[[y]]$Sites_algaeCoverProportion<80, "60-80",
                                          ifelse(valid[[y]]$Sites_algaeCoverProportion >=40 & valid[[y]]$Sites_algaeCoverProportion<60, "40-60",
                                                 ifelse(valid[[y]]$Sites_algaeCoverProportion >=20 & valid[[y]]$Sites_algaeCoverProportion<40, "20-40",
                                                        "0-20"))))
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  R <- format(cor(df_valid[[y]][3],df_valid[[y]][2],use="complete.obs"), digits = 2)
  #r <- cor(valid[[y]][3],valid[[y]][2])
  # lm_eqn <- function(dat){
  #   m <- lm(dat$`Average of RuppiaSeeds_2019Jan` ~ dat$`Average of HSI_2018`,dat);
  #   eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
  #                    list(a = format(unname(coef(m)[1]), digits = 2),
  #                         b = format(unname(coef(m)[2]), digits = 2),
  #                         r2 = format(summary(m)$r.squared, digits = 2)))
  #   as.character(as.expression(eq));
  # }
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[3]))+
    geom_point()+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(paste("Modelled biomass ULVA",yr[y],"(g)"))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[4],y=names(df_valid[[y]])[3]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    ylab(paste("Modelled biomass ULVA",yr[y],"(g)"))+
    xlab(paste("Field algae cover Sep",yr[y],"(%)"))
  
  fig <-  ggarrange(p1,p2, ncol=2,nrow=1)
  print(fig)
  #  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

