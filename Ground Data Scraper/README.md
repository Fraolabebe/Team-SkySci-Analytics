# Ground Weather Data Extraction

This Python script retrieves historical weather data from the Weather Company API and saves it to a CSV file. It extracts various weather parameters such as temperature, precipitation, pressure, humidity, wind speed, and dew point for a specified location and time range.

## Prerequisites
Before running the scraper, ensure you have the following prerequisites:

- Python 3.10.2
- pandas library (`pip install pandas`)
- requests library (`pip install requests`)
- BeautifulSoup library (`pip install beautifulsoup4`)

## Usage

1. Clone the repository or download the script file to your local machine.
2. Install the required libraries mentioned in the prerequisites.
3. Open the script file in a text editor or an integrated development environment (IDE).
4. Locate the following variables at the beginning of the script:

   ```python
   base_url = "https://api.weather.com/v1/location/KIAD:9:US/observations/historical.json"
   api_key = "e1f10a1e78da46f5b10a1e78da96f525"
   ```
5. Save the changes in the script file.
6. Open a terminal or command prompt and navigate to the directory containing the script file.
7. Run the script using the following command:
```python script.py```
8. The script will start retrieving the weather data for each month specified in the days_in_month dictionary.
9. After the data retrieval is complete, it will be saved to a CSV file named surfaceWeatherData.csv in the same directory.

## Notes

- The script retrieves historical weather data for the months of September, October, November, and December by default. You can modify the days_in_month dictionary in the script to include or exclude specific months.
- The script assumes that the API response contains weather data in JSON format with the specified keys (temp, precip_hrly, pressure, rh, wx_phrase, wspd, dewPt, valid_time_gmt).
- The retrieved data is sorted by the "Date/Time" column in ascending order before saving it to the CSV file.