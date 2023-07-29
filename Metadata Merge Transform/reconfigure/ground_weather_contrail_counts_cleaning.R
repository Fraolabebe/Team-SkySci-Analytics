# Load Libraries
library(readr)
library(dplyr)
library(stringr)
#-------------------------------------------------------------------------------
# NOTE: Set to your working directory
{
  setwd(dirname(rstudioapi::getSourceEditorContext()$path))
  print(paste("Current Working Directory: ", getwd()), sep = "\n")
  # Load the csvs into a dataframes
  df <- read_csv("ground_weather_merged.csv")
  head(df)
}
#===============================================================================
# Cleaning Process
#===============================================================================
{
  # Count NAs in the specified columns
  na_count_long_lived_contrails <- sum(is.na(df$`Long-lived Contrails (Count)`))
  na_count_contrail_cirrus <- sum(is.na(df$`Contrail-Cirrus (Count)`))
  
  # Display the counts of NAs
  print(paste("NAs in 'Long-lived Contrails (Count)':", na_count_long_lived_contrails))
  print(paste("NAs in 'Contrail-Cirrus (Count)':", na_count_contrail_cirrus))
  
  # Track the issue numerically
  long.lived.old <- table(df$`Long-lived Contrails (Count)`)
  short.lived.old <- table(df$`Contrail-Cirrus (Count)`)
  
  # Clean target columns prior to adding them
  df <- df %>%
    mutate(`Long-lived Contrails (Count)` = replace(`Long-lived Contrails (Count)`, is.na(`Long-lived Contrails (Count)`), 0),
           `Contrail-Cirrus (Count)` = replace(`Contrail-Cirrus (Count)`, is.na(`Contrail-Cirrus (Count)`), 0))
  
  # Validate changes
  table(df$`Long-lived Contrails (Count)`) - na_count_long_lived_contrails
  table(df$`Contrail-Cirrus (Count)`) - na_count_contrail_cirrus
  
#===============================================================================
# Create `contrailPresent` to atmospheric cleaned and rename to atmospheric_prep
#===============================================================================
  # Create the new attribute 'contrailPresent'
  df <- df %>%
    mutate(contrailPresent = ifelse(
      (`Long-lived Contrails (Count)` + `Contrail-Cirrus (Count)`) != 0,
      1,
      0
    ))
}

#===============================================================================
# Cleanup and Export to preprocessed dataset for ML Analysis
#===============================================================================
# Assuming `df` is your original dataframe
# Create a vector with the names of the attributes you want to keep
attributes_to_keep <- c("Temperature", "humidity", "contrailPresent")
# Use the subset function to keep only the specified attributes
df_reduced <- subset(df, select = attributes_to_keep)
# Print the column names of the reduced dataframe
# Change the column name "Temperature" to "temperature"
colnames(df_reduced)[colnames(df_reduced) == "Temperature"] <- "temperature"
colnames(df_reduced)[colnames(df_reduced) == "contrailPresent"] <- "image"

# Export atmospheric_prep to CSV file
write_csv(df_reduced, "ground_weather_preprocessed.csv")
#===============================================================================