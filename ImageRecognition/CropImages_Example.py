

# CROP FILES USING DIMENSIONS (75, 80, 525, 530): these produce square image
# and are based on visual review of images with cervix located in most extreme
# area of the field

from PIL import Image, ImageFile
import os, sys -already loaded above
ImageFile.LOAD_TRUNCATED_IMAGES = True


# use the below to test 1 image
# img = Image.open("C:\\Users\\Jason\\Desktop\\Cervix\\632res.jpg")
# #crop(left: x, y, right:x, y)
# img2 = img.crop((75, 80, 525, 530))
# img2.save("C:\\Users\\Jason\\Desktop\\Cervix\\img2.jpg")

path1 = "C:\\Users\\Jason\\Desktop\\Cervix\\train\\Type_1\\"
dirs = os.listdir( path1 )

def crop():
    for item in dirs:
        fullpath = os.path.join(path1,item)         #corrected
        if os.path.isfile(fullpath):
            im = Image.open(fullpath)
            f, e = os.path.splitext(fullpath)
            imCrop = im.crop((75, 90, 525, 510)) #corrected
            imCrop.save(f + 'Cropped.jpg', "JPEG", quality=100)

crop()
