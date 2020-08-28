## summarize missing values for each column
for i in range(data13.shape[1]):
    n_miss = data13[[i]].isnull().sum()
    per_miss = n_miss / data13.shape[0] * 100
    print('> %d, Missing: %d (%.2f%%)' % (i, n_miss, per_miss))
