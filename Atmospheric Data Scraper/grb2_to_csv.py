# Prereqs: pip install pygrib pandas
# Import required libraries
import pygrib
import pandas as pd

# Read GRIB2 File
grbs = pygrib.open('/home/mattlomicka/Desktop/Capstone/data/atmospheric/bashE2/20220901/rap_130_20220901_0000_000.grb2')

# Extract GRIB2 Data
temperature = grbs.select(name='Temperature')[0]
humidity = grbs.select(name='Relative humidity')[0]
pressure = grbs.select(name='Pressure')[0]

data = temperature.values
lats, lons = temperature.latlons()
humidity_data = humidity.values
pressure_data = pressure.values

# Prepare Data for CSV via df
df = pd.DataFrame({
    'Latitude': lats.flatten(),
    'Longitude': lons.flatten(),
    'Temperature': data.flatten(),
    'Humidity': humidity_data.flatten(),
    'Pressure': pressure_data.flatten()
})

# Save Data as CSV
df.to_csv('/home/mattlomicka/Desktop/Capstone/data/atmospheric/testFile.csv', index=False)

print('Conversion to CSV complete.')
