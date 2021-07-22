library(tidyverse)
library(readxl)

file<-"HCHB Field measurement spreadsheet 2020.xlsx"
sheets<-excel_sheets(file)

X<-NULL
for(sheet in sheets)
{
Date<-read_excel(file,sheet = sheet,range=cell_cols("A"))
PAR<-read_excel(file,sheet = sheet,range=cell_cols("AH:AO"))

if(nrow(PAR)>1)
{

  names(Date)<-"Date"
  names(PAR)<-seq(0,by=0.5,length.out = ncol(PAR))
  
  dat<-Date %>% slice(-1) %>% 
    bind_cols(PAR %>% slice(-1)) %>% 
    filter(!is.na(`0`)) %>% 
    gather("Depth","SI",-Date) %>%
    mutate(SI=as.numeric(SI),
           Depth=as.numeric(Depth),
           site=sheet) %>% 
    group_by(Date) %>% 
    mutate(SI=SI/max(SI,na.rm = TRUE)) %>% 
    filter(!is.na(SI))
  
  X<-X %>% bind_rows(dat)
}
}

X<-X %>% mutate(site=factor(site,levels=sheets))

p<-ggplot(X)+geom_line(aes(SI,Depth,colour=factor(Date)))+
  scale_y_reverse()+scale_x_reverse(limits=c(1,0))+
  facet_wrap(vars(site),ncol=3)+geom_vline(xintercept = 0.24)+
  xlab("Percent surface irradiance (%)")+ylab("Depth (m)")

ggsave("PercentSurfaceIrradiance.png",p,width=18,height=18,units="cm")
