import csv

def compare_csv_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        reader1 = csv.reader(f1)
        reader2 = csv.reader(f2)
        data1 = list(reader1)
        data2 = list(reader2)

        sorted_data1 = sorted(data1)
        sorted_data2 = sorted(data2)

        return sorted_data1 == sorted_data2

# Example usage
file1_path = 'surfaceWeatherData.csv'
file2_path = 'doppleganger_surfaceWeatherData.csv'

if compare_csv_files(file1_path, file2_path):
    print("The CSV files contain the same data.")
else:
    print("The CSV files do not contain the same data.")
