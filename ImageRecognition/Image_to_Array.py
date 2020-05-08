

Import Image  # If on 32 bit python


# This is from PILLOW (not python imaging library)
from PIL import Image  # If on 64 bit
import numpy as np


# If you put the script in the same folder as the images, 
# you can just use this.  If not in same folder, you have 
# to specify the full path
i = image.open ('..folder/filename')


# iar is variable stands for image array.  
# this converts the image to an array.  
# Will come out as 3D array (array within an array within an array)
# first dimension = outside dimension
# second dimension = corresponds to each row
# third dimension = corresponds to each pixel in that row 
# (items within that pixel are the red, green, blue, and 
# alpha(fade/transparency) for each pixel)
iar = np.asarray(i)


print (iar)

# oupt of print:
# each number in a row (ie: 255, 255, 255, 255) corresponds to red, 
#     green blue, and alpha values
# note that counting starts at 0 so value of 255 is actually counting 256.  
# so this was saved as 256 color bit image (256*256*256 colors)
# white has all the colors: so a row of 255, 255, 255, 255 is pure white 
#     (has all red, all green, all blue)
# black has no colors: so a row of 0, 0, 0 is black and the last 255 is the 
#     alpha which means its solid black (no transparency)
# each section (starting with second bracket at top left and ending with 2 
#     bracket at bottom right of section) is a row within the image
# There are 8 sections (note: only 2 shown here) and within each section, 
#     there are 8 rows.  Each row per section is a pixel so there are 8 pixels 
#     per section. Therefore: this is an 8x8 image  (8 pixels by 8 pixels)
