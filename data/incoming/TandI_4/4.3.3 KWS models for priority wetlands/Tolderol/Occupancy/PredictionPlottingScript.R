#### Plotting script to compare model predictions for given environment characteristics to long-term averages ####



# Set the path to the folder that the model objects are in and plots will be saved to  
setwd("S:/Science/BiologicalSciences/Ecol_and_Env_Sci/HCHB_waterbirds/Priority wetlands/AnalysisFiles")

setwd("S:/Science/BiologicalSciences/Ecol_and_Env_Sci/HCHB_waterbirds/Priority wetlands/AnalysisFiles/TolderolAbundance/CompleteCases/Best Models")

# Do you require Abundance predictions or Presence/Absence predictions?
AbundPres<-"Abund" #One of "Abund" or "PresAbs"

# Specify any environmental variable values that you require predictions for by updating values for one or more variables in the following list. Any variables that are not supplied will be held at their long-term average.
VarList<-list(
  AvgOfEC_us_cm=NA,
  AvgOfTurbidity_NTU=NA,
  PropCoverage=NA,
  Area0to5=NA,
  AreaGreater20=NA,
  Area =NA,
  Month = NA,
  PondNumber = NA,
  Year = NA)

# Specify which species you require a prediction for. Multiple species can be supplied
Species<-c("Australian Pelican", "Black Swan", "Common Greenshank", "Curlew Sandpiper", "Red-capped Plover", "Red-necked Stint", "Sharp-tailed Sandpiper")

# Specify whether plots are to be saved (TRUE) or just plotted on screen (FALSE)
SavePlots<-TRUE

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#### No user input required ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#The user does not need to modify any of the code in the below lines of code. When run, they will produce a plot based on the parameters provided above

#### Read in the model objects and establish the long-term mean environment values for plotting against ####
if(AbundPres == "Abund"){
 ModList<-readRDS("Best modelas based on MAE_full data set.rds") 
 
 MeanDF<-data.frame(AvgOfEC_us_cm = 8.642643712, AvgOfTurbidity_NTU = 84.81395974, PropCoverage = 0.124854622, Area0to5 = 5894.495413, AreaGreater20 = 2156.37105, Area = 96213.86624, Month = 2, PondNumber = 7, Year = 2019)
 
 
 sdDF<-data.frame(AvgOfEC_us_cm = 1.429903823,AvgOfTurbidity_NTU = 106.3514999,PropCoverage = 0.146432474,Area0to5 = 6714.035731,AreaGreater20 = 2798.908804,Area = 38814.40619, Month = NA, PondNumber = NA, Year = NA)
 
 
}else if(AbundPres == "PresAbs"){
  ModList<-readRDS("BestModelsForTolderolPresAbsKWS.rds")
  
  MeanDF<-data.frame(AvgOfEC_us_cm = 8.61812645417861, AvgOfTurbidity_NTU = 83.1721580345286, PropCoverage = 0.120721013033375, Area0to5 = 6080.7285546416, Area5to20 = 4634.66509988249, AreaGreater20 = 2096.00470035253, Area = 104308.204347143, Month = 2, PondNumber = 7, Year = 2019)
  
  
  sdDF<-data.frame(AvgOfEC_us_cm = 1.46005374448701,AvgOfTurbidity_NTU = 109.483467106874,PropCoverage = 0.137702327830178,Area0to5 = 6968.36076160511,Area5to20 = 8024.31506181302,AreaGreater20 = 2635.05919477682,Area = 47935.8143564543, Month = NA, PondNumber = NA, Year = NA)
  
}else{
  stop("AbundPres has been set incorrectly. Must be one of 'Abund' or 'PresAbs'. Check spelling and case carefully.")
}


#### Predict to the user-defined input values ####
#Set up the data to predict to
PredictDat<-MeanDF #Use the long-term average dataframe as the template
for(i in seq_along(VarList)){
  if(is.na(VarList[[i]])){
    next()
  }
  PredictDat[1,names(VarList)[i]]<-VarList[[i]]
  
}

