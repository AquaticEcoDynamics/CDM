
# This R script reads the final waterbird abundance models for the Tolderol Game Reserve presented in the report 4.3.1 
# of the Healthy Coorong, Healthy Basin Program. The script also generates and saves model outputs as response curve plots. 
# For each key waterbird species (i.e. Australian Pelican, Black Swan, Common Greenshank, Curlew Sandpiper, 
# Red-capped Plover, Red-necked Stint and Sharp-tailed Sandpiper), negative binomial models combining different variables
# describing the habitat of each pond were fitted. The best model was selected based on the lowest Mean Absolute Error (MAE)
# across cross-validation folds. Please refer to the 4.3.1 report for more details about the methods and analysis of this dataset. 


## ----Set up working directory------------------------------------------------------------------------------------------

OutDir <- "S:/Priority wetlands/AnalysisFiles/TolderolAbundance/CompleteCases/Best Models/" # Specify directory where .rds and .csv files used in this script are

setwd(OutDir)

## ----Load packages----------------------------------------------------------------------

# If any of these packages are not installed, use install.packages("package name") before uploading them

library(mgcv) # To run gam models
library(data.table)
library(tidyverse) # it contains several packages (eg dplyr, ggplot2) - for data handling and plotting


## ----Load abundance models--------------------------------------------------------------------------

ab_m <- readRDS("Best models based on MAE.rds") # List with models for each species

# *ab_m* is a list with 7 elements, where each element is the best model to predict abundance of a key waterbird species.
# Species are in alphabetical order by their common name, i.e. Australian Pelican, Black Swan, Common Greenshank, 
# Curlew Sandpiper, Red-capped Plover, Red-necked Stint and Sharp-tailed Sandpiper, hence first item of the list is the 
# model for Australian Pelican, second item is the model for Black Swan and so on. 

# Each item of the list can be extracted with ab_m[[element_number]] or ab_m$`Species_common_name`. See example below for Australian Pelican. 

# ab_m[[element_number]]
ab_m[[1]]

# ab_m$`Species_common_name`
ab_m$`Australian Pelican`



## ----Model summaries---------------------------------------------------------------------------------------------

# Australian Pelican
summary(ab_m[[1]])

# Black Swan
summary(ab_m[[2]])

# Common Greenshank
summary(ab_m[[3]])

# Curlew Sandpiper
summary(ab_m[[4]])

# Red-capped Plover
summary(ab_m[[5]])

# Red-necked Stint
summary(ab_m[[6]])

# Sharp-tailed Sandpiper
summary(ab_m[[7]])

# Alternatively, summaries from all models can be obtained with:
# **lapply(ab_m, FUN =  summary)**


## -----Response plots----------------------------------------------------------------------------------------------

# This part of the script creates the response plots of the final models where the fitted abundance values of the models 
# are plotted against each environmental explanatory variable in the model, holding all other variables not plotted at 
# their mean. As an illustrative example, we only produce here plots for Black Swan and salinity. Plots for all other
# species and explanatory variables can be obtained modifying the code as required (e.g. specifying model of interest,
# specifying variables that need to be plotted)

# Note that before fitting the models, environmental variables were standardised around their mean value in units of 
# standard deviation to facilitate direct comparison of effect between variables. Salinity was also log-transformed. 
# For convenience, we provide here the mean, standard deviation, min and max of the untransformed data; and min and max 
# of the transformed data of each variable from the data set used to fit the abundance models. This way, the user can 
# back-transform the explanatory variables and present them in their original units. 


# Read mean, SD of explanatory variables for later back_transformation
vars <- fread("Mean and SD explanatory variables_abundance models.csv", header = T, stringsAsFactors = F)

# Check data
vars

# **Note about units: Units of the variables Are0to5, Area5to20, AreaGreater20 and Area are in squared meters**

#### ----Example: Black Swan----------------------------------------------------------------------

# For black swan, we're interested in salinity and turbidity. At the end of the script we've added code to obtain values
# for the other variables.

# To shorten the code and avoid repetition, we only provide the salinity response plot here. Response plot for turbidity 
# (and month) can be obtained by adapting the code simply changing the variable names where required. 

##### First: Store variables of interest ####

# Define variable values to be input in the new data frame constants and random effects to be excluded
# Note that we used the min and max of the transformed explanatory variables as these are the units used to fit the model

salinity <- seq(from = vars$min.trans[vars$variable == "AvgOfEC_us_cm"], to = vars$max.trans[vars$variable == "AvgOfEC_us_cm"], length.out = 100)

turbidity <- seq(from = vars$min.trans[vars$variable == "AvgOfTurbidity_NTU"], to = vars$max.trans[vars$variable == "AvgOfTurbidity_NTU"], length.out = 100)

month.res <- c(1:12) # Months for resident waterbirds

