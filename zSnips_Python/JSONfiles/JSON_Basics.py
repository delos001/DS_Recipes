
#----------------------------------------------------------
#----------------------------------------------------------
# EXPLORE FILE
#----------------------------------------------------------
#----------------------------------------------------------
type(jsondat)   # file type

# tells you the keys in the json file
jsondat.keys() #[u'Reviews', u'HotelInfo']


# unreadable as gives all values of key:values
jsondat.values() 


# tells the type for the key specified: #dict
type(jsondat['HotelInfo']) 
type(jsondat['Reviews']) 

# tells the keys within the key: Keys of HotelInfo dict
jsondat['HotelInfo'].keys()



#----------------------------------------------------------
#----------------------------------------------------------
# BASIC READ AND CONVERT
#----------------------------------------------------------
#----------------------------------------------------------
# read json file into python

read_json  # read json file into pandas

with open('100506.json') as input_file:
jsondat=json.load(input_file)



#----------------------------------------------------------
# create json string to python form

# obj is the object you want to change from json to python
result=json.loads(obj)


#----------------------------------------------------------
# create python to json
	
# result is python object and you are naming json file asjson
asjson=json.dumps(result)

to_json  # create json file when starting form pandas


#----------------------------------------------------------
# convert json object to datafram

# pass a list of JSON objects to data frame constructor and 
# select subset of the data fields
siblings=Data.Frame(result['siblings'],columns=['name','age'])
siblings


#----------------------------------------------------------
#----------------------------------------------------------
# FULL EXAMPLE
#----------------------------------------------------------
#----------------------------------------------------------
import json
from pandas import Series, DataFrame
import pandas.io.json
import flatten_json as fs
import pandas as pd

with open('100506.json') as input_file:
	jsondat=json.load(input_file)

type(jsondat)   # file type

#flatten the "reviews" data from the jsondat file.  
# The json file is in form of dictionary and dictionary of dictionaries 
# so its not a flat file.  its needs to be flattened before it can be 
# put into dataframe
reviewsFlat=[fs.flatten_json(d) for d in jsondat["Reviews"]]
type(reviewsFlat)  # get type after flattening: 'list'

# convert the flattened file to a pandas dataframe
reviewsdf=pd.DataFrame(reviewsFlat)
type(reviewsdf)   # should be: 'pandas.core.frame.DataFrame'

reviewsdf.shape()   # get flattened df specs
reviewsdf.columns()
reviewsdf.head()





#----------------------------------------------------------
