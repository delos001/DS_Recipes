

#----------------------------------------------------------
# GREY SCALE
#convert all test images in the combined data frame to gray scale npy array

arr_images_tst_gr = []        

for image in tst1_im_loc["imagepath"]:
    arr_images_tst_gr.append(cv2.imread(image, cv2.IMREAD_GRAYSCALE))


#----------------------------------------------------------
# RBG SCALE
#convert all test images in the combined data frame to rbg scale npy array

arr_images_tst_rbg = []        

for image in tst1_im_loc["imagepath"]:
    arr_images_tst_rbg.append(cv2.imread(image, cv2.COLOR_BGR2RGB))
