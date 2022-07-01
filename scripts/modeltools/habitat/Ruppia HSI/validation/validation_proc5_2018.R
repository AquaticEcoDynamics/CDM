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

#______historical surveys (in UTM)________
Jan07_19 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/MDBA_Coorong_RuppiaDB.xlsx",
                       sheet="2007-19Jan_Ruppia_Raw", range="A1:S20302")
Jan07_19$DateSampled <- as.Date(Jan07_19$DateSampled)
Jan07_19$Year <- droplevels(cut(Jan07_19$DateSampled, breaks = "year"))
Jan07_19$Site <- as.factor(Jan07_19$Site)
Jan07_19$Depth <- as.factor(Jan07_19$Depth)

Jan07_19 <- Jan07_19[which(!is.na(Jan07_19$Easting) & !is.na(Jan07_19$Northing)),] #remove rows without coords

Jan07_19 <- aggregate(cbind(Easting, Northing, RuppiaShootsTotal, RuppiaShootsGreen, RuppiaShootsBrown,
                            RuppiaTurionsTypeII, RuppiaTurionsTypeI, `RuppiaTurionsTypeI&II`, RuppiaSeeds,
                            PercentGrazed, RuppiaUngrazedLength_cm, RuppiaGrazedLength_cm, RuppiaFlowerStalks) 
                      ~Year+Site, data=Jan07_19, FUN=mean, na.action=na.pass,na.rm=TRUE)
Jan07_19 <- st_as_sf(Jan07_19,coords = c("Easting","Northing"))
Jan07_19_yr <- split(Jan07_19, format(as.Date(Jan07_19$Year,"%Y-%m-%d")))

###____
Jul98_18 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/MDBA_Coorong_RuppiaDB.xlsx",
                       sheet="1998-2018July_Transect", range="A1:N8191")
Jul98_18$DateSampled <- as.Date(Jul98_18$DateSampled)
Jul98_18$Year <- droplevels(cut(Jul98_18$DateSampled, breaks = "year"))
Jul98_18$Site <- as.factor(Jul98_18$Site)
Jul98_18$Depth <- as.factor(Jul98_18$Depth)

Jul98_18 <- Jul98_18[which(!is.na(Jul98_18$Easting) & !is.na(Jul98_18$Northing)),] #remove rows without coords

Jul98_18 <- aggregate(cbind(Easting, Northing, RuppiaShootsTotal, RuppiaShootsGreen, RuppiaShootsBrown,
                            RuppiaTurionsTypeII, RuppiaTurionsTypeI, `RuppiaTurionsTypeI&II`, RuppiaSeeds,
                            PercentGrazed, RuppiaUngrazedLength_cm, RuppiaGrazedLength_cm, RuppiaFlowerStalks) 
                      ~Year+Site, data=Jul98_18, FUN=mean, na.action=na.pass,na.rm=TRUE)
Jul98_18 <- st_as_sf(Jul98_18,coords = c("Easting","Northing"))
Jul98_18_yr <- split(Jul98_18, format(as.Date(Jul98_18$Year,"%Y-%m-%d")))

# ###____
# Nov16 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/MDBA_Coorong_RuppiaDB.xlsx",
#                     sheet="2016Nov_Ruppia_Flowerhead", range="A1:J549")
# Nov16$Date <- as.Date(Nov16$Date)
# Nov16$Year <- droplevels(cut(Nov16$Date, breaks = "year"))
# Nov16$Site <- as.factor(Nov16$Site)
# Nov16$`Depth (m)` <- as.factor(Nov16$`Depth (m)`)
# 
# Nov16 <- Nov16[which(!is.na(Nov16$Easting) & !is.na(Nov16$Northing)),] #remove rows without coords
# 
# Nov16 <- aggregate(cbind(Easting, Northing, `# Flowerheads per 1m quadrat`) 
#                    ~Site+Year, data=Nov16, FUN=mean, na.action=na.pass,na.rm=TRUE)
# Nov16 <- st_as_sf(Nov16,coords = c("Easting","Northing"))


#______________process model data_____________________

