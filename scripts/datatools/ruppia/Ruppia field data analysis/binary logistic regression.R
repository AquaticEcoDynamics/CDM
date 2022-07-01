library(readxl)
library(ggplot2)

dat <- read_excel("C:/Users/00101765/AED Dropbox/AED_Coorong_db/7_hchb/Ruppia/Ruppia data/Ruppia 2016 data.xlsx",
                  sheet="Sheet1")
dat<- dat[1:21,]

logistic<- glm(Ruppia_YN ~ Algae_rank, data=dat, family="binomial")
summary(logistic)


ggplot(dat,aes(x=Algae_rank, y=Ruppia_YN))+
  geom_point()+
  stat_smooth(method="glm",se=F,method.args=list(family=binomial))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())
