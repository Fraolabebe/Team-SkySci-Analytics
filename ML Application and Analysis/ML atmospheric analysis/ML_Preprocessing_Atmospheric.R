# Groundweather preprocessing script
library(dplyr)
library(tidyr)
library(readr)

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ",getwd()), sep="\n")

# Load the dataset
dataset <- read_csv("atmospheric_weather_merged.csv")

# rename Image Present to Image
# Check the current column names in the dataframe
column_names <- names(dataset)
column_names
#-------------------------------------------------------------------------------
# Rename column names

# EX: "Image Present" column to "Image"
new_column_names <- ifelse(column_names == "Image Present", "image", column_names)
# Default example first then others
new_column_names <- ifelse(column_names == "atm_TMP", "temperature", new_column_names)
new_column_names <- ifelse(column_names == "Humidity", "humidity", new_column_names)
new_column_names <- ifelse(column_names == "Pressure", "pressure", new_column_names)

#-------------------------------------------------------------------------------
# Update the dataframe with the new column names
names(dataset) <- new_column_names
names(dataset)


# Data preprocessing
# Remove any unnecessary columns
df <- select(dataset, 
             -"Datetime"
             #,-"temperature"                 
             #,-"humidity"
             ,-"atm_dewPt"                   
             #,-"pressure"
             ,-"Altitude (feet)"             
             ,-"TMP_C"
             ,-"dewPT_C"                     
             ,-"Saturated_Vapor_Pressur"
             ,-"Actual_Vapor_Pressure"       
             ,-"RH_water"
             ,-"RH_ice"                      
             #,-"image"
             ,-"Low/Mid Clouds (%)"          
             ,-"High Cirrus (%)"
             ,-"Long-lived Contrails (Count)"
             ,-"Contrail-Cirrus (Count)"
             ,-"Day Low/Mid"                 
             ,-"Day Count Cirrs"
             ,-"Day Count Cont LL"           
             ,-"Day Count Cont-Cirrus"
             )

# Handle missing values
df <- na.omit(df)

# Normalize all values between 0 & 1 for each set
df$temperature <- df$temperature / max(df$temperature)
df$humidity <- df$humidity / max(df$humidity)
df$pressure <- df$pressure / max(df$pressure)

write.csv(df, "atmospheric_weather_preprocessed.csv", row.names=FALSE)
