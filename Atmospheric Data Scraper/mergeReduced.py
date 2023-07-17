import os
import pandas as pd
from datetime import datetime

# Directory path containing the reduced CSV files
directory = 'rawCSVs/reducedCSVs'

# Create a master CSV file
master_csv_file = 'rawCSVs/reducedCSVs/master.csv'

# Get a list of all reduced CSV files in the directory
csv_files = [file for file in os.listdir(directory) if file.endswith('.csv')]

# Create an empty DataFrame to store the merged data
merged_data = pd.DataFrame()

# Iterate over each reduced CSV file
for csv_file in csv_files:
    print(f'Reading in: {csv_file}')
    # Read the reduced CSV file
    csv_path = os.path.join(directory, csv_file)
    df = pd.read_csv(csv_path)
    
    # Extract the timestamp from the CSV file name
    file_parts = csv_file.split('_')
    date_part = file_parts[2]  # Extract the date part from the file name
    hour_part = file_parts[3]  # Extract the hour part from the file name
    timestamp_str = date_part + hour_part  # Combine date and hour
    timestamp = datetime.strptime(timestamp_str, '%Y%m%d%H%M')
    print(f"Extracted timestamp: {timestamp}")
    
    # Add a 'Timestamp' column to the DataFrame
    df['Timestamp'] = timestamp
    
    # Concatenate the reduced data to the merged DataFrame
    merged_data = pd.concat([merged_data, df], ignore_index=True)
    print(f"Closing file: {csv_file}")

# Sort the merged data by timestamp
merged_data = merged_data.sort_values('Timestamp')

# Reorganize the column order
column_order = ['Timestamp', 'Latitude', 'Longitude', 'Temperature', 'Humidity', 'Pressure', 'Dew Point Temperature']
merged_data = merged_data[column_order]

# Save the merged data to the master CSV file
merged_data.to_csv(master_csv_file, index=False)

