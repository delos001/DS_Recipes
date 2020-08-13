import json
from pandas import Series, DataFrame
import pandas.io.json
from pandas.io.json import json_normalize
import flatten_json as fs
import pandas as pd
import time

with open('100506.json') as input_file:
    jsondat=json.load(input_file)

#creates empty list to initialize appending files


start1=time.time()
masterlist=[]
jsondf=[]
for i in range(1,100):
    jsonf=json_normalize(jsondat) 
    masterlist.append(jsonf)
jsondf=pd.DataFrame(masterlist)
end1=time.time()
time1=(end1-start1)

start2=time.time()
masterdf=[]
for j in range(1,100):
    jsonf2=json_normalize(jsondat) #normalize json file to df
    jsondf2=pd.DataFrame(jsonf2)
    masterdf.append(jsondf2) #append each new file
end2=time.time()
time2=(end2-start2)

print time1
print time2
print time1-time2