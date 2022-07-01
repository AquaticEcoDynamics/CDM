library(readxl)
library(rgdal)
library(ggplot2)
library(sf)
library(viridis)
library(ggnewscale)
library(ggsn)

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
Nov16 <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/MDBA_Coorong_RuppiaDB.xlsx",
                       sheet="2016Nov_Ruppia_Flowerhead", range="A1:J549")
Nov16$Date <- as.Date(Nov16$Date)
Nov16$Year <- droplevels(cut(Nov16$Date, breaks = "year"))
Nov16$Site <- as.factor(Nov16$Site)
Nov16$`Depth (m)` <- as.factor(Nov16$`Depth (m)`)

Nov16 <- Nov16[which(!is.na(Nov16$Easting) & !is.na(Nov16$Northing)),] #remove rows without coords

Nov16 <- aggregate(cbind(Easting, Northing, `# Flowerheads per 1m quadrat`) 
                      ~Site+Year, data=Nov16, FUN=mean, na.action=na.pass,na.rm=TRUE)
Nov16 <- st_as_sf(Nov16,coords = c("Easting","Northing"))

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


#__process model data

setwd("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/GIS/HSI") #set the folder of all the files to be looped  
listshp <- dir(pattern = "*.shp") #creates a list of all the shp files in the directory
nmod <- list() #creates an empty list for all input data
names <- list()

for (i in 1:length(listshp)){
  #  for (i in 16:17){
  names <- paste0(tools::file_path_sans_ext(listshp[i])) #set output name the same as input file
  nmod[[names]] <- readOGR(listshp[i], stringsAsFactors = F)
  nmod[[names]] <- st_as_sf(nmod[[names]])
  #st_crs(nmod[[names]]) <- st_crs(Jan07_19)
  # assign(names,nmod[[i]])
}



##############___________________loop trial_________________######################

## flower HSI vs field seed count
##__________________________________
yr <- 2018:2019  #model years

mod <- list()
dat <- list()
dat_buff <- list()
dat_mod <- list()
valid <- list()
df_valid <-list()

for (y in 1:length(yr)){
  a <- grep(yr[y],listshp,value=TRUE) #filter model year
  b <- grep("flower",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]+1),Jan07_19$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    
    dat[[y]] <- subset(Jan07_19,format(as.Date(Year), "%Y")==yr[y]+1)
    dat_buff[[y]] <- st_buffer(dat[[y]],600) #create 600m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    
    col <- grep("seed",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- aggregate(cbind(dat_mod[[y]][,col],dat_mod[[y]]$HSI),by=list(dat_mod[[y]]$Site),FUN=mean)
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    R <- format(cor(df_valid[[y]][3],df_valid[[y]][2]), digits = 2)
    #validation scatter plot
    #r <- cor(valid[[y]][3],valid[[y]][2])
    # lm_eqn <- function(dat){
    #   m <- lm(dat$`Average of RuppiaSeeds_2019Jan` ~ dat$`Average of HSI_2018`,dat);
    #   eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
    #                    list(a = format(unname(coef(m)[1]), digits = 2),
    #                         b = format(unname(coef(m)[2]), digits = 2),
    #                         r2 = format(summary(m)$r.squared, digits = 2)))
    #   as.character(as.expression(eq));
    # }
    
    plot <- ggplot(valid[[y]],aes_string(y=names(valid[[y]])[2],x=names(valid[[y]])[3]))+
      geom_point()+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      xlab(paste("Mean HSI flowering ", yr[y]))+
      ylab(paste("Field seed count Jan ", yr[y]+1))
    print(plot)
    
  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y]+1)," field data do not exist (seed)"))}
}

#check map
ggplot()+
  geom_sf(data=mod[[y]],aes(fill=HSI),colour = NA)+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank()) +
  xlab("")+
  ylab("")+
  scale_fill_viridis(limits=c(0,1))+
  geom_sf(data=dat[[y]])+
  geom_sf_text(data=dat[[y]], aes(label=dat[[y]]$Site),hjust=0.5, vjust=-0.5, size=3)+
  coord_sf(datum=st_crs(dat[[y]])) 


## turion formation HSI vs field turion count
##_________________________________
yr <- 2018:2019  #model years

mod <- list()
dat <- list()
dat_buff <- list()
dat_mod <- list()
valid <- list()
df_valid <- list()

