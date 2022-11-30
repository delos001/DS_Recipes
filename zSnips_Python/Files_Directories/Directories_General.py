
#----------------------------------------------------------
# DEFINE PATH WITH VARIABLE

# full path
im_dir = ('D:\\OneDrive - QJA\\My Files\\NW Coursework'
          '\\Predict 454 Advanced Modelling\\Final Data')

# when the code is in the same parent file as where you want to look, 
# you can use double period then the parent folder and then the child folders
tr_dir ='..\\Final Data\\train'
tst_dir = '..\\Final Data\\test'



#----------------------------------------------------------
# GLOB EXAMPLE 1
import glob

# specify the directory  (note use of double back slashes since 
# Python recognized \N as the return function
tr_dir = ('C:\\Users\\Jason\\OneDrive - QJA\\My Files\\NW Coursework' /
          '\\Predict 454 Advanced Modelling\\Final Data\\train')

# this gives you the files in the directory specified (not needed 
# here but put in as an example)
tr_im = os.listdir(tr_dir)

# or path in specified path, look through each subfolder (recursive = True) 
# and create a list of all the files 
for path in sorted(glob.glob(tr_dir + '\\**', 
                             recursive=TRUE)):
print (path)

                   
                   
#----------------------------------------------------------
# GLOB EXAMPLE 2                   
tr_cervix_im = []

# this loops through each path/file and seaparates them based on the last \\ 
# for each fow (--> [-1] means start from right).  Recursive tells glob to go 
# through each child folder.
for path in sorted(glob.glob(tr_dir + '\\**', recursive=True)):
  cerv_type = path.split("\\")[-1]
  cerv_im = sorted(glob.glob(tr_dir + cerv_type + '\\**', 
                             recursive=True))
  tr_cervix_im = tr_cervix_im + cerv_im

      
#----------------------------------------------------------
# ANOTHER EXAMPLE 2    
#g et path for all files in the Type1 folder, then split to see file type and cervix type
t1_files = [os.path.join(tr_t1, f) for f in os.listdir(tr_t1)]
t1_images = pd.DataFrame({"imagepath": t1_files})
t1_images["filetype"] = t1_images.apply(lambda row: row.imagepath.split(".")[-1], axis=1)
t1_images["type"] = t1_images.apply(lambda row: row.imagepath.split("\\")[-2], axis=1)
t1_images.head()
        
