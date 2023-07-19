import os
import pygrib
import pandas as pd

# Specify the directory containing the GRIB2 files
script_dir = os.path.dirname(os.path.abspath(__file__))
grib_dir = script_dir
# grib_dir = '/home/mattlomicka/Desktop/Capstone/data/atmospheric/bashE2/'

# Create the rawCSVs subdirectory if it doesn't exist
output_dir = os.path.join(grib_dir, 'rawCSVs')
os.makedirs(output_dir, exist_ok=True)

# Iterate over the directories containing the GRIB2 files
for subdir in os.listdir(grib_dir):
    subdir_path = os.path.join(grib_dir, subdir)
    if os.path.isdir(subdir_path):
        # Iterate over the GRIB2 files in the current directory
        for filename in os.listdir(subdir_path):
            if filename.endswith('.grb2'):
                file_path = os.path.join(subdir_path, filename)
                
                # Check if the CSV file already exists
                output_filename = os.path.splitext(filename)[0] + '.csv'
                output_path = os.path.join(output_dir, output_filename)
                if os.path.exists(output_path):
                    print("Skipping", filename, "- CSV already exists:", output_path)
                    print("--------------------------------------")
                    continue
                
                # Read GRIB2 File
                print("Reading file:", file_path)
                grbs = pygrib.open(file_path)
                
                # Extract GRIB2 Data
                print("Extracting data from", filename)
                # Filter and select temperature matches with level value 18000
                temperature_messages = [msg for msg in grbs.select(name='Temperature') if msg.level == 18000]
                
                # Iterate over the selected temperature messages
                for temperature in temperature_messages:
                    data = temperature.values
                    lats, lons = temperature.latlons()
                    
                    # Prepare Data for CSV via DataFrame
                    print("Preparing data for CSV:", filename)
                    df = pd.DataFrame({
                        'Latitude': lats.flatten(),
                        'Longitude': lons.flatten(),
                        'Temperature': data.flatten()
                    })
                    
                    # Save Data as CSV
                    print("Saving data as CSV:", output_path)
                    df.to_csv(output_path, index=False)
                
                print("Completed processing", filename)
                print("--------------------------------------")

print("Script execution completed.")

