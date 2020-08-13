from pandas import Series, DataFrame
import pandas as pd
import numpy as np
import pickle

#determine column names for each file
#align names across files for ease of indexing and joining
#numbers after a header indicate length, ex 3FFA is 3 digit code
dfapCol=['AP_ID','AP_Name','AP_City','AP_Country','AP_3IATA_3FFA','AP_4ICAO',
        'Lat','Long','Altitude_ft','Timezone_UTCoffset','DST','TimeZn_Olson']
dfalCol=['AL_ID','AL_Name','AL_Alias','AL_2IATA','AL_3ICAO','AL_CallSign',
        'AL_Country','Active_Y_N']
dfrtCol=['AL_2IATA_3ICAO','AL_ID','SourceAP_3IATA_4ICAO','SourceAP_ID',
        'DestAP_3IATA_4ICAO','DestAP_ID','CodeShare_Y_N','Flight_Stops',
        'Equipment_1 2 3']

#reads in specified files dfxx=dataframeairport,airine,route file
#(set working directory first else specify file path)
#after reading file, set columns names based on above
dfap=pd.read_csv('airports.txt',names=dfapCol) 
dfal=pd.read_csv('airlines.txt',names=dfalCol)
dfrt=pd.read_csv('routes.txt',names=dfrtCol)

#replace \N values with nan to be recognized during isnull search
dfap.replace("\N",np.nan)
dfal.replace("\N",np.nan)
dfrt.replace("\N",np.nan)

print "First 3 lines of Airport dataframe:"
print dfap[:3] #prints through third line

print ('\nFirst 3 lines of Airline dataframe:') #\n for carriage return
print dfal[:3]

print ('\nFirst 3 lines of Routes dataframe:')
print dfrt[:3]

#below sets variable to represent each dataframe.
#a subset of the columns were set to look for duplicates across those columns
#note dupdfrt has all columns to easily allow 'what-if' duplicate value checks
#instead of using duplicated() command
dupdfap=dfap.duplicated(subset=['AP_Name','AP_City','AP_Country',
        'AP_3IATA_3FFA','AP_4ICAO','Lat','Long','Altitude_ft',
        'Timezone_UTCoffset']).sum()
dupdfal=dfal.duplicated(subset=['AL_Name','AL_Alias','AL_2IATA',
        'AL_3ICAO','AL_Country']).sum()
dupdfrt=dfrt.duplicated(subset=['AL_2IATA_3ICAO','AL_ID',
        'SourceAP_3IATA_4ICAO','SourceAP_ID','DestAP_3IATA_4ICAO','DestAP_ID',
        'CodeShare_Y_N','Flight_Stops','Equipment_1 2 3']).sum()

print('\nAirport Data Duplicate Records:%r')%dupdfap
print('Airline Data Duplicate Records:%r')%dupdfal
print('Route Data Duplicate Records:%r')%dupdfrt

dfapdt=dfap.dtypes #sets object to get dtypes of airport file columns
dfaldt=dfal.dtypes #sets object to get dtypes of airline file columns
dfrtdt=dfrt.dtypes #sets object to get dtypes of route file columns

#prints file name and then column data types for each file
print('\nColumn Data Types for Airport file:\n%r')%dfapdt
print('\nColumn Data Types for Airline file:\n%r')%dfaldt
print('\nColumn Data Types for Routes file:\n%r')%dfrtdt

defunct=dfal.AL_2IATA.isnull().sum()
print('\nDefunct Airline (based on null IATA count):%r')%defunct

noorigin=dfrt.SourceAP_3IATA_4ICAO.isnull().sum()
print('\nRoutes from Nowhere (null IATA/ICAO codes):%r')%noorigin

#Pickle each dataframe saving as OpenFlighxx.pkl'
#dfxx.read_pickle('OpenFlight.pkl') to read back in
dfap.to_pickle('OpenFlightAP.pkl')
dfal.to_pickle('OpenFlightAL.pkl')
dfrt.to_pickle('OpenFlightRT.pkl')


