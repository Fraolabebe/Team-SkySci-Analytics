#!/bin/bash

base_url="https://nomads.ncep.noaa.gov/pub/data/nccf/com/rap/prod/"
start_date="20220901"
end_date="20221222"

# Convert start and end dates to UNIX timestamps
start_timestamp=$(date -d "$start_date" +%s)
end_timestamp=$(date -d "$end_date" +%s)

# Iterate over each day between the start and end dates
current_timestamp=$start_timestamp
while [ $current_timestamp -le $end_timestamp ]; do
    current_date=$(date -d @$current_timestamp +%Y%m%d)
    mkdir "$current_date"  # Create a directory for the current day

    for hour in {00..23}; do
        # Construct the download URL for each hourly file
        file_url="${base_url}rap.${current_date}/rap.t${hour}z.awp130pgrbf00.grib2"

        # Download the file and save it to the current day's directory
        curl -o "$current_date/rap.t${hour}z.awp130pgrbf00.grib2" "$file_url"

        # Extract specific field using wgrib2
        input_filename="$current_date/rap.t${hour}z.awp130pgrbf00.grib2"
        output_filename="$current_date/output_${hour}.grib2"

#        wgrib2 "$input_filename"
#        wgrib2 "$input_filename" -match "<field_number>:<parameter_name>" -grib "$output_filename"
    done

    current_timestamp=$((current_timestamp + 86400))  # Move to the next day (86400 seconds in a day)
done
echo "Script Complete"
