
# generate a 10x5 data frame of random numbers
import pandas as pd
import numpy as np

df = pd.DataFrame(np.random.randn(10, 5))
df

#############################################################
# Generate 50 random numbers for x and for y, then plot

%matplotlib inline
import numpy as np
import matplotlib.pyplot as plt

n=50
x=np.random.rand(n)
y=np.random.rand(n)
colors=np.random.rand(n)
area=np.pi*(15*np.random.rand(n))**2
plt.scatter(x,y, s=area, c=colors, alpha=0.5)
plt.show()


#----------------------------------------------------------
# EXAMPLES
# https://machinelearningmastery.com/how-to-generate-random-numbers-in-python/
randomNum = random.random()
randomNum = random.random(1,4)
randonNum = random.randint(1,4)
