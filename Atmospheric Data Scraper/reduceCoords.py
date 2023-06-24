import os
import pandas as pd

# Directory path containing the CSV files
directory = 'rawCSVs'

# Create a subdirectory for raw CSVs
output_directory = os.path.join(directory, 'reducedCSVs')
os.makedirs(output_directory, exist_ok=True)

# Get a list of all CSV files in the directory
csv_files = [file for file in os.listdir(directory) if file.endswith('.csv')]

# Iterate over each CSV file
for csv_file in csv_files:
    print(f'Reading: {csv_file}')
    # Read the CSV file
    csv_path = os.path.join(directory, csv_file)
    df = pd.read_csv(csv_path)
    
    # Apply latitude and longitude restrictions
    filtered_df = df[(df['Latitude'] >= 35) & (df['Latitude'] <= 40) &
                     (df['Longitude'] >= -80) & (df['Longitude'] <= -75)]
    
    # Save the filtered data as a new CSV file in the output directory
    output_file = os.path.join(output_directory, csv_file)
    filtered_df.to_csv(output_file, index=False)
    print(f'Closing: {csv_file}')
