library(tidyverse)
library(readxl)
library(lubridate)

X<-read_excel("C:\\Users\\a1062814\\Box\\Coorong Project - Team share folder\\Task 1 - Literature review and data collation\\Data to modellers 5 June 2020\\Water quality data collation\\Coorong Data 1995_2020_Final.xlsx",
              sheet = "Collated_Data")

order<-X %>% select(Sampling_point,Distance_Murray_Mouth) %>% 
  distinct(Sampling_point,.keep_all = TRUE) %>% 
  mutate(Distance_Murray_Mouth=if_else(Sampling_point=="Murray Mouth",0,Distance_Murray_Mouth)) %>% 
  arrange(desc(Distance_Murray_Mouth))

X<-X %>% select(-"Easting",	-"Northing",-"Distance_Murray_Mouth") %>% 
  gather("parameter","value",-Sampling_point,-Date) %>% 
  mutate(Sampling_point=factor(Sampling_point,levels=order$Sampling_point))

xrange<-range(X$Date)

for(par in unique(X$parameter))
{
  dat<-X %>% filter(parameter == par) %>% filter(!is.na(value))
  if(nrow(dat)<1) next
  
  p<-ggplot(dat)+
    geom_point(aes(Date,Sampling_point,fill=value),pch=21)+
    labs(y=NULL,x=NULL,title=gsub("_"," ",par))+
    scale_fill_gradientn(colours = hcl.colors(20))+
    xlim(xrange)
  
  ggsave(paste0("Plots/",gsub("%","pc",par),".png"),p,width=15,height=12,units="cm")
}

summary<-NULL
for(y in 1998:2019)
{
  dat<-X %>% filter(year(Date)==y & !is.na(value)) %>% select(-Date,-value) %>% distinct()
  temp<-tibble(year=y,
               Nparameters=length(unique(dat$parameter)),
               Nsites=length(unique(dat$Sampling_point)),
               parameters=paste(unique(dat$parameter),collapse="."),
               sites=paste(unique(dat$Sampling_point),collapse="."))
  summary<-summary %>% bind_rows(temp)
}

write_csv(summary,"Summary.csv")
p<-ggplot(summary %>% gather("data","count",-year))+geom_line(aes(year,count,colour=data))  
ggsave(paste0("Plots/summary.png"),p,width=15,height=12,units="cm")
