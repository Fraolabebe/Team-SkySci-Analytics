# Testing theory
# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)

#-------------------------------------------------------------------------------
# NOTE: Set to your working directory 
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")
#-------------------------------------------------------------------------------
# Load Dataset
df <- read_csv("atmospheric_weather_preprocessed.csv")
plot.subtitle <- "Atmospheric Weather Data (20KM)"
#-------------------------------------------------------------------------------

title.var <- "Humidity versus Temperature by Contrail Presence"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022"
# Create the ggplot scatter plot
ggplot(df, aes(x = temperature, y = humidity, color = as.factor(image))) +
  geom_point(aes(alpha = as.factor(image)), size = 1) +  # Set the size of points
  scale_alpha_manual(values = c(0.2, 1.0)) +  # Set alpha values for each level of "image"
  labs(x = "Temperature (K)", y = "Relative Humidity (%)", color = "image",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
