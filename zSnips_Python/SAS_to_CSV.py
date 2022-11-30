import pandas as pd, os

dir = os.path.dirname(os.path.realpath(__file__))

for root, dirs, files in os.walk(os.path.join(dir,"SAS")):
	for file in files:
		if file.endswith('.sas7bdat'):
                        try:
                                pd.read_sas(os.path.join(dir,"SAS",file), format='sas7bdat', encoding='ISO-8859-1').to_csv(os.path.join(dir,"CSV",os.path.splitext(file)[0]+".csv"), index=False, header=True)
                                print("converted "+file)
                        except:
                                print("skipped "+file+" - no data")
                                pass
print("**operation complete**")