for (y in 1:length(yr)){
  a <- grep(yr[y],listshp,value=TRUE) #filter model year
  b <- grep("turion",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]+1),Jan07_19$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    
    dat[[y]] <- subset(Jan07_19,format(as.Date(Year), "%Y")==yr[y]+1)
    dat_buff[[y]] <- st_buffer(dat[[y]],600) #create 600m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    
    col <- grep("TurionsTypeI.II",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- aggregate(cbind(dat_mod[[y]][,col],dat_mod[[y]]$HSI),by=list(dat_mod[[y]]$Site),FUN=mean)
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    R <- format(cor(df_valid[[y]][3],df_valid[[y]][2]), digits = 2)
    
    
    #validation scatter plot
    plot <- ggplot(valid[[y]],aes_string(y=names(valid[[y]])[2],x=names(valid[[y]])[3]))+
      geom_point()+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      xlab(paste("Mean HSI turion formation ", yr[y]))+
      ylab(paste("Field turion count Jan ", yr[y]+1))
    print(plot)
    
  } else {print(paste0(as.character(yr[y])," HSI (turion) and/or ",as.character(yr[y]+1)," field data do not exist (turion)"))}
}


## combined HSI vs field shoot count
##_________________________________
yr <- 2016:2018  #model years

mod <- list()
dat <- list()
dat_buff <- list()
dat_mod <- list()
valid <- list()
df_valid <- list()

for (y in 1:length(yr)){
  a <- grep(yr[y],listshp,value=TRUE) #filter model year
  b <- grep("combined",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]+1),Jan07_19$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    
    dat[[y]] <- subset(Jan07_19,format(as.Date(Year), "%Y")==yr[y]+1)
    dat_buff[[y]] <- st_buffer(dat[[y]],600) #create 600m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    
    col <- grep("ShootsTotal",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- aggregate(cbind(dat_mod[[y]][,col],dat_mod[[y]]$HSI),by=list(dat_mod[[y]]$Site),FUN=mean)
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    R <- format(cor(df_valid[[y]][3],df_valid[[y]][2]), digits = 2)
    
    
    #validation scatter plot
    plot <- ggplot(valid[[y]],aes_string(y=names(valid[[y]])[2],x=names(valid[[y]])[3]))+
      geom_point()+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      xlab(paste("Mean HSI combined ", yr[y]))+
      ylab(paste("Field shoot count Jan ", yr[y]+1))
    print(plot)
    
  } else {print(paste0(as.character(yr[y])," HSI (combined) and/or ",as.character(yr[y]+1)," field data do not exist (shoot)"))}
}



## flowering HSI vs field flower count (2016 only)
##_________________________________
yr <- 2016  #model years

mod <- list()
dat <- list()
dat_buff <- list()
dat_mod <- list()
valid <- list()
df_valid <- list()

for (y in 1:length(yr)){
  a <- grep(yr[y],listshp,value=TRUE) #filter model year
  b <- grep("flower",a,value=TRUE)  #filter model life stage
  
  if (length(b)>0 & length(grep(as.character(yr[y]),Nov16$Year))>0) {
    
    mod[[y]] <- nmod[[paste0(tools::file_path_sans_ext(b))]]
    
    dat[[y]] <- subset(Nov16,format(as.Date(Year), "%Y")==yr[y])
    dat_buff[[y]] <- st_buffer(dat[[y]],600) #create 600m buffer around sites
    dat_mod[[y]] <- st_intersection(dat_buff[[y]],mod[[y]])  #intersect with HSI map
    
    col <- grep("Flower",colnames(dat_mod[[y]]),ignore.case = TRUE)  #filter field data life stage
    valid[[y]] <- aggregate(cbind(dat_mod[[y]][,col],dat_mod[[y]]$HSI),by=list(dat_mod[[y]]$Site),FUN=mean)
    
    df_valid[[y]] <- st_drop_geometry(valid[[y]]) #remove the geometry for correlation analysis
    R <- format(cor(df_valid[[y]][3],df_valid[[y]][2]), digits = 2)
    
    
    #validation scatter plot
    plot <- ggplot(valid[[y]],aes_string(y=names(valid[[y]])[2],x=names(valid[[y]])[3]))+
      geom_point()+
      geom_smooth(method="lm",se = FALSE,show.legend = FALSE, colour="grey30")+
      annotate(geom = "text", label= paste0("R = ",R), x = -Inf, y = Inf, hjust = -0.5, vjust = 1, colour="grey30")+
      geom_text(aes(label=valid[[y]]$Group.1),hjust=0.5, vjust=-0.5, size=3)+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank()) +
      theme(legend.title = element_blank()) +
      xlab(paste("Mean HSI flowering ", yr[y]))+
      ylab(paste("Field flower count Nov ", yr[y]))
    print(plot)
    
  } else {print(paste0(as.character(yr[y])," HSI (flower) and/or ",as.character(yr[y])," field data do not exist (flower)"))}
}


