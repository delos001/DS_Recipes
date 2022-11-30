
#----------------------------------------------------------
# BASIC EXAMPLE
for file in os.listdir('.'):

     if file.endswith(".json"):

          print(file)


#----------------------------------------------------------
# FULL EXAMPLE
import os

# sets the directory folder to loop
jsonfolder= \
('C:\Users\Jason\OneDrive - QJA\My Files\NW Coursework\Predict 420 DB Systems' \
' and Data Prep\SSCC_files\DE 3 files')

# sets object to identify json files within jsonfolder location
json_files = \
[pos_json for pos_json in os.listdir(jsonfolder) if pos_json.endswith('.json')]

# creates empty dataframe to initialize appending files
hotelinfo = \
pd.DataFrame(columns=['Name','HotelURL','HotelID','Address','Price','ImgURL'])

# sets object to scrub html tags later
ultimate_regexp = \
"(?i)<\/?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)\/?>"

# #loop through each json file, load it, normalize it
for js in json_files:
  # with function ensures it closes after loading
	with open(os.path.join(jsonfolder, js)) as input_file:
		jsondat2=json.load(input_file)  # names loaded file inputfile
		jsonf=json_normalize(jsondat2['HotelInfo'])  # append each new file
		hotelinfo=hotelinfo.append(jsonf, ignore_index=True) 
