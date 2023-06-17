import pandas as pd
import requests
from bs4 import BeautifulSoup
import json
import datetime

def get_html_content(url):
    response = requests.get(url)
    return response.text

def extract_weather_data(json_data):
    days_data = []
    
    for observation in json_data['observations']:
        temperature = observation['temp']
        precp = observation['precip_hrly']
        pressure = observation['pressure']
        humidity = observation['rh']
        wx_phrase = observation['wx_phrase']
        wspd = observation['wspd']
        dewpt = observation['dewPt']
        Datetime = observation['valid_time_gmt']
        date_time_str = datetime.datetime.utcfromtimestamp(Datetime).strftime("%y-%m-%d %I:%M:%S %p")
        
        days_data.append({'Date/Time': date_time_str,
                          'Temperature': temperature, 
                          'precp': precp, 
                          'humidity': humidity,
                          'pressure': pressure,
                          'Wind': wx_phrase,
                          'wspd': wspd,
                          'dewPt': dewpt})
    
    return days_data

def retrieve_weather_data(url):
    content = get_html_content(url)
    json_data = json.loads(content)
    return extract_weather_data(json_data)

def save_data_to_csv(data, filename):
    df = pd.DataFrame(data)
    df.sort_values('Date/Time', inplace=True)
    df.to_csv(filename, index=False)

def main():
    base_url = "https://api.weather.com/v1/location/KIAD:9:US/observations/historical.json"
    api_key = "e1f10a1e78da46f5b10a1e78da96f525"
    
    days_in_month = {
        '09': 30,  # September
        '10': 31,  # October
        '11': 30,  # November
        '12': 31   # December
    }
    
    data = []
    
    for month, max_day in days_in_month.items():
        start_date = f"2022{month}01"
        end_date = f"2022{month}{max_day}"
        url = f"{base_url}?apiKey={api_key}&units=e&startDate={start_date}&endDate={end_date}"
        
        month_data = retrieve_weather_data(url)
        data.extend(month_data)
    
    fn = 'surfaceWeatherData.csv'
    print(f"Saving {fn}")
    save_data_to_csv(data, fn)

if __name__ == '__main__':
    print("Ground Weather Data Extraction Activated")
    main()
    print("Ground Weather Data Extraction Concluded")
