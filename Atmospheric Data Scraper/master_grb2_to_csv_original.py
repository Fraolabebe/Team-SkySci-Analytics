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
                
                # Read GRIB2 File
                grbs = pygrib.open(file_path)
                
                # Extract GRIB2 Data
                temperature = grbs.select(name='Temperature')[0]
                humidity = grbs.select(name='Relative humidity')[0]
                pressure = grbs.select(name='Pressure')[0]
                dew_point = grbs.select(name='2 metre dewpoint temperature')[0]
                
                data = temperature.values
                lats, lons = temperature.latlons()
                humidity_data = humidity.values
                pressure_data = pressure.values
                dew_point_data = dew_point.values
                
                # Prepare Data for CSV via DataFrame
                df = pd.DataFrame({
                    'Latitude': lats.flatten(),
                    'Longitude': lons.flatten(),
                    'Temperature': data.flatten(),
                    'Humidity': humidity_data.flatten(),
                    'Pressure': pressure_data.flatten(),
                    'Dew Point Temperature': dew_point_data.flatten()
                })
                
                # Construct the output CSV file path
                output_filename = os.path.splitext(filename)[0] + '.csv'
                output_path = os.path.join(output_dir, output_filename)
                
                # Save Data as CSV
                df.to_csv(output_path, index=False)

