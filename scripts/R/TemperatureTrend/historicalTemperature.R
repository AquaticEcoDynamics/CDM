library(tidyverse)
library(lubridate)

X<-read_csv("CoorongWaterTemp.csv",skip=3,col_types = "cddc")
X<-X %>% select(-`Sites:`) %>% 
  set_names(c("Date","Parnka","WoodsWell")) %>% 
  mutate(Date=as.Date(Date,"%d/%m/%Y"),
         DoY=yday(Date),
         Year=year(Date)) %>% 
  group_by(DoY)  

percentiles=c(0.005,0.025,0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.975,0.995)

dat<-X %>% select(-WoodsWell,value=Parnka) %>% 
  group_by(DoY) %>% 
  summarise(value = quantile(value, percentiles,na.rm=TRUE), q = paste0("p",percentiles*100,"th")) %>% 
  spread(q,value) %>% 
  ungroup() %>% 
  mutate(Date=DoY+as.Date("2020-01-01")-1)

datlines<-dat %>% select(Date,median=p50th) %>% 
  left_join(X %>% ungroup() %>% select(Date,y2020=Parnka),by="Date") %>% 
  gather("period","value",-Date) %>% 
  mutate(period=gsub("y","",period))

datribbons<-full_join(dat %>% select(Date,p99th=p0.5th,p95th=p2.5th) %>% gather("range","ymin",-Date),
                     dat %>% select(Date,p99th=p99.5th,p95th=p97.5th) %>% gather("range","ymax",-Date),by=c("Date","range")) %>% 
  mutate(range=factor(range,levels=c("p99th","p95th")))

library(RColorBrewer)
cols<-brewer.pal(3,"Blues")

p<-ggplot(dat)+
  geom_ribbon(data=datribbons,aes(Date,ymin=ymin,ymax=ymax,fill=range))+
  geom_line(data=datlines,aes(Date,value,colour=period))+
  scale_x_date(limits=c(as.Date("2020-07-01"),as.Date("2020-12-31")),date_breaks="1 month",date_labels="%b")+
  ylim(c(7,27))+
  scale_colour_manual(values=c("black",cols[3]))+ylab(expression("Temperature " ( degree~C)))+
  scale_fill_brewer(palette = "Blues",direction=1,labels=c("99th percentile","95th percentile"))+
  theme_bw()+ggtitle("Parnka Point")
ggsave("ParnkaPointTemp.png",p,width=15,height=10,units="cm")

#####################################################



dat<-X %>% select(value=WoodsWell,-Parnka) %>% 
  group_by(DoY) %>% 
  summarise(value = quantile(value, percentiles,na.rm=TRUE), q = paste0("p",percentiles*100,"th")) %>% 
  spread(q,value) %>% 
  ungroup() %>% 
  mutate(Date=DoY+as.Date("2020-01-01")-1)

datlines<-dat %>% select(Date,median=p50th) %>% 
  left_join(X %>% ungroup() %>% select(Date,y2020=WoodsWell),by="Date") %>% 
  gather("period","value",-Date) %>% 
  mutate(period=gsub("y","",period))

datribbons<-full_join(dat %>% select(Date,p99th=p0.5th,p95th=p2.5th) %>% gather("range","ymin",-Date),
                      dat %>% select(Date,p99th=p99.5th,p95th=p97.5th) %>% gather("range","ymax",-Date),by=c("Date","range")) %>% 
  mutate(range=factor(range,levels=c("p99th","p95th")))

library(RColorBrewer)
cols<-brewer.pal(3,"Blues")

p<-ggplot(dat)+
  geom_ribbon(data=datribbons,aes(Date,ymin=ymin,ymax=ymax,fill=range))+
  geom_line(data=datlines,aes(Date,value,colour=period))+
  scale_x_date(limits=c(as.Date("2020-07-01"),as.Date("2020-12-31")),date_breaks="1 month",date_labels="%b")+
  ylim(c(7,27))+
  scale_colour_manual(values=c("black",cols[3]))+ylab(expression("Temperature " ( degree~C)))+
  scale_fill_brewer(palette = "Blues",direction=1,labels=c("99th percentile","95th percentile"))+
  theme_bw()+ggtitle("Woods Well")
ggsave("WoodsWellTemp.png",p,width=15,height=10,units="cm")