# Load required library
library(dplyr)
library(tidyr)
library(readr)
library(class)
library(ggplot2)

#-------------------------------------------------------------------------------
# Define a function to create and save the plots
save_plot <- function(plot, filename) {
  # Set the graphics device (png in this case)
  png(filename)
  print(plot)  # Print the plot to the graphics device
  dev.off()   # Close the graphics device after saving the plot
}
#-------------------------------------------------------------------------------

# NOTE: Set to your working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")


# Load the CSV file into a dataframe
df <- read.csv("cleaned_atmospheric.csv")

# View the loaded dataframe (optional)
head(df)

subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022"
monthly.color <- c("#619cff","#00b6ff","#00cbfe","#18dcee")
#===============================================================================
# Humidity Visuals
#===============================================================================
# Humidity for all of time at all pressure levels
{
title.var <- "Relative Humidity through Time for all Pressure Levels"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Create the ggplot scatter plot
ggplot(df, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_point() +
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

humidity_all_levels <- ggplot(df, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_line() +  # Add lines for each level series
  geom_point(shape = NA) +  # Hide all scatter points
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

humidity_all_levels
}
#-------------------------------------------------------------------------------
{
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Humidity for all of time at all pressure levels
title.var <- "Relative Humidity through Time for all Pressure Levels"
# Create the ggplot line plot
ggplot(df, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_line() +  # Add lines for each level series
  geom_point(shape = NA) +  # Hide all scatter points
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for all of time at pressure levels (200 - 250)
{
title.var <- "Relative Humidity through Time for Pressure Levels from 200 to 250"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values between 200 and 250
df_filtered <- subset(df, Level >= 200 & Level <= 250)
# Create the ggplot scatter plot
ggplot(df_filtered, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_point() +
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for all of time at pressure levels (200)
{
title.var <- "Relative Humidity through Time for Pressure Level 200"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 200
df_filtered <- subset(df, Level == 200)
# Create the ggplot scatter plot
ggplot(df_filtered, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_point() +
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for all of time at pressure levels (225)
{
title.var <- "Relative Humidity through Time for Pressure Level 225"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 225
df_filtered <- subset(df, Level == 225)
# Set the common color for level 225 (blue)
common_color <- "#619CFF"
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_filtered, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_point() +
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  scale_color_manual(values = common_color) +  # Set the common color for level 225
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for all of time at pressure levels (250)
{
  title.var <- "Relative Humidity through Time for Pressure Level 250"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 250
df_filtered <- subset(df, Level == 250)
# Set the common color for level 225 (blue)
common_color <- "#00BA38"
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_filtered, aes(x = Timestamp, y = Humidity, color = as.factor(Level))) +
  geom_point() +
  labs(x = "Timestamp", y = "Relative Humidity (%)", color = "Level",
       title = title.var, subtitle = subtitle.var) +
  scale_color_manual(values = common_color) +  # Set the common color for level 225
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for September time at pressure levels (225)
{
title.var <- "Relative Humidity through Time for Pressure Level 225"
subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Sept 30th 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 225
df_filtered <- subset(df, Level == 225)
# Set the common color for level 225 (blue)
common_color <- monthly.color[1]
# Filter the dataframe to include only data for September
df_september <- subset(df_filtered, format(Timestamp, "%m") == "09")
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_september, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_september, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for October time at pressure levels (225)
{
title.var <- "Relative Humidity through Time for Pressure Level 225"
subtitle.var <- "NOAA RAP (20KM) Oct 1st 2022 - Oct 31st 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values between 200 and 225
df_filtered <- subset(df, Level == 225)
# Set the common color for level 225 (blue)
common_color <- monthly.color[2]
# Filter the dataframe to include only data for October
df_october <- subset(df_filtered, format(Timestamp, "%m") == "10")
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_october, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_october, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for November time at pressure levels (225)
{
title.var <- "Relative Humidity through Time for Pressure Level 225"
subtitle.var <- "NOAA RAP (20KM) Nov 1st 2022 - Nov 30th 2022 { 225 mb ~ approx 36,000 feet}"
# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 225
df_filtered <- subset(df, Level == 225)
# Set the common color for level 225 (blue)
common_color <- monthly.color[3]
# Filter the dataframe to include only data for November
df_november <- subset(df_filtered, format(Timestamp, "%m") == "11")
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_november, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_november, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------
# Humidity for December time at pressure levels (225)
{
title.var <- "Relative Humidity through Time for Pressure Level 225"
subtitle.var <- "NOAA RAP (20KM) Dec 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"

# Convert the "Timestamp" column to a proper date-time format
df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
# Filter the dataframe to include only Level values 225
df_filtered <- subset(df, Level == 225)
# Set the common color for level 225 (blue)
common_color <- monthly.color[4]
# Filter the dataframe to include only data for December
df_december <- subset(df_filtered, format(Timestamp, "%m") == "12")
# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_december, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()

# Create the ggplot scatter plot and use scale_color_manual to set the common color
ggplot(df_december, aes(x = Timestamp, y = Humidity)) +
  geom_point(color = common_color) +
  geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
  labs(x = "Timestamp", y = "Relative Humidity (%)",
       title = title.var, subtitle = subtitle.var) +
  theme_minimal()
}
#-------------------------------------------------------------------------------

#===============================================================================
# Temperature Visuals
monthly.color <- c("#fe443b","#ec50a5","#967fdc","#3c97d0")
#===============================================================================
# Temperature for all of time at all pressure levels
{
  title.var <- "Relative Temperature through Time for all Pressure Levels"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Create the ggplot scatter plot
  ggplot(df, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_point() +
    labs(x = "Timestamp", y = "Relative Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
  
  ggplot(df, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_line() +  # Add lines for each level series
    geom_point(shape = NA) +  # Hide all scatter points
    labs(x = "Timestamp", y = "Relative Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
{
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Temperature for all of time at all pressure levels
  title.var <- "Relative Temperature through Time for all Pressure Levels"
  # Create the ggplot line plot
  ggplot(df, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_line() +  # Add lines for each level series
    geom_point(shape = NA) +  # Hide all scatter points
    labs(x = "Timestamp", y = "Relative Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for all of time at pressure levels (200 - 250)
{
  title.var <- "Temperature through Time for Pressure Levels from 200 to 250"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values between 200 and 250
  df_filtered <- subset(df, Level >= 200 & Level <= 250)
  # Create the ggplot scatter plot
  ggplot(df_filtered, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_line() +
    geom_point(size=0.35) +
    labs(x = "Timestamp", y = "Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for all of time at pressure levels (200)
{
  title.var <- "Temperature through Time for Pressure Level 200"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 200
  df_filtered <- subset(df, Level == 200)
  # Create the ggplot scatter plot
  ggplot(df_filtered, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_point(size=0.75) +
    labs(x = "Timestamp", y = "Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for all of time at pressure levels (225)
{
  title.var <- "Temperature through Time for Pressure Level 225"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 225
  df_filtered <- subset(df, Level == 225)
  # Set the common color for level 225 (blue)
  common_color <- "#619CFF"
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_filtered, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_point(size=0.75) +
    labs(x = "Timestamp", y = "Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    scale_color_manual(values = common_color) +  # Set the common color for level 225
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for all of time at pressure levels (250)
{
  title.var <- "Temperature through Time for Pressure Level 250"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 250
  df_filtered <- subset(df, Level == 250)
  # Set the common color for level 225 (blue)
  common_color <- "#00BA38"
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_filtered, aes(x = Timestamp, y = Temperature, color = as.factor(Level))) +
    geom_point(size=0.75) +
    labs(x = "Timestamp", y = "Temperature (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    scale_color_manual(values = common_color) +  # Set the common color for level 225
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for September time at pressure levels (225)
{
  title.var <- "Temperature through Time for Pressure Level 225"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Sept 30th 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 225
  df_filtered <- subset(df, Level == 225)
  # Set the common color for level 225 (blue)
  common_color <- monthly.color[1]
  # Filter the dataframe to include only data for September
  df_september <- subset(df_filtered, format(Timestamp, "%m") == "09")
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_september, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
  
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_september, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for October time at pressure levels (225)
{
  title.var <- "Temperature through Time for Pressure Level 225"
  subtitle.var <- "NOAA RAP (20KM) Oct 1st 2022 - Oct 31st 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values between 200 and 225
  df_filtered <- subset(df, Level == 225)
  # Set the common color for level 225 (blue)
  common_color <- monthly.color[2]
  # Filter the dataframe to include only data for October
  df_october <- subset(df_filtered, format(Timestamp, "%m") == "10")
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_october, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
  
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_october, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for November time at pressure levels (225)
{
  title.var <- "Temperature through Time for Pressure Level 225"
  subtitle.var <- "NOAA RAP (20KM) Nov 1st 2022 - Nov 30th 2022 { 225 mb ~ approx 36,000 feet}"
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 225
  df_filtered <- subset(df, Level == 225)
  # Set the common color for level 225 (blue)
  common_color <- monthly.color[3]
  # Filter the dataframe to include only data for November
  df_november <- subset(df_filtered, format(Timestamp, "%m") == "11")
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_november, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
  
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_november, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#-------------------------------------------------------------------------------
# Temperature for December time at pressure levels (225)
{
  title.var <- "Temperature through Time for Pressure Level 225"
  subtitle.var <- "NOAA RAP (20KM) Dec 1st 2022 - Dec 22nd 2022 { 225 mb ~ approx 36,000 feet}"
  
  # Convert the "Timestamp" column to a proper date-time format
  df$Timestamp <- as.POSIXct(df$Timestamp, format = "%Y-%m-%d %H:%M:%S")
  # Filter the dataframe to include only Level values 225
  df_filtered <- subset(df, Level == 225)
  # Set the common color for level 225 (blue)
  common_color <- monthly.color[4]
  # Filter the dataframe to include only data for December
  df_december <- subset(df_filtered, format(Timestamp, "%m") == "12")
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_december, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
  
  # Create the ggplot scatter plot and use scale_color_manual to set the common color
  ggplot(df_december, aes(x = Timestamp, y = Temperature)) +
    geom_point(color = common_color) +
    geom_line(color = common_color, size = 0.2) +  # Add a line connecting the first and last data points
    labs(x = "Timestamp", y = "Temperature (%)",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
#===============================================================================
# Misc. Visuals
#===============================================================================
# Humidity versus Temperature colored by Level
{
  title.var <- "Humidity versus Temperature by Level"
  subtitle.var <- "NOAA RAP (20KM) Sept 1st 2022 - Dec 22nd 2022"
  # Create the ggplot scatter plot
  ggplot(df, aes(x = Temperature, y = Humidity, color = as.factor(Level))) +
    geom_point() +
    labs(x = "Temperature (K)", y = "Relative Humidity (%)", color = "Level",
         title = title.var, subtitle = subtitle.var) +
    theme_minimal()
}
