library(tidyverse)

header<-read_csv("CSLSalinityinECDec2020.csv",n_max=1,col_names=FALSE)
Sal<-read_csv("CSLSalinityinECDec2020.csv",skip=3,
              col_names=as.character(header),
              col_types=cols(col_date(format="%d/%m/%Y %H:%M"),
                             col_double(),col_double(),col_double(),col_character()))

Sal<-Sal %>% select(-`NA`) %>% 
  gather("Site","EC",-Time) %>% 
  mutate(Value=(3E-06*EC^2 +0.5517*EC)/1000.0, #AWQC conversion to mg/L, to g/L
         par="Salinity")

Q<-read_tsv("BarrageFlows_1963_2020.dat",skip=8)
Q<-Q %>% select(Time=`23011`,contains("0")) %>% select(-X10) %>% 
  mutate(Value=`0`+`0_1`+`0_2`+`0_3`+`0_4`,
         Time=as.Date("1900-01-01")+Time) %>% 
  select(Time,Value) %>% 
  filter(Time>=min(Sal$Time),
         Time<=max(Sal$Time)) %>% 
  mutate(par="Barrage",
         Site="Barrage",
         Value =zoo::rollapplyr(Value, 30, sum, partial = TRUE)/1000.0)

dat<-bind_rows(Sal,Q)
ggplot(dat)+geom_line(aes(Time,Value,colour=Site))+
  facet_wrap(vars(par),ncol=1,scales="free_y")

#500 GL/d looks like about the tresholds from above plot.

#find hard coded dates dates
#view(Q %>% filter(Value>500) %>% mutate(gap = Time - lag(Time, default = Time[1])) %>% filter(gap>100))


trend<-Sal %>% filter(par=="Salinity") %>% 
  mutate(group="0",
         group=if_else(Time>="2001-09-01"&Time<="2008-09-01","1",group), #2008 is end of site data
         group=if_else(Time>="2014-09-01"&Time<="2016-09-01","2",group),
         group=if_else(Time>="2017-09-01"&Time<="2020-09-01","3",group)) %>% 
  group_by(group,Site)

Q<-Q %>% mutate(HighFlow=NA,
                HighFlow=as.numeric(HighFlow),
                HighFlow=if_else(Value>500,50,HighFlow))

#get slopes
slopes<-array(0,3)
for(i in 1:3)
{
  a<-lm(Value~Time,data=trend %>% filter(group==i)) 
  slopes[i]<-a$coefficients[2]*365
}
#


labels<-data.frame(x=c("1998-09-01","2008-01-01","2016-08-01","2018-09-01"),
                   y=c(60,185,115,130),
                   labs=c("Periods with 500 GL barrage flow in 30 days",paste(round(slopes,0),"g/L/yr")))
                        
labels$x<-as.Date(labels$x)

p<-ggplot(trend,aes(Time,Value,colour=Site))+geom_line()+
  geom_smooth(data=trend %>% filter(group>0),aes(group=group),method="lm",se=FALSE,colour="black",lty="dashed")+
  geom_point(data=Q,aes(Time,HighFlow),colour="black",size=3)+
  geom_text(data=labels,aes(x,y,label=labs),colour="black",hjust=0)+
  theme_bw()+xlab(NULL)+ylab("Salinity (g/L)")+theme(legend.position = "top")+
  scale_colour_manual(values=c("#124734",
                               "#38A28F",
                               "#C33B32"))
ggsave("CSLSalinityTrend.png",p,width=16,height=12,units="cm")
