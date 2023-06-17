import pandas as pd
import numpy as np       
import pandas as pd      
import requests          
from bs4 import BeautifulSoup
import json
import datetime

# Define the API endpoint URL
url = 'https://www.wunderground.com/history/daily/us/va/sterling/KIAD/date/2022-1-1'
# Make a GET request to the API endpoint
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Target timeframe
import json
days_in_month = {
#     '01': 31,  # January 
#    '02': 28,  # February
#    '03': 31,  # March
#    '04': 30,  # April
#    '05': 31,  # May
#     '06': 30,  # June
#    '07': 31, # July
#    '08': 31, #August
   '09': 30, #September
   '10': 31, #October
   '11': 30, #Novemeber
   '12': 31 #December
}

url = "https://api.weather.com/v1/location/KIAD:9:US/observations/historical.json?apiKey=e1f10a1e78da46f5b10a1e78da96f525&units=e&startDate=2022{}01&endDate=2022{}{}"
content = []
days_data = []

for month, max_day in days_in_month.items():
    current_url = url.format(month, month, str(max_day))
    response = requests.get(current_url)
    json_object = json.loads(response.content)
    data = response.json()
    observations = data['observations']
  
    for observation in observations:
        temperature = observation['temp']
        precp = observation['precip_hrly']
        pressure = observation ['pressure']
        humidity = observation['rh']
        wx_phrase = observation['wx_phrase']
        wspd= observation['wspd']
        dewpt = observation['dewPt']
        Datetime = observation['valid_time_gmt']
        date_time_str = datetime.datetime.utcfromtimestamp(Datetime).strftime("%y-%m-%d %I:%M:%S %p")
        
        days_data.append({'Date/Time': date_time_str,
                          'Temperature': temperature, 
                          'precp': precp, 
                          'humidity': humidity,
                         'pressure': pressure,
                         'Wind' : wx_phrase,
                         'wspd': wspd,
                          'dewPt': dewpt})

df = pd.DataFrame(days_data)
df.sort_values('Date/Time')

df.to_csv('surfaceWeatherData.csv', index=False)