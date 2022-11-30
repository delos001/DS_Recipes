
# Get stats of columns in a table and place in df
import pandas as pd

stdf=pd.DataFrame(columns=['Mean','Min','Max']) 

#the statistic for col 2 through last column [2:]) is obtained
# ratings_numdf is the table
stdf['Mean']=ratings_numdf[ratings_numdf.columns[2:]].mean() 
stdf['Mean']=stdf['Mean'].round(2) 
stdf['Min']=ratings_numdf[ratings_numdf.columns[2:]].min() 
stdf['Max']=ratings_numdf[ratings_numdf.columns[2:]].max() 
stdf 
