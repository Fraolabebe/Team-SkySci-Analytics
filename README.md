# DLNN Contrail Avoidance Model
According to the Intergovernmental Panel on Climate Change (IPCC), human-induced greenhouse gas emissions contribute to 98% of global heating, with contrails accounting for the remaining 2%. Contrails, which persist during both day and night, reflect approximately 33% of the Earth's outgoing thermal radiation back to the surface, disrupting the planet's energy balance. During the day, contrails also reflect incoming solar radiation back into space, resulting in a cooling effect of about 10%.

This project aims to develop a machine learning model to calibrate weather measurement and forecast data, specifically focusing on contrail avoidance. The model will utilize atmospheric data such as temperature, humidity, and altitude/pressure obtained from atmospheric measurements and forecasts. Additionally, it will incorporate sky images to derive information about the presence of contrails.


### Approach:

Training ML Algorithm: We will train a machine learning model, possibly a classification algorithm <bk>
Features: The input features for the model will include atmospheric variables such as temperature, humidity, altitude/pressure, obtained from reliable measurement and forecast sources.
Target Variable: The target variable will represent the presence or absence of contrails in the sky, derived from sky images.
