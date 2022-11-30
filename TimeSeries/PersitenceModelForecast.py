

# https://machinelearningmastery.com/time-series-forecasting-long-short-term-memory-network-python/
# https://machinelearningmastery.com/persistence-time-series-forecasting-with-python/


# A good baseline forecast for a time series with a linear increasing trend 
# is a persistence forecast.

# The persistence forecast is where the observation from the prior time step 
# (t-1) is used to predict the observation at the current time step (t).

# We can implement this by taking the last observation from the training data 
# and history accumulated by walk-forward validation and using that to predict 
# the current time step.


from pandas import read_csv
from pandas import datetime
from sklearn.metrics import mean_squared_error
from math import sqrt
from matplotlib import pyplot

# load dataset
def parser(x):
	return datetime.strptime('190'+x, '%Y-%m')
series = read_csv('shampoo-sales.csv', 
		  header=0, 
		  parse_dates=[0], 
		  index_col=0, 
		  squeeze=True, 
		  date_parser=parser)

# split data into train and test
X = series.values
train, test = X[0:-12], X[-12:]  # update based on size of train and test data set sizes you want.

# walk-forward validation
history = [x for x in train]
predictions = list()
for i in range(len(test)):
	# make prediction
	predictions.append(history[-1])
	# observation
	history.append(test[i])

# report performance
rmse = sqrt(mean_squared_error(test, predictions))
print('RMSE: %.3f' % rmse)

# line plot of observed vs predicted
pyplot.plot(test)
pyplot.plot(predictions)
pyplot.show()
