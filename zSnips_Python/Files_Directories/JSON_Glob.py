
#----------------------------------------------------------
# EXAMPLE 1
# will print list of all .json files in the directory specified 
# (working directory if not specified)

import os
import glob
glob.glob('*.json')


#----------------------------------------------------------
# EXAMPLE 2
for file in glob.glob("*.json"):
     print(file)


#----------------------------------------------------------
# EXAMPLE 3
# you can use 'glob' to pull your filenames like 'os'
jsonGlob = glob.glob('/users/cberryma/Desktop/*.json')

# print your json file names but it will output with your filepath 
# in addition to filename
print(jsonGlob)


#----------------------------------------------------------
# EXAMPLE 4
# function for taking combining all files within a folder
import os
import glob


def concatenate(indir="D:/GrEx3/", outfile="d:/GrEx3_alljsondata.txt"):

    os.chdir(indir)
    # choose only those files ending with json
    fileList = glob.glob("*.json")
    
    # create a dataframe based on specific items within the files
    dfList=[]

    hotelcolnames=pd.DataFrame(columns=['Name', 'HotelID', 
                                        'HotelURL', 'Location', 
                                        'Address', 'Price', 
                                        'ImgURL' ])