#Convert it to scaled units as used in the model
PredictDat[1,]<-(PredictDat-MeanDF)/sdDF



#Add in the scaled mean values, because scaling will convert long-term means to zero, simply add another row and populate with zeros
PredictDat<-PredictDat[c(1,1),]
PredictDat[1,]<-0
PredictDat[, c("Month", "PondNumber", "Year")]<-MeanDF[,c("Month", "PondNumber", "Year")]

VarsBeingPredicted<-which(!sapply(VarList, is.na))
SubTitleVals<-paste( paste0(names(VarList)[VarsBeingPredicted]," = ", do.call(what = "c", VarList[VarsBeingPredicted])), collapse = "_")

# Subset to the appropriate model(s) and plot
for(i in Species){
  ActiveMod<-ModList[[which(names(ModList) == i)]]
  if(any(!names(VarList)[VarsBeingPredicted] %in% names(ActiveMod$var.summary))){
    warning("One or more of the variables being predicted to are not present in the best model for ", i, ". A plot is being generated even though one or more of the variable(s) being supplied may not influence the model output")
  }
  
  
  Pred<-predict(object = ActiveMod, newdata = PredictDat, type='response', allow.new.levels=TRUE, se.fit = TRUE)
  Fit<-Pred$fit
  PredSE<-Pred$se.fit
  
  LCI<-Fit-PredSE
  LCI<-ifelse(LCI<0, 0, LCI)
  UCI<-Fit+PredSE
  if(AbundPres == "PresAbs"){
    UCI<-ifelse(UCI>1, 1, UCI)
  }
  PlotRange<-range(c(LCI, UCI))
  
  if(SavePlots){
    jpeg(filename = paste0(i, SubTitleVals, ".jpg"))
    plot(x = 1:2, y = Fit, xaxt = 'n',xlim = c(0.5,2.5), ylim = PlotRange, ylab = ifelse(AbundPres == "Abund", "Abundance", "Probability of occurrence"), xlab = "", type = "n")
    arrows(x0 = c(1,2),y0 = LCI, x1 = c(1,2), y1 = UCI, length = 0.1, angle = 90, code = 3)
    segments(x0 = 0.8,
             x1 = 1.2,
             y0 = Fit[1],
             y1 = Fit[1],
             lwd = 2,
             col = "red")
    
    
    segments(x0 = 1.8,
             x1 = 2.2,
             y0 = Fit[2],
             y1 = Fit[2],
             lwd = 2,
             col = "navyblue")
    
    axis(side = 1, at = 1:2, labels = c("Long-term mean", "Predicted"))
    mtext(side=3, line=3, at=1.5, adj=0.5, cex=1, font = 2, i)
    mtext(side=3, line=2, at=1.5, adj=0.5, cex=0.7, paste0("Predicting to: ",SubTitleVals))
    dev.off()  
    
  }else{
  plot(x = 1:2, y = Fit, xaxt = 'n',xlim = c(0.5,2.5), ylim = PlotRange, ylab = ifelse(AbundPres == "Abund", "Abundance", "Probability of occurrence"), xlab = "", type = "n")
  arrows(x0 = c(1,2),y0 = LCI, x1 = c(1,2), y1 = UCI, length = 0.1, angle = 90, code = 3)
  segments(x0 = 0.8,
           x1 = 1.2,
           y0 = Fit[1],
           y1 = Fit[1],
           lwd = 2,
           col = "red")
  
  
  segments(x0 = 1.8,
           x1 = 2.2,
           y0 = Fit[2],
           y1 = Fit[2],
           lwd = 2,
           col = "navyblue")
  
  axis(side = 1, at = 1:2, labels = c("Long-term mean", "Predicted"))
  mtext(side=3, line=3, at=1.5, adj=0.5, cex=1, font = 2, i)
  mtext(side=3, line=2, at=1.5, adj=0.5, cex=0.7, paste0("Predicting to: ",SubTitleVals))
  }  
}

