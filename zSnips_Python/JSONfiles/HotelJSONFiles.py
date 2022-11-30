import json
from pandas import Series, DataFrame
import pandas.io.json
from pandas.io.json import json_normalize
import flatten_json as fs
import pandas as pd
import os
import glob
import re
import numpy
import shelve

#Part 1---------------------------------------------------------------------
#read the 100506.json file into canvas and name jsondat
with open('100506.json') as input_file:
    jsondat=json.load(input_file)

type(jsondat)  #tells you its a dictionary

#flatten the "reviews" data from the jsondat file
reviewsFlat=[fs.flatten_json(d) for d in jsondat["Reviews"]]

type(reviewsFlat)  #get type after flattening: 'list'

reviewsdf=pd.DataFrame(reviewsFlat)
type(reviewsdf) #get type after df conversion: 'pandas.core.frame.DataFrame'

#get flattened df specs
reviewsdf.shape
reviewsdf.columns
reviewsdf.head()

#create a new dataframe from previous that drops columns I don't want based
#on collist object and creates copy with the columns I want
collist=[1,2,13,14]  #sets object to contain column indexes I don't want
ratingsdf=reviewsdf.drop(reviewsdf.columns[collist],1)

#review new df to ensure correct columns are present
ratingsdf.columns

#convert columns to numeric.  below will review entire df and convert columns
#that can be converted and leave rest alone
ratings_numdf=ratingsdf.apply(lambda x: pd.to_numeric(x, errors='ignore'))

#get descriptive statistics for each rating value
#the statistic for each column (index 2 through last column [2:]) is obtained
stdf=pd.DataFrame(columns=['Mean','Min','Max']) #create empty df
stdf['Mean']=ratings_numdf[ratings_numdf.columns[2:]].mean() #get mean
stdf['Mean']=stdf['Mean'].round(2) #round mean value to 2 decimal places
stdf['Min']=ratings_numdf[ratings_numdf.columns[2:]].min() #get min
stdf['Max']=ratings_numdf[ratings_numdf.columns[2:]].max() #get max
stdf  #print resulting dataframe with all three statistic value columns

#create shelf of stdf data frame
ratings=stdf
ratingdb=shelve.open('mystats')
ratingdb['RatingCol']=ratings
ratingdb.close()

#copy the Author, Date, and Contents column into a new dataframe
commentsdf = reviewsdf[['Author','Date','Content']].copy()
commentsdf = commentsdf.set_index(['Author']) #index df by author
commentsdf.head()  #confirm new df has correct information within
commentsdf.to_csv('commentscsvfile')

#create shelf of commentsdf data frame
comments=commentsdf
commentsdb=shelve.open('hotcomments')
commentsdb['Author']=comments
commentsdb.close()

#------------------------------------------------------------------------------
#Part 2
#json file location
jsonfolder= \
('C:\Users\Jason\OneDrive - QJA\My Files\NW Coursework\Predict 420 DB Systems' \
' and Data Prep\SSCC_files\DE 3 files')

#sets object to identify json files within jsonfolder location
json_files = \
    [pos_json for pos_json in os.listdir(jsonfolder) if pos_json.endswith('.json')]

#creates empty dataframe to initialize appending files
hotelinfo = \
pd.DataFrame(columns=['Name','HotelURL','HotelID','Address','Price','ImgURL'])

#sets object to scrub html tags later
ultimate_regexp = \
"(?i)<\/?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)\/?>"

#loop through each json file, load it, normalize it, 
for js in json_files:
    with open(os.path.join(jsonfolder, js)) as input_file:
        jsondat2=json.load(input_file)
    jsonf=json_normalize(jsondat2['HotelInfo']) #normalize json file to df
    hotelinfo=hotelinfo.append(jsonf, ignore_index=True) #append each new file

#remove html, miscelaneous characters and the entries in HotelURL that don't
#have an actual URL (3rd line below)
hotelinfo['Address']=hotelinfo['Address'].str.replace(ultimate_regexp,"")
hotelinfo['Address']=hotelinfo['Address'].str.replace('c/',"")
hotelinfo['HotelURL']=hotelinfo['HotelURL'].str.replace('/S.+',"")#delete nonURL

hotelinfo #print result

#save hotelinfo dataframe on a shelf for use later
hotelshelf=hotelinfo
hotelshelfdb=shelve.open('hotelinformation')
hotelshelfdb['hoteldata']=hotelshelf
hotelshelfdb.close()