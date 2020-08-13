from pandas import Series, DataFrame
import pandas as pd
import numpy as np
import csv
import zipfile
from numpy import loadtxt

#read the passenger raw data file and indicate that there are commas used
#for the numbers in the thousands-allows it to be read in as integer rather 
#than object
PassRd=pd.read_csv('2014 CY-YTD Passenger Raw Data_2.csv',thousands=',')

#review in input file for column and row numbers, and first 3 row values
PassRd.shape
PassRd.columns
PassRd.head(3)

dfPassRd=pd.DataFrame(PassRd)

#review the df for headers, column names, and column data types
dfPassRd.head(3)
dfPassRd.columns
dfPassRd.dtypes

print ('Duplicate Row Count: '), dfPassRd.duplicated().sum()

#Part1
usap=('ABQ|BOI|BUF|CMH|SEA|TPA') #set variable to equal US airport codes

#sum the number of US airports that had departures in 2014
sum(dfPassRd['OriginApt'].str.contains(usap))
d=dfPassRd.loc[dfPassRd['OriginApt'].str.contains(usap),'Total'].sum()
print ('Total Departures for US Airports: %r')%d
e = dfPassRd[dfPassRd['OriginApt'].str.contains(usap)]
f=e.groupby(['OriginApt'],as_index=False)['Total'].sum()
print ('Departures by US Airports: \n %r')%f

#sum the number of US airports that had arrivals in 2014
sum(dfPassRd['DestApt'].str.contains(usap))
a=dfPassRd.loc[dfPassRd['DestApt'].str.contains(usap),'Total'].sum()
print ('Total Passenger Arrivals for US Airports: %r')%a

#add total passengers for each group of airport by carrier
#create vector with only US airport codes
#get the carrier that has the most passengers for each origination airport
USOr = dfPassRd[dfPassRd['OriginApt'].str.contains(usap)]
sUSOr=USOr.groupby(['OriginApt','Carrier'],as_index=False)['Total'].sum()
if sUSOr.empty:
    print ('Carrier with most passengers arriving in US Airports: 0')
else:
    print ('Carrier with most passengers leaving US Airports:')
    print sUSOr.iloc[sUSOr.groupby(['OriginApt']).
        apply(lambda x: x['Total'].idxmax())]

#add total passengers for each group of airport by carrier
#create vector with only US airport codes
#get the carrier that has the most passengers for each destination airport
USDes = dfPassRd[dfPassRd['DestApt'].str.contains(usap)]
sUSDes=USDes.groupby(['DestApt','Carrier'],as_index=False)['Total'].sum()
if sUSDes.empty:
    print ('Carrier with most passengers arriving in US Airports: 0')
else:
    print ('Carrier with most passengers arriving in US Airports:')
    print sUSDes.iloc[sUSDes.groupby(['DestApt']).
            apply(lambda x: x['Total'].idxmax())]

#Part2
#for each US airport, find destination airport where largest # of passengers 
#went first group USOr dataframe by Origin Airport and Destination airport and 
#sum the number of passengers per group
#then group the summed groups by Origin Airport and get the max number of 
#passengers per group
sUSOr_Des=USOr.groupby(['OriginApt','DestApt'],as_index=False)['Total'].sum()
if sUSOr_Des.empty:
    print ('Airport with largest arrival volume from US airports: 0')
else:
    print ('Airport with largest US airporst destination volume:')
    print sUSOr_Des.iloc[sUSOr_Des.groupby(['OriginApt']).
            apply(lambda x: x['Total'].idxmax())]

#opposite as above: find which aiport sent the greatest number of passengers
#to each of the US airports
#note this is expected to return empty since there are no US destinations
sUSDes_Or=USDes.groupby(['DestApt','OriginApt'],as_index=False)['Total'].sum()
if sUSDes_Or.empty:
    print ('Airport with largest US airporst destination volume: 0')
