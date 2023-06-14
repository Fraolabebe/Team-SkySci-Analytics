# SkyConditionData Cleaning Script

This script is used to clean and manipulate the SkyConditionData from a CSV file. It performs the following steps:

1. Reads the input CSV file 'SkyConditionData_raw.csv' into a pandas DataFrame.
2. Converts the two-digit year to a four-digit format.
3. Combines the 'Day', 'Month', 'Year', and 'Hour' columns into a single 'Datetime' column.
4. Reorders the columns, placing the 'Datetime' column as the second column.
5. Sorts the DataFrame by the 'Datetime' column in ascending order.
6. Renames the column 'No Image or Poor Image' to 'Image Present'.
7. Converts values in the 'Image Present' column: 1 to 0 and 0 to 1.
8. Fills any NaN (null) values in the 'Image Present' column with 1.
9. Saves the cleaned DataFrame into a new CSV file named 'SkyConditionData_cleaned.csv'.
10. Displays a success message confirming the creation of the output file.

## Usage

1. Make sure you have Python installed.
2. Install the required dependencies by running `pip install pandas numpy`.
3. Place the input CSV file 'SkyConditionData_raw.csv' in the same directory as the script.
4. Run the script by executing `python SkyConditionData_Transform.py`.
5. After execution, the cleaned data will be saved in the file 'SkyConditionData_cleaned.csv'.

Please note that the script assumes the input CSV file follows the specified format, and the required columns are present. Adjustments may be needed for different data formats.
Feel free to customize and adapt the script according to your specific data cleaning requirements.
