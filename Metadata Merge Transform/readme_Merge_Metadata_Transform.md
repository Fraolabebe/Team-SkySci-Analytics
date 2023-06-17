# Merge_Metadata_Transform

This script allows you to merge a selected CSV file with another pre-cleaned CSV file called "SkyConditionData_cleaned.csv". The merged data will be saved as "ground_weather_merged.csv". Follow the instructions below to use the script:

1. Place the script in the directory where your CSV files are located.
2. Make sure you have the required dependencies: `pandas` and `os`.
3. Run the script using a Python interpreter.

The script will do the following:

1. List all CSV files in the current directory, excluding "SkyConditionData_cleaned.csv".
2. Prompt you to select a CSV file to merge with.
3. Read the selected CSV file and the pre-cleaned CSV file.
4. Convert the date/time columns to datetime format.
5. Round up the datetime values to the next hour for the selected CSV file.
6. Perform an inner join operation based on the datetime values.
7. Drop the redundant 'Datetime' column and rename the 'Date/Time' column to 'Datetime'.
8. Sort the merged data chronologically based on 'Datetime'.
9. Reset the index of the merged data.
10. Save the merged data as "ground_weather_merged.csv" in the current directory.

If no CSV file is selected or no CSV files are found in the current directory, appropriate messages will be displayed.

Please note that you may need to modify the script if you want to customize the filenames or file paths.
