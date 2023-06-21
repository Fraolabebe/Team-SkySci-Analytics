# Notes for use:
# 1) upgrade numpy prior to installing pygrib: pip install --upgrade numpy
# 2) uninstall pygrib if you already installed else skip to step 3: pip uninstall pygrib
# 3) install pygrib after updating numpy:  pip install pygrib
import csv
import pygrib

def grib_to_csv(grib_file, csv_file):
    grbs = pygrib.open(grib_file)

    with open(csv_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)

        for grb in grbs:
            if grb.name == 'Temperature':
                data = grb.values
                lat, lon = grb.latlons()
                rows, cols = data.shape

                for i in range(rows):
                    for j in range(cols):
                        row = [lat[i, j], lon[i, j], data[i, j]]
                        writer.writerow(row)
    grbs.close()

# Example usage
grib_file = 'rap_252_20220901_0000_000.grb2'
csv_file = 'output.csv'
grib_to_csv(grib_file, csv_file)

