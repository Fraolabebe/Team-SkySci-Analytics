# Metadata Merge Transform
This script is designed to merge weather data and image metadata based on their corresponding datetime attributes. The merged dataset created by this script aims to facilitate predictive classifier analytics in machine learning applications.

### Purpose:
The purpose of this script is to combine two distinct datasets: weather data and image metadata. By leveraging the datetime attributes present in both datasets, the script merges the information in a unified dataset. This merged dataset can then be used as input for predictive classifier analytics, enabling more comprehensive and accurate predictions.

### Requirements:
To successfully run this script, ensure that the following requirements are met:

    Python 3.x is installed on your system.
    The required Python libraries (e.g., pandas, NumPy) are installed. You can install them using the provided requirements.txt file by running pip install -r requirements.txt in your terminal.

### Usage:

    Prepare the datasets:
        Ensure that the weather data and image metadata are in a compatible format, such as CSV or Excel.
        Make sure that both datasets contain a datetime attribute that can be used for merging.
    Place the weather data and image metadata files in the same directory as the script.
    Open the script file (merge_data.py) and modify the following variables at the beginning of the script to match your dataset:
        weather_data_file: The filename of the weather data file.
        image_metadata_file: The filename of the image metadata file.
        datetime_column: The name of the datetime attribute column in both datasets.
    Run the script by executing python merge_data.py in your terminal.
    The script will merge the datasets based on the datetime attribute and generate a new dataset called merged_data.csv in the same directory.

### Output:
After running the script, a new file called merged_data.csv will be created, containing the merged dataset. This file can be used as input for predictive classifier analytics or further preprocessing steps in your machine learning workflow.

### Limitations and Considerations:

    Ensure that the datetime attributes in both datasets are formatted consistently for successful merging.
    The script assumes that the datetime attributes are compatible and represent the same timezone or are appropriately adjusted.
    It is recommended to review and clean the merged dataset for any missing or inconsistent data before using it for predictive classifier analytics.

### Disclaimer:
This script is provided as-is without any warranty. It is the responsibility of the user to review, modify, and test the script according to their specific requirements and datasets.

### License:
This script is released under the MIT License.