require(lubridate)
month.label.res <- as.character(month(month.res, label = T, abbr = T))

# Save random effects as they're spelled in the model summary to exclude them from the prediction.
re <- c("s(Year)", "s(PondNumber)")


##### Second: Create new data frame ####

# To create the response plot, we'll use a new data frame that we create with continuous values for the variable we want to investigate, holding all the other variables at their mean. We'll then predict abundance with this new data frame. 

# Check model variables for black swan - ALL VARIABLES except the response (i.e. Bird_Count) need to be specified in the new data frame we create
all.vars(ab_m[[2]]$formula)

# Create new data frame to plot black swan abundance given salinity.
nd <- expand.grid(Species = "Black Swan", # We can include variables that are not in the model, they'll be ignore by the predict function
                  Month = 6, # We could specify any particular month we're interested in
                  AvgOfEC_us_cm = salinity, # Use the store values for salinity
                  AvgOfTurbidity_NTU = 0, # Because we have centered and standardise variables in the model, 0 is the mean. 
                  Year = as.factor(2015), PondNumber = 10) # even if we're excluding the random effects from the predictions, these variables still need to be specified in the new data frame. )

# Predict abundances from new data frame
Abundance <- predict(ab_m[[2]], newdata = nd, # Specify the data frame we created to make predictions
                     type = "response", # Predictions in response units (i.e. number of birds)
                     se.fit = T, # To include standard errors of the predictions
                     exclude = re) # Exclude random effects

# **The object Abundance is a list with two items - fit and se.fit. The item fit contains the predicted abundances for our new data frame. The item se.fit contains the standard errors of the predictions.**

##### Third: Data frame of predictions and plot ####

# We'll use ggplot to create the final response plot. To make things easier, we'll create a data frame with the predictions
# store in Abundance in a way that can be easily used by ggplot. 

predicts <- data.frame(nd, Abundance) %>% # Joins the data frame we created and predicted values
  mutate(lower = fit - 1.96*se.fit,
         upper = fit + 1.96*se.fit) # mutate (from dplyr package) is used to create new columns in a data frame. Here we're creating the lower and upper limits of our confidence intervals

head(predicts)

# Create response plot for salinity

ggplot(data = predicts, 
       aes(x = exp(AvgOfEC_us_cm*vars$sd[vars$variable == "AvgOfEC_us_cm"] + vars$mean[vars$variable == "AvgOfEC_us_cm"]), # Salinity back-transformation. Note that we exp because salinity was also log-transformed, but exp doesn't need to be done for the other variables.
           y = fit, # Predicted abundance in the y-axis
           ymin = lower, ymax = upper)) + # Lower and upper 95% confidence intervals
  geom_ribbon(fill = "grey", alpha = .5) + # Creates shaed for confidence interval. alpha adds transparency
  geom_line(color = "blue", size = 1.5) + # Line of predicted values
  coord_cartesian(ylim = c(0, 30)) + # Crop y-axis to improve presentation
  # Other aesthetic options that are not necessary
  xlab("Salinity (µS/cm)") + # x-lab label
  ylab("Abundance") + # y-lab label
  ggtitle("Black Swan") + # Plot title
  theme_bw() # Change theme of plot (only to improve aesthetics)
  
# Save plot

ggsave("Black Swan_salinity abundance response.png", width = 5, height = 4) #ggsave saves the last plot (or ggplot object specify). The output file can also be a pdf, just specify .pdf instead of .png. 


## ----Supplementary code-----------------------------------------------------------------------------------------------

# To plot other species with different variables in their models, use below code to obtain values of the required 
# variables. Alternatively, the user can also provide a data set with observed or targeted environmental variables to 
# predict bird abundance using the predict function in the same way we used it in this script. The only requirement is 
# that the variables need to be named as they appear in the model (case sensitive), i.e. AvgOfEC_us_cm, AvgOfTurbidity_NTU, 
# PropCoverage, Area0to5, AreaGreater20, Area, so they can be recognised by the predict function. 

prop.cov <- seq(from = 0, to = 1,length.out = 50) # Proportional coverage. Note that the maximum observed value was 0.55

Hab5 <- seq(from = vars$min.trans[vars$variable == "Area0to5"], to = vars$min.trans[vars$variable == "Area0to5"], length.out = 100)

Hab20 <- seq(from = vars$min.trans[vars$variable == "AreaGreater20"], to = vars$max.trans[vars$variable == "AreaGreater20"], length.out = 100)

area <- seq(from = vars$min.trans[vars$variable == "Area"], to = vars$max.trans[vars$variable == "Area"], length.out = 100)

month.mig <- c(1:5) # Months for migratory waterbirds
month.label.mig <- c("Oct", "Nov", "Dec", "Jan", "Feb") # Labels for x-axis in plot


