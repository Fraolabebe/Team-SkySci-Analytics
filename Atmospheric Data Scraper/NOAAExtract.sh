#!/bin/bash

# Check if the start and end dates are provided as arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <start_date> <end_date> <resolution_url>"
  exit 1
fi

# Retrieve the start and end dates from the arguments
start_date="$1"
end_date="$2"
resolution_url="$3"

# Convert the start and end dates to timestamps
start_timestamp=$(date -d "$start_date" +%s)
end_timestamp=$(date -d "$end_date" +%s)

# Loop through each date in the range
current_timestamp=$start_timestamp
while [[ $current_timestamp -le $end_timestamp ]]
do
  # Convert the current timestamp back to date format
  current_date=$(date -d @$current_timestamp +%Y%m%d)
  # Create a directory for the current date
  mkdir -p "$current_date"
  # Download files for the current date
  url="${resolution_url}${current_date:0:6}/${current_date}/"

  wget -r -nd -np -A grb2 "$url" -P "$current_date"
  # Increment the current timestamp by one day
  current_timestamp=$(($current_timestamp + 86400))
done

