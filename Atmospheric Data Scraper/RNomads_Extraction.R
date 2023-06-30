library(rNOMADS)

# Set the server and model for the RAP repository
rap_server <- "https://nomads.ncep.noaa.gov/"
rap_model <- "rap"

# Specify the time range for the data extraction
start_date <- as.Date("2022-09-01")
end_date <- as.Date("2022-12-22")

# Create a sequence of dates within the specified range
date_sequence <- seq(start_date, end_date, by = "days")

# Define the variables you want to extract
variables <- c("TMP:2 m", "RH:2 m", "UGRD:10 m", "VGRD:10 m")

# Loop through the date sequence and extract the data for each date
# for (date in date_sequence) {
#   # Format the date string in the required format for the URL
#   formatted_date <- format(date, "%Y%m%d")
#   
#   # Construct the URL for the GRIB file
#   url <- paste0(rap_server, "/", rap_model, "/", formatted_date, "/rap.t00z.awp130pgrbf00.grib2")
#   
#   # Download the GRIB file
#   dest_file <- paste0(formatted_date, ".grib2")
#   download.file(url, destfile = dest_file)
#   
#   # Perform further processing or analysis on the downloaded data
#   # ...
# }

# Define a function to download the GRIB file for a given date
download_GRIB <- function(date) {
  # Format the date string in the required format for the URL
  formatted_date <- format(date, "%Y%m%d")
  
  # Construct the URL for the GRIB file
  url <- paste0(rap_server, "/", rap_model, ".", formatted_date, "/", "rap.t00z.awp130pgrbf00.grib2")
  
  
  # Download the GRIB file
  dest_file <- paste0(formatted_date, ".grib2")
  download.file(url, destfile = dest_file)
  
  # Return the destination file name
  return(dest_file)
}

# Apply the download_GRIB function to each date in date_sequence
downloaded_files <- lapply(date_sequence, download_GRIB)