setwd("D:/output_basecase_hd_ruppia_new/Plotting_Ruppia/eWater2021_basecase_t3_all/Sheets/2018/shp/") #set the folder of all the files to be looped
listshp <- dir(pattern = "*.shp") #creates a list of all the shp files in the directory
nmod <- list() #creates an empty list for all input data
names <- list()

for (i in 1:length(listshp)){
  
  names <- paste0(tools::file_path_sans_ext(listshp[i])) #set output name the same as input file
  nmod[[names]] <- readOGR(listshp[i], stringsAsFactors = F)
  nmod[[names]] <- st_as_sf(nmod[[names]])
  # st_crs(nmod[[names]]) <- st_crs(dat20)
}

poly <- readOGR("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/Coorong_regions_001_R.shp")
poly <- st_as_sf(poly)
poly <- st_transform(poly,32754) #zone54S, datum WGS84
st_crs(poly) <- st_crs(Jan07_19)
#________________________________________________________________________________________

########### validation loop ##############

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

## New sexual HSI Dec area weighted vs field seed count Jan next year 
##__________________________________

yr <- 2018  #model years

for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("_sexual",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]+1),Jan07_19$Year))>0) {
  
  mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
  dat[[y]] <- subset(Jan07_19,format(as.Date(Year), "%Y")==yr[y]+1)
  dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
  dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
  dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
  dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
  
  col <- grep("seed",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
  valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Site),FUN=mean),   #mean field count
                      aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Site),FUN=sum))  #total area for each site i.e. 100 radius circle
  valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells

  valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
  valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
  
  df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
  df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
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
  
  R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs"), digits = 2)
  
  ylab <- paste("Modelled HSI Dec sexual",yr[y])
  xlab <- paste("Field seed count Jan",yr[y]+1)
  
  p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
    geom_point(aes(colour=Descriptio),show.legend = FALSE)+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p2 <- ggplot()+
    geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylab(ylab)+
    xlab(xlab)
  
  valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
  df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
  df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
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
  
  R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs"), digits = 2)
  
  p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
    geom_point(colour="turquoise3")+
    geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
    annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
    #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    theme(legend.title = element_blank()) +
    ylab(ylab)+
    xlab(xlab)
  
  p4 <- ggplot()+
    geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
    theme_bw()+
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_x_discrete(labels=newticks)+
    ylab(ylab)+
    xlab(xlab)
  
  fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
  print(fig)
  ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/validation/seed2019_sexual2018.png", width = 20, height = 20, units = "cm",dpi = 300)
  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}



## New asexual HSI Dec area weighted vs field turion count Jan next year 
##__________________________________

yr <- 2018  #model years

for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_12"))),listshp,value=TRUE) #filter model year
  b <- grep("_asexual",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]+1),Jan07_19$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    dat[[y]] <- subset(Jan07_19,format(as.Date(Year), "%Y")==yr[y]+1)
    dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
    dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
    
    col <- grep("TurionsTypeI.II",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Site),FUN=mean),   #mean field count
                        aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Site),FUN=sum))  #total area for each site i.e. 100 radius circle
    valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
    
    valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
    valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
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
    
    R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs"), digits = 2)
    
    ylab <- paste("Modelled HSI Dec asexual",yr[y])
    xlab <- paste("Field turion count Jan",yr[y]+1)
    
    p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
      geom_point(aes(colour=Descriptio),show.legend = FALSE)+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      ylab(ylab)+
      xlab(xlab)
    
    p2 <- ggplot()+
      geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      scale_x_discrete(labels=newticks)+
      ylab(ylab)+
      xlab(xlab)
    
    valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
    df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
    df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
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
    
    R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs"), digits = 2)
    
    p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
      geom_point(colour="turquoise3")+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      ylab(ylab)+
      xlab(xlab)
    
    p4 <- ggplot()+
      geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      scale_x_discrete(labels=newticks)+
      ylab(ylab)+
      xlab(xlab)
    
    fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
    print(fig)
    ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/validation/turion2019_asexual2018.png", width = 20, height = 20, units = "cm",dpi = 300)
  } else {print(paste0(as.character(yr[y])," HSI and/or ",as.character(yr[y]+1)," field data do not exist"))}
}


