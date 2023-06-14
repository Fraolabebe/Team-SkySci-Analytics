"""
Author: Matthew Lomicka
Date: 06/12/2023
Description: This script reads a CSV file, performs data cleaning and manipulation on the DataFrame,
 including converting the two-digit year to a four-digit format and reordering columns. 
 It then saves the cleaned DataFrame into a new CSV file and provides a success message.
"""
import pandas as pd
import numpy as np

# Read the CSV file into a DataFrame
df = pd.read_csv('SkyConditionData_raw.csv')

# Convert two-digit year to four-digit format
df['Year'] = pd.to_datetime(df['Year'], format='%y')
df['Year'] = df['Year'].apply(lambda x: x.strftime('%Y'))

# Combine 'Day', 'Month', 'Year', and 'Hour' into a single datetime column
# df['Datetime'] = pd.to_datetime(df[['Year', 'Month', 'Day', 'Hour']])

# Reorder the columns with 'Datetime' as the second column
df.insert(1, 'Datetime', pd.to_datetime(df[['Year', 'Month', 'Day', 'Hour']]))
df.drop(['Day', 'Month', 'Year', 'Hour'], axis=1, inplace=True)

# Sort the DataFrame by 'Datetime' in ascending order
df.sort_values('Datetime', inplace=True)

#--------------------------------------------------------------------------------

# Rename the "No Image or Poor Image" column to "Image Present"
df.rename(columns={'No Image or Poor Image': 'Image Present'}, inplace=True)

# Convert values in "Image Present" column
df['Image Present'] = df['Image Present'].replace({1: 0, 0: 1})
df['Image Present'].fillna(1, inplace=True)
# Sort the DataFrame by 'Datetime' in ascending order
df.sort_values('Datetime', inplace=True)
# Reset the index
#df.reset_index(drop=True, inplace=True)

# Create a new CSV file with cleaned data
file_output = 'SkyConditionData_cleaned.csv'
df.to_csv(file_output, index=False)
print(f'{file_output} has successfully been created.')