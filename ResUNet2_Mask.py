import sys
import time
import os
import cv2
import numpy as np
import math
from keras.models import Model
from keras.models import load_model
from keras.layers import Input, concatenate, Conv2D, MaxPooling2D, Activation, UpSampling2D, BatchNormalization
#from keras.optimizers import RMSprop
from keras.callbacks import ModelCheckpoint, LearningRateScheduler
from keras.losses import binary_crossentropy
import keras.backend as K
import glob
from skimage import data
from skimage.transform import resize
# import array as arr

smooth = 1

def dice_coeff(y_true, y_pred):
    smooth = 1.
    y_true_f = K.flatten(y_true)
    y_pred_f = K.flatten(y_pred)
    intersection = K.sum(y_true_f * y_pred_f)
    score = (2. * intersection + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth)
    return score

def dice_loss(y_true, y_pred):
    loss = 1 - dice_coeff(y_true, y_pred)
    return loss

def Load_ImagesC(Loc):
    Images = []
    for root, dirs, files in os.walk(Loc):
        for file in files:
            Image = cv2.imread(os.path.join(root, file),1)
            Image = cv2.resize(Image, (256,256))
            Images.append(Image)
    Images = np.asarray(Images)
    return Images

def Load_Images(Loc):
    Images = []
    for root, dirs, files in os.walk(Loc):
        for file in files:
            Image = cv2.imread(os.path.join(root, file),0)
            Image = cv2.resize(Image, (256,256))
            Images.append(Image/255.0)
    Images = np.asarray(Images)
    return Images
#C:\Users\Kiran\Downloads\KiranUPMCAMD\AMD_12x12_500_IMG_ANG_PTEly_OD
# AMD_IMG_12x12_PTDcn_OD   AMD_12x12_500_IMG_ANG_PTEly_OD


def Load_FileNames(Loc):
    fileNames = []
    for root, dirs, files in os.walk(Loc):
        for file in files:
            fileNames.append(file)
    return fileNames

inpImg = sys.argv[1];
# print(inpImg)
h5Path = sys.argv[2];
oDir = sys.argv[3];
# ptrn = np.asarray(sys.argv[4]);
fnames =  Load_FileNames(inpImg)
# print(ptrn)
ty = sys.argv[4]
# print(ty)
# rnos0 = sys.argv[6];
# print(rnos0)
# rnos = list(np.array(rnos0, dtype=int))
# # rnos = [eval(i) for i in rnos0]
# # rnos = sys.argv[6];
# # rnos = int(float(sys.argv[5].split(' ')))
# print(rnos)
# print(h5f);
# x_test = Load_Images("D:/Choroid/Data/WideField_Datasets/Amrish_New/Angio_Pt11_20200615_OD_12x12/Org")
# x_testC = Load_ImagesC("D:/Choroid/Data/WideField_Datasets/Amrish_New/Angio_Pt11_20200615_OD_12x12/Org")
x_test =  Load_Images(inpImg)
x_testC = Load_ImagesC(inpImg)
# strcat(h5f,'/',mname)
# numbers_list = [2, 5, 62, 5, 42, 52, 48, 5]
# numbers_array = arr.array('i', numbers_list)
if ty == "multi":
    rnos = [55,63,67,70,77,80,85,90,95,97]
    # rnos = [50, 70, 90]
#     , 70, 80, 90]
    # rnos = [70, 34, 28, 45, 20, 79, 66, 30, 88, 99]
#     rnos_array = np.array('i', rnos)
    rnos_array = np.asarray(rnos)
#     rnos_array = arr.array('i', rnos)
else:
    rnos = [89]
    rnos_array = np.asarray(rnos)

# print(rnos)
# print(rnos_array)

for ii in range(len(rnos_array)): 
    h5f = h5Path+'weights-improvement-'+str(rnos_array[ii])+'.hdf5'
    outDir = oDir+'weights-improvement-'+str(rnos_array[ii])+'_IP/'
    os.makedirs(outDir) 
#     print("Directory '% s' created" % directory) 
    # for i0 in range(len(argv[2])):
    print(h5f);
    model = load_model(h5f, custom_objects={'dice_loss':dice_loss,'dice_coeff': dice_coeff})
    print('111111')
    start_time = time.time()
    print("--- %s seconds ---" % start_time)
    
    
#     outDir = sys.argv[3];
    #X_Test = np.load("imgs_mask_test.npy")
    for i in range(len(x_test)):
        xtest_temp = x_test[i,:,:]
        x_test2 = xtest_temp.reshape(1,256,256,1)
        y = model.predict(x_test2, verbose=1)
        print('success!!!')
        #plt.hist(y(:))
        #sio.savemat(outDir+'/mask_'+str(i)+'.mat', y)
        y = y*255
        y = y.reshape(256,256)
        img1 = x_testC[i,:,:,:]
        #mask = y>100
        img = np.uint8(img1)
        #img[mask] = 255
        #y[mask] = 255
        #cv2.imwrite('DATA_Processed/New/Jay/PCZMI1121544606_Cube/PRE_1269_Y_100/outDeep256_'+str(i)+'.jpg',img)
        print('Processing----File---'+str(i+1)+'.jpg') 
#         print(outDir)
#         print(ptrn(i+1)+'.jpg')
        cv2.imwrite(outDir+fnames[i], y)
#         +str(i+1).zfill(4)+'.jpg'
        #cv2.imwrite(outDir+'image'+str(i+1).zfill(4)+'.jpg',img)
        print("--- %s seconds ---" % (time.time() - start_time))
        #sio.savemat('C:\Users\Kiran\Downloads\9_R_PCZMI803735871\08-Sep-2021\mask_08-Sep-2021-7-5\testmat.mat', y)
