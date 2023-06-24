import os
import re
from datetime import datetime, timedelta

# Define the start and end dates for validation
start_date = '20220901'
end_date = '20221222'

# Compile a regular expression pattern to match the date format
date_pattern = re.compile(r'\d{8}')

# Iterate over each date within the specified range
current_date = start_date
while current_date <= end_date:
    # Initialize a counter for the current date
    count = 0
    
    # Iterate over each file in the current directory
    for filename in os.listdir():
        # Check if the file is a CSV file
        if filename.endswith('.csv'):
            # Extract the date portion from the filename
            date_match = date_pattern.search(filename)
            if date_match:
                date = date_match.group()
                # Check if the date matches the current date
                if date == current_date:
                    count += 1
    
    # Print the number of CSV files for the current date
    print(f"{current_date}: {count} CSV files")
    
    # Increment the current date
    current_date = (datetime.strptime(current_date, '%Y%m%d') + timedelta(days=1)).strftime('%Y%m%d')

