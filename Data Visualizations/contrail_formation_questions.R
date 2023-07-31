# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)
library(ggplot2)

#-------------------------------------------------------------------------------

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")


# Load the CSV file into a dataframe
df <- read.csv("atmospheric_data_ice_humidity.csv")

# View the loaded dataframe (optional)
head(df)
colnames(df)

# 1.	For slide #4, what % of the total points are "Contrail" - It would be good to enhance this slide with this info 
{filtered_df <- df %>%
filter(contrailPresent == 1)
contrail.count <- nrow(filtered_df)
print(paste("Contrail Present (all levels):", contrail.count))
}

{
filtered_df <- df %>%
filter(Level < 300, contrailPresent == 1)
nrow(filtered_df)
contrail.count.under.300 <- nrow(filtered_df)
print(paste("Contrail Present (Level < 300):", contrail.count.under.300))
}

{
filtered_df <- df %>%
filter(Level < 300, contrailPresent == 1, Temperature < 232)
nrow(filtered_df)
contrail.count.under.300.temp <- nrow(filtered_df)
print(paste("Contrail Present (Level < 300 && Temp < 232K):", contrail.count.under.300.temp))
}

{
filtered_df <- df %>%
filter(Level < 300, contrailPresent == 1, Temperature < 232, RH_ice > 100)
nrow(filtered_df)
contrail.count.under.300.temp.humidity <- nrow(filtered_df)
print(paste("Contrail Present (Level < 300 && Temp < 232K && RH_ice > 100):", contrail.count.under.300.temp.humidity))
}


# 2.	For each date/time in the spreadsheet which has at least one contrail, is there a Pressure Level (i.e. 250, 225, 200) that has <232 deg Kelvin AND > 100% RH-Ice? 
#   i.e. What % of the date/time in the spreadsheet with a contrail can be explained by at least one Pressure Level with  <232 deg Kelvin AND > 100% RH-Ice.
{
filtered_df <- df %>%
  filter(Temperature < 232, RH_ice > 100, Level < 300, contrailPresent == 1)
temp.low <- table(filtered_df$Level)
temp.low
# Export 'filtered_df' to a CSV file named "contrail_disection.csv"
write.csv(filtered_df, file = "contrail_disection.csv", row.names = FALSE)
}
