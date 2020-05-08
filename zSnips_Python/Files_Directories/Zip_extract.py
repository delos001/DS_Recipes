

myzip=zipfile.ZipFile('a2010_1.zip','r') 
myzip.extractall()  # extact zipfile contents to working directory

# read in the table.  since there are multiple data types in some columns, use low_memor=False
accident=pd.read_table('A2010_14.txt',sep='\t',skiprows=None, low_memory=False)
accident=accident.replace("\N",np.nan)  # replace blanks with np.nan
