


# let's get some descriptive stats
df.describe()

df.Age.describe()

df2 = df.groupby('Sex')
df2.Age.describe()



df.Age.hist()

df2.get_group('male').Age.hist()
df2.get_group('female').Age.hist()


df.Age.quantile([.10, .9])
