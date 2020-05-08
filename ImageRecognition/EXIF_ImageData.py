
# remove corrupt exif data for local files

# remove corrupt exif data for local files
import piexif  

#l ocal directory parent folder containing the training folders: type_1, type_2, type_3
# sets path for each set of pictures
tr1_dir_loc = 'C:\\Users\\Jason\Desktop\\Cervix\\train\\Type_1'
tr2_dir_loc = 'C:\\Users\\Jason\Desktop\\Cervix\\train\\Type_2'
tr3_dir_loc = 'C:\\Users\\Jason\Desktop\\Cervix\\train\\Type_3'

# local directory parent folder containing the test files
# path for test pictures
tst_dir_loc = 'C:\\Users\\Jason\\Desktop\\Cervix\\test'


# files for each training type (1,2,3)
# gets file list for each path (above)
tr1_f_loc = [os.path.join(tr1_dir_loc, f) for f in os.listdir(tr1_dir_loc)]
tr2_f_loc = [os.path.join(tr2_dir_loc, f) for f in os.listdir(tr2_dir_loc)]
tr3_f_loc = [os.path.join(tr3_dir_loc, f) for f in os.listdir(tr3_dir_loc)]

# test image directory
# get file list for test images
tst_1_f_loc = [os.path.join(tst_dir_loc, f) for f in os.listdir(tst_dir_loc)]

# remove corrupt exif data
for f in tr1_f_loc:
    piexif.remove(f)

for f in tr2_f_loc:
    piexif.remove(f)
    
for f in tr3_f_loc:
    piexif.remove(f)
    
for f in tst_1_f_loc:
    piexif.remove(f)
