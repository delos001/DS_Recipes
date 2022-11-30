


def DF2DF():      #initialize the list to hold the dictionaries 
	masterdf=pd.DataFrame()  #create the loop remember 0 
	for x in range(99):
		with open('d:/DEWk8/100506.json') as input_file: jsondat=json.load(input_file)
		jsondat_flat = json_normalize(jsondat)    # flatten it
		masterdf2=pd.DataFrame(jsondat_flat)      # save it to a dataframe
		data.append(masterdf2)                    # add to the list
timetorun2=timeit.timeit(DF2DF, number = 2000)  # run the timer
print ('The amount of time to run it is:')
print (timetorun2)
print ('---E--N--D---')
