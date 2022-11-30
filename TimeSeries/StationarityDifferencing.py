

#----------------------------------------------------------
# EXAMPLE 1

#  create a differenced series
# function called difference() that calculates a differenced series. 
# Note that the first observation in the series is skipped as there 
# is no prior observation with which to calculate a differenced value
def difference(dataset, interval=1):
    diff = list()
    for i in range(interval, len(dataset)):
        value = dataset[i] - dataset[i - interval]   # alternatively you can use diff()
        diff.append(value)
    return Series(diff)

def inverse_difference(history, yhat, interval=1):  # invert differenced value
return yhat + history[-interval]



#----------------------------------------------------------
# EXAMPLE 2
# FULL EXAMPLE

from pandas import read_csv
from pandas import datetime
from pandas import Series

def difference(dataset, interval=1):
    diff = list()       # create a differenced series
    for i in range(interval, len(dataset)):
        value = dataset[i] - dataset[i - interval]
        diff.append(value)
    return Series(diff)

# # invert differenced value
def inverse_difference(history, yhat, interval=1):
    return yhat + history[-interval]

def parser(x):          # load dataset
    return datetime.strptime('190'+x, '%Y-%m')
series = read_csv('shampoo-sales.csv', header=0, parse_dates=[0], index_col=0, squeeze=True, date_parser=parser)
print(series.head())


# transform to be stationary
differenced = difference(series, 1)
print(differenced.head())



# invert transform
inverted = list()
for i in range(len(differenced)):
    value = inverse_difference(series, differenced[i], len(series)-i)
    inverted.append(value)
inverted = Series(inverted)
print(inverted.head())  # reveresed (note that the first entry in original data is missing
