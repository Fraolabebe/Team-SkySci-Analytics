import os
import sys
import pandas as pd

# Directory path containing the CSV files
directory = 'rawCSVs'

# Create a subdirectory for raw CSVs
output_directory = os.path.join(directory, 'reducedCSVs')
os.makedirs(output_directory, exist_ok=True)

# Get a list of all CSV files in the directory
csv_files = [file for file in os.listdir(directory) if file.endswith('.csv')]

# Retrieve the minimum and maximum latitude and longitude from command-line arguments
if len(sys.argv) != 5:
    print("Usage: python reduceCoords.py <latitude_min> <latitude_max> <longitude_min> <longitude_max>")
    sys.exit(1)

# latitude_min="38.4"  # Replace with the minimum latitude value
# latitude_max="39.0"  # Replace with the maximum latitude value
# longitude_min="-78.0"  # Replace with the minimum longitude value
# longitude_max="-76.0"  # Replace with the maximum longitude value

latitude_min = float(sys.argv[1])
latitude_max = float(sys.argv[2])
longitude_min = float(sys.argv[3])
longitude_max = float(sys.argv[4])

# Iterate over each CSV file
for csv_file in csv_files:
    print(f'Reading: {csv_file}')
    # Read the CSV file
    csv_path = os.path.join(directory, csv_file)
    df = pd.read_csv(csv_path)
    
    # Apply latitude and longitude restrictions
    filtered_df = df[(df['Latitude'] >= latitude_min) & (df['Latitude'] <= latitude_max) &
                     (df['Longitude'] >= longitude_min) & (df['Longitude'] <= longitude_max)]
    
    # Save the filtered data as a new CSV file in the output directory
    output_file = os.path.join(output_directory, csv_file)
    filtered_df.to_csv(output_file, index=False)
    print(f'Closing: {csv_file}')

