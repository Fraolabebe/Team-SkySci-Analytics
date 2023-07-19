import os
import pygrib

# Specify the directory containing the GRIB2 files
grib_dir = '/home/mattlomicka/Desktop/Capstone/data/atmospheric/testExtraction/20221222'

# Iterate over the GRIB2 files in the directory
for filename in os.listdir(grib_dir):
    if filename.endswith('.grb2'):
        file_path = os.path.join(grib_dir, filename)
        
        # Read GRIB2 file
        grbs = pygrib.open(file_path)
        
        # Get available attributes
        attributes = [grb.name for grb in grbs]
        
        print(f"Attributes for file: {filename}")
        print(attributes)
        print("-" * 30)
        
        # Close the GRIB2 file
        grbs.close()

