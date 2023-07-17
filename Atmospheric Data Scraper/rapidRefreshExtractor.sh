#!/bin/bash

# Prompt the user to choose the resolution
echo "Choose the resolution:"
echo "1. 130 (13km)"
echo "2. 252 (20km)"
read -p "Enter your choice (1 or 2): " choice

# Set the resolution and URL based on user input
if [[ $choice == 1 ]]; then
    resolution="https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-130-13km/analysis/"
elif [[ $choice == 2 ]]; then
    resolution="https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Set the remaining variables
start_date="2022-09-01"  # Replace with the specified start date
end_date="2022-12-23"  # Replace with the last date for extraction
latitude_min="38.7"  # Replace with the minimum latitude value
latitude_max="38.9"  # Replace with the maximum latitude value
longitude_min="-77.1"  # Replace with the minimum longitude value
longitude_max="-77.0"  # Replace with the maximum longitude value

echo "==================================================================================================="
echo "Repository URL: $resolution"
echo "Start Date: $start_date"
echo "End Date: $end_date"
echo "Lattitude Range: ($latitude_min, $latitude_max)"
echo "Longitude Range: ($longitude_min, $longitude_max)"
echo "==================================================================================================="

read -p "Press Enter to continue:"

# Execute the scripts
echo "Begin NOAAExtract.sh"
echo "======================================================"
echo "Diverted workflow Skipping NOAAEXTRACT.sh"
# bash NOAAExtract.sh "$start_date" "$end_date" "$resolution"
# echo "End NOAAExtract.sh"
echo "======================================================"
sleep 2

echo "Running grb2_to_csv.py"
python master_grb2_to_csv.py
echo "Completed grb2_to_csv.py"
echo "======================================================"

echo "Start reduceCoords.py"
python reduceCoords.py "$latitude_min" "$latitude_max" "$longitude_min" "$longitude_max"
echo "End reduceCoords.py"
echo "======================================================"
sleep 2


echo "Start mergeReduced.py"
python mergeReduced.py
echo "End mergeReduced.py"
echo "======================================================"

echo "Moving master.csv to `pwd`"
mv master.csv `pwd`/master.csv
echo "Script has concluded."
# Example Execution
# bash NOAAExtract.sh "20220701" "20220702" "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-130-13km/analysis/"
# python reduceCoords.py 35.0 40.0 -80.0 -75.0

