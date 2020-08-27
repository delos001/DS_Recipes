
#----------------------------------------------------------
#----------------------------------------------------------
# CSV READER PACKAGE
#----------------------------------------------------------
#----------------------------------------------------------

import csv

#----------------------------------------------------------
# EXAMPLE 1
PassRd = pd.read_csv('2014 CY-YTD Passenger Raw Data_2.csv',
                   thousands=',')


#----------------------------------------------------------
# EXAMPLE 2
mydata = read_csv('C:/Users/Jason/OneDrive - QJA/My Files/NW Coursework' \
                  '/Predict 413 Time Series Analysis' \
                  '/Casestudy/NCHSData52_flu.csv', 
                  parse_dates=[0], 
                  index_col=0, 
                  squeeze=True, 
                  header=0)


#----------------------------------------------------------
#----------------------------------------------------------
# PANDAS
#----------------------------------------------------------
#----------------------------------------------------------

from pandas import Series, DataFrame
import pandas as pd

from pandas import Series, DataFrame
import pandas as pd

dfcust = pd.read_csv('airports.txt') 



#----------------------------------------------------------
# EXAMPLE NAMING COLUMNS ON IMPORT
dfapCol=['AP_ID','AP_Name','AP_City','AP_Country',
         'AP_3IATA_3FFA','AP_4ICAO','Lat','Long',
         'Altitude_ft','Timezone_UTCoffset','DST',
         'TimeZn_Olson']
dfalCol=['AL_ID','AL_Name','AL_Alias','AL_2IATA',
         'AL_3ICAO','AL_CallSign','AL_Country',
         'Active_Y_N']
dfrtCol=['AL_2IATA_3ICAO','AL_ID','SourceAP_3IATA_4ICAO',
         'SourceAP_ID','DestAP_3IATA_4ICAO','DestAP_ID',
         'CodeShare_Y_N','Flight_Stops','Equipment_1 2 3']

dfap=pd.read_csv('airports.txt',names=dfapCol) 
dfal=pd.read_csv('airlines.txt',names=dfalCol)
dfrt=pd.read_csv('routes.txt',names=dfrtCol)

#----------------------------------------------------------
# EXAMPLE IDENTIFYING NA VALUES ON IMPORT
url = 'https://raw.githubusercontent.com/jbrownlee/Datasets/master/horse-colic.csv'
data13 = read_csv(url, header=None, na_values='?')
