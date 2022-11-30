
# Simple path------------------------------------------------------------------------
path = "D:\\OneDrive - QJA\\Data_Science\\NLP\\Data\\txt_sentoken\\neg"


# Simple combining path with child path----------------------------------------------
path = "D:\\OneDrive - QJA\\Data_Science\\NLP\\Data\\txt_sentoken\\neg"
pf = path + '\\' + 'cv000_29416.txt'
file = open(pf, 'r')
text = file.read()
file.close()
