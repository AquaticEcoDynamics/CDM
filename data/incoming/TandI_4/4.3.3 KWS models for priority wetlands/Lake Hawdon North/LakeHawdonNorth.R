# Load packages
rm(list=ls())
library(raster)
library(mgcv)
library(ggplot2)
library(lubridate)
library(scales)
library(reshape2)

# Load models and data

## Load abundance model
fit <- readRDS('Best model based on NRMSE.rds')
waterbirds <- readRDS('waterbirds.rds')
scenarios <- readRDS('scenarios.rds')

# Waterbird response models

## Generate predictions from the model and merge with the waterbirds data

# Generate predictions from the model
species.nms <- unique(waterbirds$Species)
pred.df <- expand.grid(list(Species=sort(unique(species.nms)),
                            Area=seq(min(waterbirds$Area[waterbirds$Class=='Response Curve']), 
                                     max(waterbirds$Area[waterbirds$Class=='Response Curve']),                                      length.out = 100)))
predictions <- predict(fit, newdata=pred.df, re.form=NULL, se.fit=T)
pred.df$y <- NA
pred.df$est <- exp(predictions$fit)
pred.df$lcl <- exp(predictions$fit-1.96*predictions$se.fit)
pred.df$ucl <- exp(predictions$fit+1.96*predictions$se.fit)
pred.df$Class <- 'Response Curve'

# Truncate upper confidence intervals to improve visualisation
pred.df$ucl <- ifelse(pred.df$Species=="Common.greenshank" & pred.df$ucl>250,250,pred.df$ucl)
pred.df$ucl <- ifelse(pred.df$Species=="Curlew.sandpiper" & pred.df$ucl>50,50,pred.df$ucl)
pred.df$ucl <- ifelse(pred.df$Species=="Red.capped.plover" & pred.df$ucl>250,250,pred.df$ucl)
pred.df$ucl <- ifelse(pred.df$Species=="Red.necked.avocet" & pred.df$ucl>5,5,pred.df$ucl)
pred.df$ucl <- ifelse(pred.df$Species=="Red.necked.stint" & pred.df$ucl>2000,2000,pred.df$ucl)
pred.df$ucl <- ifelse(pred.df$Species=="Sharp.tailed.sandpiper" & pred.df$ucl>20000,20000,pred.df$ucl)

# Merge with the raw waterbird data and fix species names
df <- rbind(waterbirds, pred.df)
df$Species <- as.character(factor(df$Species))
df$Species <- gsub('\\.',' ',df$Species)
df$Species <- gsub('Red capped','Red-capped',df$Species)
df$Species <- gsub('Red necked','Red-necked',df$Species)
df$Species <- gsub('Sharp tailed','Sharp-tailed',df$Species)


## Plot response curves and save
(p1 <- ggplot(df, aes(Area, y)) + facet_grid(Species~Class, scales='free') + 
    xlab('') + ylab('Abundance') + 
    geom_ribbon(aes(ymin=lcl, ymax=ucl), data=subset(df, !is.na(lcl) & Class=='Response Curve'),
                fill='blue', alpha=0.3) + 
    geom_line(aes(Area, est), data=subset(df, !is.na(lcl) & Class=='Response Curve'), colour='blue', size=1) + 
    geom_point() + 
    theme_bw() +
    theme(text=element_text(family='serif'),strip.background = element_rect(fill=NA)) +
    scale_color_manual(values=c('orangered3','royalblue2')))

dir.create('figures')
pdf('figures/Response curves.pdf', width=6, height=8.2)
print(p1)
dev.off()


# Predicted waterbird responses under different water-mangement scenarios in Lake Hawdon North

## Plot current and target shallow-water scenarios for Lake hawdon North

# melt scenario data into format suitable for plotting
scenarios <- melt(scenarios, id.vars=1, variable.name='Scenario', value.name='Area')

## plot out the scenarios
(p2 <- ggplot(scenarios, aes(Date, Area, group=Scenario, colour=Scenario)) + 
  geom_line() + 
  scale_x_date(labels=date_format("%d %b"),limits = as.Date(c('2021-05-01','2022-05-01'))) +
  xlab('Date') + ylab('Area within 0-10 cm depth range (ha)') + theme_bw() +
    theme(text=element_text(family='serif'),strip.background = element_rect(fill=NA)) +
    scale_color_manual(values=c('orangered3','royalblue2')))
pdf('figures/Shallow-water scenario for LHN.pdf', width=5, height=3)
print(p2)
dev.off()

## Predict bird abundance under these water level scenarios

species.scen <- NULL
for (i in 1:length(species.nms)) {
  myscen <- data.frame(scenarios, Species=species.nms[i])
  species.scen <- rbind(species.scen , myscen)
}
species.scen$Species <- factor(species.scen$Species, levels=levels(waterbirds$Species))
species.scen$est <- predict(fit, newdata=species.scen, type='response')
species.scen$Species <- gsub('\\.',' ',species.scen$Species)
species.scen$Species <- gsub('Red capped','Red-capped',species.scen$Species)
species.scen$Species <- gsub('Red necked','Red-necked',species.scen$Species)
species.scen$Species <- gsub('Sharp tailed','Sharp-tailed',species.scen$Species)
species.scen <- subset(species.scen, Date>=as.Date('2021-10-01') & Date<=as.Date('2022-4-01'))

# add totals for all 6 species
totals <- aggregate(cbind(Area,est) ~ Date + Scenario, species.scen, sum)
totals <- data.frame(totals[,1:3],Species='Total (all 6 species)',totals[,4,drop=F])
species.scen <- rbind(species.scen, totals)

## Plot out bird responses to scenarios
(p3 <- ggplot(species.scen, aes(Date, est, group=Scenario, colour=Scenario)) + 
    geom_line() + facet_wrap(~Species, scales='free', ncol=2) +
    scale_x_date(labels=date_format("%d %b"),limits = as.Date(c('2021-10-01','2022-04-01'))) +
    xlab('Date') + ylab('Predicted Abundance') + theme_bw() +
    theme(text=element_text(family='serif'),strip.background = element_rect(fill=NA)) +
    scale_color_manual(values=c('orangered3','royalblue2')))
pdf('figures/Predictions under LHN scenarios.pdf', width=6, height=8.2)
print(p3)
dev.off()
