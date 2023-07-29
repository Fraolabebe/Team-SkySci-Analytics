# Load Libraries
library(readr)
library(stringr)
#-------------------------------------------------------------------------------
# NOTE: Set to your working directory
{
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
print(paste("Current Working Directory: ", getwd()), sep = "\n")

# Load the csvs into a dataframes
cleaned_atmospheric <- read_csv("cleaned_atmospheric.csv")
SkyConditionData_cleaned <- read_csv("SkyConditionData_cleaned.csv")

head(cleaned_atmospheric)
head(SkyConditionData_cleaned)
}
#===============================================================================
# Cleaning Process
#===============================================================================
# # Remove the trailing 'Z' from Timestamps
# cleaned_atmospheric$Timestamp <- str_replace(cleaned_atmospheric$Timestamp, "Z$", "")
# 
# # Recast Timestamps as POSIXct (date-time format)
# cleaned_atmospheric$Timestamp <- as.POSIXct(cleaned_atmospheric$Timestamp, format = "%Y-%m-%dT%H:%M:%S")
#-------------------------------------------------------------------------------
{
# Count NAs in the specified columns
na_count_long_lived_contrails <- sum(is.na(SkyConditionData_cleaned$`Long-lived Contrails (Count)`))
na_count_contrail_cirrus <- sum(is.na(SkyConditionData_cleaned$`Contrail-Cirrus (Count)`))

# Display the counts of NAs
print(paste("NAs in 'Long-lived Contrails (Count)':", na_count_long_lived_contrails))
print(paste("NAs in 'Contrail-Cirrus (Count)':", na_count_contrail_cirrus))

# Track the issue numerically
table(SkyConditionData_cleaned$`Long-lived Contrails (Count)`)
table(SkyConditionData_cleaned$`Contrail-Cirrus (Count)`)

# Clean target columns prior to adding them
SkyConditionData_cleaned <- SkyConditionData_cleaned %>%
  mutate(`Long-lived Contrails (Count)` = replace_na(`Long-lived Contrails (Count)`, 0),
         `Contrail-Cirrus (Count)` = replace_na(`Contrail-Cirrus (Count)`, 0))

# Validate changes
table(SkyConditionData_cleaned$`Long-lived Contrails (Count)`)
table(SkyConditionData_cleaned$`Contrail-Cirrus (Count)`)

# Create the new attribute 'contrailPresent'
SkyConditionData_cleaned <- SkyConditionData_cleaned %>%
  mutate(contrailPresent = ifelse(
    (`Long-lived Contrails (Count)` + `Contrail-Cirrus (Count)`) != 0,
    1,
    0
  ))

}
#===============================================================================
# Append `contrailPresent` to atmospheric cleaned and rename to atmospheric_prep
#===============================================================================
# Convert the 'Datetime' column in SkyConditionData_cleaned to the same format 
# as 'Timestamp' in cleaned_atmospheric
SkyConditionData_cleaned$Datetime <- as.POSIXct(SkyConditionData_cleaned$Datetime, 
                                                format = "%Y-%m-%d %H:%M:%S")
# Merge the 'contrailPresent' column based on matching timestamps
atmospheric_prep <- cleaned_atmospheric %>%
  left_join(SkyConditionData_cleaned[c("Datetime", "contrailPresent")], 
            by = c("Timestamp" = "Datetime"), suffix = c("", ".y"), 
            multiple="all")

#===============================================================================
# Cleanup and Export to preprocessed dataset for ML Analysis
#===============================================================================
# Remove the Timestamp column from atmospheric_prep dataframe
atmospheric_prep <- atmospheric_prep %>%
  select(-Timestamp)

# Drop records with contrailPresent of NA
atmospheric_prep <- atmospheric_prep %>%
  filter(!is.na(contrailPresent))

# Rename attributes from Level to pressure, Temperature to temperature, Humidity to humidity, and contrailPresent to image
atmospheric_prep <- atmospheric_prep %>%
  rename(pressure = Level, temperature = Temperature, humidity = Humidity, image = contrailPresent)

# Export atmospheric_prep to CSV file
write_csv(atmospheric_prep, "atmospheric_weather_preprocessed.csv")
#===============================================================================
