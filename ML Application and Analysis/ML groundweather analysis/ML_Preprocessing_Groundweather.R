# Groundweather preprocessing script
library(dplyr)
library(tidyr)
library(readr)

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ",getwd()), sep="\n")

# Load the dataset
dataset <- read_csv("ground_weather_merged.csv")

# rename Image Present to Image
# Check the current column names in the dataframe
column_names <- names(dataset)
column_names
# Rename the "Image Present" column to "Image"
new_column_names <- ifelse(column_names == "Image Present", "image", column_names)
new_column_names <- ifelse(column_names == "Temperature", "temperature", new_column_names)

# Update the dataframe with the new column names
names(dataset) <- new_column_names
names(dataset)


# Data preprocessing
# Remove any unnecessary columns
df <- select(dataset, -"Datetime",
             -"precp",
             -"Wind",
             -"wspd",
             -"dewPt",
             #-"Image Present",
             -"Low/Mid Clouds (%)",
             -"High Cirrus (%)",
             -"Long-lived Contrails (Count)",
             -"Contrail-Cirrus (Count)",
             -"Day Low/Mid",
             -"Day Count Cirrs",
             -"Day Count Cont LL",
             -"Day Count Cont-Cirrus")

# Handle missing values
df <- na.omit(df)

write.csv(df, "ground_weather_preprocessed.csv", row.names=FALSE)