else:
    print ('Airport with largest US airporst destination volume:')
    print sUSDes_Or.iloc[sUSDes_Or.groupby(['DestApt']).
            apply(lambda x: x['Total'].idxmax())]

#Part3
myzip=zipfile.ZipFile('a2010_14.zip','r') #identify the zip file
myzip.extractall() #extact zipfile contents to working directory

#read in the table
#since there are multiple data types in some columns, use low_memor=False
accident=pd.read_table('A2010_14.txt',sep='\t',skiprows=None,header='infer', 
    low_memory=False)
accident=accident.replace("\N",np.nan) #replace blanks with np.nan

accident.shape
accident.columns
accident.head(2) 
print ('Duplicate Row Count: '), accident.duplicated().sum()

accident['c6'].value_counts()
accident['c6'].isnull().sum()
accident['c6'].dtypes
pd.to_numeric(accident['c6'], errors='ignore')

#value_counts() shows that there are 122 rows without years.  The txt file
#is not structured consistently.  It contains text data not structured in cells
#A new dataframe is created to remove the unstructured text data
#data in c5 is the incident/accident code.  Any data that is null or doesn't
#begin with a year code is removed as non useful data
#rows that contain a year value from 2010 to 2014.  However it is also noted
#from the value_counts() function that this file does not contain 2014 data

accidFix=accident.dropna(subset=['c5']) #NA values dropped 
accidFix=accidFix.loc[accidFix['c5'].str.startswith('2')]
accidFix['c6'].value_counts() #recheck new dataframe
accidFix.shape

#group by US Airport code and count occurrences where there is a value in C1
#which is the 'type of event'.  An incident is considered to have occurred if
#the event has been classified as either accident or incident
#NOTE: from GrEx1, BUF airport is also coded with a K so these iterations were 
# included in the grouping
m=accidFix[accidFix['c143'].isin(
    ['ABQ ','KABQ','BOI ','KBOI','BUF ','KBUF','CMH ','KCMH',
    'SEA ','KSEA','TPA ','KTPA'])]

#n=group by US Airport code counting the number of events in c1

n=m.groupby(['c143'],as_index=False)['c1'].count()
#replace the Ks for any Aiport codes to group like airport codes together
n['c143']=n['c143'].str.replace('K',"")
n['c143']=n['c143'].str.replace(' ',"")
n=n.groupby(['c143'],as_index=False)['c1'].sum()
n.columns=['US Airport','Incident Count']
print('US Airport Total Incident Count:')
n

#o=sum the accidents C76, and deaths c250 for each group
o=m.groupby(['c143'],as_index=False)['c76','c250'].sum()
#replace the Ks for any Aiport codes to group like airport codes together
o['c143']=o['c143'].str.replace('K',"")
o['c143']=o['c143'].str.replace(' ',"")
#re-group after the codes have been normalized by removing the Ks
o=o.groupby(['c143'],as_index=False)['c76','c250'].sum()
o.columns=['US Airport','Total Fatalities','All Injuries']
print('US Airport Fatalities and Injury Count:')
o

#Part4
dcause=accidFix[accidFix['c76']>0]
u=dcause['c78'].value_counts()
u=pd.DataFrame(u, index=None)
u.index.name='Incident Code'
u.columns=['Incident Count']
print('Top 10 Incident Volume by Incident Code')
u.head(10)
print('Correct incident Codes are not available from the AIDCODE.DOC file. Codes found\
in AIDCODES.doc file are two character codes while codes found in A2010_14.txt \
are two digit codes.  A file on\
http://av-info.faa.gov/dd_sublevel.asp?Folder=\AID provides the following \
information in the file named10-14-2010 Attention:')
print('Modifications to the Accident/Incident database have resulted in a \
number of data fields being discontinued while other data fields have been \
added. All publicly available data is contained in the files below.  We are \
reviewing and adjusting the file structure documentation to reflect the current \
data fields in use. When completed, we will publish these updated reference\
files on this website.')
print('Therefore no code descriptions are available for this analysis.')
