# NOAA Data Extraction and Processing

This script is designed to extract and process meteorological data from the National Oceanic and Atmospheric Administration (NOAA) website. It allows the user to choose the desired resolution and specify the date range, latitude range, and longitude range for the data extraction. The extracted data is then processed and merged into a single CSV file.

## Prerequisites

- Linux based Operating System (pop-os) 
- Bash shell environment
- Python 3.x

## Usage

1. Open a terminal or command prompt.
2. Navigate to the directory containing the script.
3. Run the script using the following command:

```bash
bash script_name.sh
```

Replace `script_name.sh` with the actual name of the script file.

## Instructions

1. The script will prompt you to choose the resolution for the data extraction.
2. Enter `1` or `2` to select the desired resolution (130 or 252).
3. Provide the necessary information when prompted:
   - Start date: Specify the start date for the data extraction in the format "YYYY-MM-DD".
   - End date: Specify the end date for the data extraction in the format "YYYY-MM-DD".
   - Latitude range: Enter the minimum and maximum latitude values separated by a space.
   - Longitude range: Enter the minimum and maximum longitude values separated by a space.
4. Press Enter to continue after reviewing the provided information.
5. The script will execute the following steps:

   - Run `NOAAExtract.sh` script with the specified start date, end date, and resolution.
   - Convert GRB2 files to CSV format using `grb2_to_csv.py`.
   - Reduce the extracted data to the specified latitude and longitude range using `reduceCoords.py`.
   - Merge the reduced data into a single CSV file using `mergeReduced.py`.
   - Move the generated `master.csv` file to the current directory.

6. Once the script execution is complete, you will see a message indicating the completion of the script.

## Note

- Please ensure that the required dependencies for the Python scripts (`grb2_to_csv.py`, `reduceCoords.py`, and `mergeReduced.py`) are installed and accessible in the system's PATH.

## Example Execution

```
bash rapidRefreshExtractor.sh
```

## Disclaimer

This script is provided as-is and without any warranty. Use it at your own risk. The script relies on the availability and structure of data from the NOAA website, which may change over time. Please refer to the NOAA website for the most up-to-date information and data availability.

