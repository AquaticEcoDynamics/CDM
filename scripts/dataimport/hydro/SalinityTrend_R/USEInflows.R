library(tidyverse)

files<-list.files("../CIIP/","USED*",full.names =TRUE)

dat<-NULL

for(f in files)
{
  name<-strsplit(f,"_")[[1]]
  name<-name[length(name)]
  name<-substr(name,1,nchar(name)-4)
  X<-read_tsv(f,skip=8,col_names = FALSE)
  X<-X %>% select(Date=X1,Q=X2) %>% 
    mutate(Date=as.Date("1900-01-01")+Date-1,
           scenario=name) %>% 
    filter(Date>="2013-05-07" & Date<="2016-01-28")
  dat<-dat %>% bind_rows(X)
}


p<-ggplot(dat)+geom_line(aes(Date,Q,colour=scenario))+
  scale_colour_manual(values=c("#124734",
                             "#38A28F",
                             "#C33B32"))+
  theme_bw()+
  theme(legend.position = "top")+ylab("Flow (ML/d)")

ggsave("SEFAFlows.png",p,width = 15,height=12,units="cm")