## germination_sprouting_adult HSI Jun area weighted vs field shoot count July
##__________________________________

yr <- 2018  #model years

for (y in 1:length(yr)){
  a <- grep(as.character(gsub(" ","",paste(yr[y],"_6"))),listshp,value=TRUE) #filter model year
  b <- grep("germ_spr_adt",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]),Jul98_18$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    dat[[y]] <- subset(Jul98_18,format(as.Date(Year), "%Y")==yr[y])
    dat_buff[[y]] <- st_buffer(dat[[y]],bufsize) #create 100m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    dat_mod[[y]]$area <- st_area(dat_mod[[y]])  #calculate each cell area
    dat_mod[[y]]$HSI_area <- dat_mod[[y]]$area * dat_mod[[y]]$HSI   # calculate HSI x area
    
    col <- grep("shootsTotal",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- merge(aggregate(dat_mod[[y]][,col],by=list(dat_mod[[y]]$Site),FUN=mean),   #mean field count
                        aggregate(cbind(dat_mod[[y]]$area,dat_mod[[y]]$HSI_area),by=list(dat_mod[[y]]$Site),FUN=sum))  #total area for each site i.e. 100 radius circle
    valid[[y]]$HSI_wght <- valid[[y]]$V2/valid[[y]]$V1   #weighted average HSI at each site = sum of weighted HSI x area for each cell divided by total area of all cells
    
    valid_buff[[y]] <- st_buffer(valid[[y]],bufsize)
    valid[[y]] <- st_intersection(valid_buff[[y]],poly) 
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    df_valid[[y]] <- na.omit(df_valid[[y]]) #remove NA rows
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
    
    R <- format(cor(df_valid[[y]][5],df_valid[[y]][2],use="complete.obs"), digits = 2)
    
    ylab <- paste("Modelled HSI germ, spr & adt Jun",yr[y])
    xlab <- paste("Field shoot count Jul",yr[y])
    
    p1 <- ggplot(valid[[y]],aes_string(x=names(valid[[y]])[2],y=names(valid[[y]])[5]))+
      geom_point(aes(colour=Descriptio),show.legend = FALSE)+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      #geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      ylab(ylab)+
      xlab(xlab)
    
    p2 <- ggplot()+
      geom_boxplot(data = df_valid[[y]],aes_string(x=names(df_valid[[y]])[7],y=names(df_valid[[y]])[5]))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      scale_x_discrete(labels=newticks)+
      ylab(ylab)+
      xlab(xlab)
    
    valid_S[[y]] <- subset (valid[[y]],Descriptio == "Coorong South Lagoon" )
    df_valid_S[[y]] <- st_drop_geometry(valid_S[[y]]) #remove the geometry for correlation analysis
    df_valid_S[[y]] <- na.omit(df_valid_S[[y]]) #remove NA rows
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
    
    R <- format(cor(df_valid_S[[y]][5],df_valid_S[[y]][2],use="complete.obs"), digits = 2)
    
    p3 <- ggplot(valid_S[[y]],aes_string(x=names(valid_S[[y]])[2],y=names(valid_S[[y]])[5]))+
      geom_point(colour="turquoise3")+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      #geom_text(aes(label=valid_S[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      ylab(ylab)+
      xlab(xlab)
    
    p4 <- ggplot()+
      geom_boxplot(data = df_valid_S[[y]],aes_string(x=names(df_valid_S[[y]])[7],y=names(df_valid_S[[y]])[5]))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      scale_x_discrete(labels=newticks)+
      ylab(ylab)+
      xlab(xlab)
    
    fig <-  ggarrange(p1,p2,p3,p4, ncol=2,nrow=2,align = "hv")
    print(fig)
    ggsave("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/R plots/validation/shoot2018_germspradt2018.png", width = 20, height = 20, units = "cm",dpi = 300)
  } else {print(paste0(as.character(yr[y])," HSI and/or ",as.character(yr[y])," field data do not exist"))}
}
