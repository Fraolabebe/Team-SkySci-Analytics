import pandas as pd
import os

def list_and_select_csv_files():
    current_dir = os.getcwd()
    csv_files = [file for file in os.listdir(current_dir) if file.endswith('.csv') and file != 'SkyConditionData_cleaned.csv']

    if not csv_files:
        print("No CSV files found in the current directory.")
        return None

    print("Select a CSV file to merge with:")
    for i, file in enumerate(csv_files):
        print(f"{i+1}. {file}")

    while True:
        try:
            choice = int(input("Enter the number corresponding to the CSV file: "))
            if 1 <= choice <= len(csv_files):
                selected_file = csv_files[choice - 1]
                return selected_file
            else:
                print("Invalid choice. Please enter a valid number.")
        except ValueError:
            print("Invalid input. Please enter a number.")

# Prompt user to select a CSV file
selected_data = list_and_select_csv_files()
if selected_data:
    print(f"You selected: {selected_data}")

    # Read the selected CSV file
    selected_data = pd.read_csv(selected_data)

    # Read SkyConditionData_cleaned.csv
    sky_data = pd.read_csv('SkyConditionData_cleaned.csv')

    # Convert Date/Time columns to datetime format
    selected_data['Date/Time'] = pd.to_datetime(selected_data['Date/Time'], format="%y-%m-%d %I:%M:%S %p")
    sky_data['Datetime'] = pd.to_datetime(sky_data['Datetime'])

    # Round up the datetime to the next hour for selected_data
    selected_data['Date/Time'] = selected_data['Date/Time'].dt.ceil('H')

    # Perform the join operation
    merged_data = pd.merge(selected_data, sky_data, left_on='Date/Time', right_on='Datetime', how='inner')

    # Drop the 'Datetime' column as it's redundant
    merged_data.drop('Datetime', axis=1, inplace=True)

    # Rename the 'Date/Time' column to 'Datetime'
    merged_data.rename(columns={'Date/Time': 'Datetime'}, inplace=True)

    # Sort the rows chronologically based on 'Datetime'
    merged_data.sort_values('Datetime', inplace=True)

    # Reset the index
    merged_data.reset_index(drop=True, inplace=True)

    # Save the merged data to ground_weather_merged.csv
    merged_data.to_csv('ground_weather_merged.csv', index=False)

    print("Merge completed. Merged data saved to ground_weather_merged.csv.")
else:
    print("No CSV file selected.")
