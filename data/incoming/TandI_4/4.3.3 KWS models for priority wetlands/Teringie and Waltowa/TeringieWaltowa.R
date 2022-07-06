# Load packages
rm(list=ls())
library(raster)
library(mgcv)
library(ggplot2)
library(lubridate)
library(scales)
library(reshape2)

# Load models and data

## Load waterbird data
waterbirds <- readRDS('waterbirds.rds')

## Load selected models for each species
fit <- readRDS('Best models based on AIC.rds')

# Plot the waterbird data at each wetland against proportional water coverage
(p1 <- ggplot(waterbirds, aes(PropCoverage, n, colour=Taxa_SpeciesName)) + geom_point() +
  facet_grid(Species~Wetland_Name, scales='free_y') + 
  guides(colour='none') +
  xlab('Proportion of wetland inundated') + ylab('Count') +
  labs(colour='Wetland') + scale_y_continuous(breaks= pretty_breaks()) + 
  theme_bw() + theme(strip.text.y = element_text(face = "italic")))

# Print model summaries
lapply(1:length(fit), function(x) {
  print(paste('*******',names(fit)[x],'*******'))
  print(summary(fit[[x]]))
  print(paste('*****************************'))
})
