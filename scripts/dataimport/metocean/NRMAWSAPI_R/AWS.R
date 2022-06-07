library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)

#Get all parameters at a site between start date and end date
NRMAWSData<-function(siteName,startDate,endDate)
{



  
email<-"Matt.Gibbs@sa.gov.au"
pw<-"3ijOGslFtK"

X<-list()
X[["email"]]<-email
X[["password"]]<-pw

url<-"https://api.awsnetwork.com.au/v3/auth/login"
X<-toJSON(X,auto_unbox = TRUE)
A<-POST(url,body=X,content_type_json())

token<-A[[3]]$`x-token`
url<-"https://api.awsnetwork.com.au/v3/sensor-groups"
A<-GET(url,add_headers(Authorization=paste("Bearer",token)))

stations<-fromJSON(rawToChar(A[[6]]))

stations<-tibble(stations$data)

id<-stations %>% filter(stationName==siteName & name =="15 minute data") %>% pull(id)

url<-paste0("https://api.awsnetwork.com.au/v3/sensor-groups/",id,"/sensors")
A<-GET(url,add_headers(Authorization=paste("Bearer",token)))
sensors<-fromJSON(rawToChar(A[[6]]))

#get actual data
data<-NULL
for(sensorid in sensors$data$id)
{
  url<-paste0("https://api.awsnetwork.com.au/v3/sensors/",sensorid,
              "/readings?start=",startDate,
              "&end=",endDate,
              "&perPage=1000000&page=1")
  A<-GET(url,add_headers(Authorization=paste("Bearer",token)))
  data<-data %>% bind_rows(fromJSON(rawToChar(A[[6]]))$data)
}

data<-data %>% select(-sensorTypeId,-timezone) %>% 
  unite("name",c(name,type,unit)) %>% 
  mutate(time=as.POSIXct(time,format="%Y-%m-%dT%H:%M:%OS"),
         value=as.numeric(value))%>% 
  spread(name,value) 

  return(data)
}

NRMAWSStationNames<-function()
{
  
  email<-"Matt.Gibbs@sa.gov.au"
  pw<-"3ijOGslFtK"
  
  X<-list()
  X[["email"]]<-email
  X[["password"]]<-pw
  
  url<-"https://api.awsnetwork.com.au/v3/auth/login"
  X<-toJSON(X,auto_unbox = TRUE)
  A<-POST(url,body=X,content_type_json())
  
  token<-A[[3]]$`x-token`
  url<-"https://api.awsnetwork.com.au/v3/sensor-groups"
  A<-GET(url,add_headers(Authorization=paste("Bearer",token)))
  
  stations<-fromJSON(rawToChar(A[[6]]))
  
  stations<-tibble(stations$data)
  stations<-stations %>% filter(name =="15 minute data") %>% pull(stationName)
  return(stations)
}

siteName<-"Narrung" #can use NRMStationNames() to see what sites are available with this login



theyear<-"2022"
startDate<-paste0(theyear,"-01-01")
endDate<-Sys.Date()
#endDate<-paste0(theyear,"-12-31")

data<-NRMAWSData(siteName,startDate,endDate)
write.csv(data,paste0(siteName,"_",theyear,".csv"),row.names = FALSE)

library(ggplot2)
ggplot(data)+geom_line(aes(time,`Wind Speed_average_km/h`))

