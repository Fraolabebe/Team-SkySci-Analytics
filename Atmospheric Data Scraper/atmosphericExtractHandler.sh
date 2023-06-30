#!/bin/bash

# Set input variables
input_file="input_data.grb2"
output_directory="output"

# Step 1: Run NOAAExtract.sh
echo "Step 1: Running NOAAExtract.sh..."
chmod +x NOAAExtract.sh
./NOAAExtract.sh "$input_file" "$output_directory"

# Step 2: Run grb2_to_csv.py
echo "Step 2: Running grb2_to_csv.py..."
python grb2_to_csv.py "$output_directory/data.grb2" "$output_directory/output.csv"

# Step 3: Run csvValidation.py
echo "Step 3: Running csvValidation.py..."
python csvValidation.py "$output_directory/output.csv"

# Step 4: Run reduceCoords.py
echo "Step 4: Running reduceCoords.py..."
python reduceCoords.py "$output_directory/output.csv" "$output_directory/reduced.csv"

# Step 5: Run mergeReduced.py
echo "Step 5: Running mergeReduced.py..."
python mergeReduced.py "$output_directory/reduced.csv" "$output_directory/final_output.csv"

echo "All steps completed successfully."
