#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 11 15:07:57 2019

@author: k1758331
"""
import os
os.chdir('/Users/jennie/Documents/urban informatics/Mining/cw2/data/img')

#!pip install scikit-image
from skimage import io, color, measure, feature
import skimage.filters as filters
import matplotlib.pyplot as plt
import cv2
import numpy as np
from skimage.transform import hough_circle, hough_circle_peaks
from skimage.feature import canny
from skimage.draw import circle_perimeter
#import math
from skimage.transform import (hough_line, probabilistic_hough_line)
#from matplotlib import cm

#Set up the thresholds for hsv colours
#yellow
lower_yel = np.array([80, 100, 100], dtype=np.uint8)
upper_yel = np.array([100, 255, 255], dtype=np.uint8)

#blue
lower_blu = np.array([20,50,50], dtype=np.uint8)
upper_blu = np.array([45,255,255], dtype=np.uint8)

#green
lower_gre = np.array([45, 100, 50], dtype=np.uint8)
upper_gre = np.array([75, 255, 255], dtype=np.uint8)

# white - use the grayscale image and adjust the threshold for each image

#orange
lower_ora = np.array([107, 100, 100],dtype=np.uint8)
upper_ora = np.array([120, 255, 255],dtype=np.uint8)


img1 = io.imread("rgbh0000.bmp")
io.imshow("rgbh0000.bmp")
print("Original image 1: rgbh0000.bmp")
io.show()
gray1 = color.rgb2gray(img1)
io.imshow(gray1)
print("Grayscale:")
io.show()

threshold = filters.threshold_otsu( gray1 )
print ('Otsu method threshold = ', threshold)
binary_img1 = gray1 > threshold
print("Black & White:")
io.imshow(binary_img1)
io.show()

edge1 = canny(gray1, sigma=0.01,
              low_threshold=0.10, high_threshold=0.25)
io.imshow(edge1)
print("Edges:")
io.show()

contours = measure.find_contours(edge1, 0.2)
print("Contours:")
fig, ax = plt.subplots()
ax.imshow(edge1, interpolation='nearest', cmap=plt.cm.gray)

for n, contour in enumerate(contours):
    ax.plot(contour[:, 1], contour[:, 0], linewidth=2)

ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()

print("Colour detection:")
 
blur1 = cv2.GaussianBlur(img1,(3, 3),0.5)


imgHSV= cv2.cvtColor(blur1,cv2.COLOR_BGR2HSV)

#yellow, blue, green, white & orange
print("Yellow:")
mask=cv2.inRange(imgHSV,lower_yel,upper_yel)
io.imshow(mask)
io.show()

print("Blue:")
mask=cv2.inRange(imgHSV,lower_blu,upper_blu)
io.imshow(mask)
io.show()

print("Green:")
mask=cv2.inRange(imgHSV,lower_gre,upper_gre)
io.imshow(mask)
io.show()

#for white use the grayscale image and change the threshold
print("White:")
binary_imgw1 = gray1 > 0.46
io.imshow(binary_imgw1)
io.show()

print("Orange:")
mask=cv2.inRange(imgHSV,lower_ora,upper_ora)
io.imshow(mask)
io.show()


probabilistic_line1 = probabilistic_hough_line(edge1, threshold=10,
                                    line_length=2,
                                    line_gap=1)
fig, ax = plt.subplots()
ax.imshow(edge1 * 0)
for line in probabilistic_line1:
    p0, p1 = line
    ax.plot((p0[0], p1[0]), (p0[1], p1[1]))
ax.set_xlim((0, img1.shape[1]))
ax.set_ylim((img1.shape[0], 0))
ax.set_title('Probabilistic Hough Lines')

plt.show()

print("Circle detection, image 1:")
hough_radii = np.arange(8, 12, 1)
hough_res = hough_circle(edge1, hough_radii)

# Select the most prominent 5 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii,
                                           total_num_peaks=3)

# Draw them
fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius)
    img1[circy, circx] = (220, 200, 200)

ax.imshow(img1, cmap=plt.cm.gray)
plt.show()



#-----------------------------------------------------------------
img2 = io.imread("rgbh0008.bmp")
io.imshow("rgbh0008.bmp")
print("Original image 2: rgbh0008.bmp")
io.show()

gray2 = color.rgb2gray(img2)
io.imshow(gray2)
print("Grayscale:")
io.show()

threshold = filters.threshold_otsu( gray2 )
print ('Otsu method threshold = ', threshold)
binary_img2 = gray2 > threshold
io.imshow(binary_img2)
print("Black & White:")
io.show()

edge2 = canny(gray2, sigma=0.03,
              low_threshold=0.25, high_threshold=0.30)
io.imshow(edge2)
print("Edges:")
io.show()


contours = measure.find_contours(edge2, 0.2)
print("Contours:")
fig, ax = plt.subplots()
ax.imshow(edge2, interpolation='nearest', cmap=plt.cm.gray)

for n, contour in enumerate(contours):
    ax.plot(contour[:, 1], contour[:, 0], linewidth=2)

ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()

print("Colour detection:")

blur2 = cv2.GaussianBlur(img2,(3, 3),0.5)
imgHSV= cv2.cvtColor(blur2,cv2.COLOR_BGR2HSV)

#yellow, blue, green, white & orange
#
mask=cv2.inRange(imgHSV,lower_yel,upper_yel)
io.imshow(mask)
print("Yellow:")
io.show()

mask=cv2.inRange(imgHSV,lower_blu,upper_blu)
io.imshow(mask)
print("Blue:")
io.show()

mask=cv2.inRange(imgHSV,lower_gre,upper_gre)
io.imshow(mask)
print("Green:")
io.show()

#for white use the grayscale image and change the threshold
binary_imgw2 = gray2 > 0.46
io.imshow(binary_imgw2)
print("White:")
io.show()

mask=cv2.inRange(imgHSV,lower_ora,upper_ora)
io.imshow(mask)
print("Orange:")
io.show()

probabilistic_line2 = probabilistic_hough_line(edge2, threshold=10,
                                    line_length=2,
                                    line_gap=1)
fig, ax = plt.subplots()
ax.imshow(edge2 * 0)
for line in probabilistic_line2:
    p0, p1 = line
    ax.plot((p0[0], p1[0]), (p0[1], p1[1]))
ax.set_xlim((0, img2.shape[1]))
ax.set_ylim((img2.shape[0], 0))
ax.set_title('Probabilistic Hough Lines')

plt.show()

print("Circle detection, image 2:")
hough_radii = np.arange(5, 6, 1)
hough_res = hough_circle(edge2, hough_radii)

# Select the most prominent 5 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii,
                                           total_num_peaks=10)

# Draw them
fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius)
    img2[circy, circx] = (220, 200, 200)

ax.imshow(img2, cmap=plt.cm.gray)
plt.show()

# Perform a Hough Transform
# The accuracy corresponds to the bin size of a major axis.
# The value is chosen in order to get a single high accumulator.
# The threshold eliminates low accumulators
from skimage import data, color, img_as_ubyte
from skimage.transform import hough_ellipse
from skimage.draw import ellipse_perimeter
result = hough_ellipse(edge2, accuracy=20, threshold=300,
                       min_size=50, max_size=200)
result.sort(order='accumulator')

# Estimated parameters for the ellipse
best = list(result[0])
yc, xc, a, b = [int(round(x)) for x in best[1:5]]
#orientation = best[5]
orientation = 85
yc=110
xc=130
b=55
a=30

# Draw the ellipse on the original image
cy, cx = ellipse_perimeter(yc, xc, a, b, orientation)
img2[cy, cx] = (0, 0, 255)
# Draw the edge (white) and the resulting ellipse (red)
edges2 = color.gray2rgb(img_as_ubyte(edge2))
edges2[cy, cx] = (250, 0, 0)

fig2, (ax1, ax2) = plt.subplots(ncols=2, nrows=1, figsize=(8, 4),
                                sharex=True, sharey=True)

ax1.set_title('Original picture')
ax1.imshow(img2)

ax2.set_title('Edge (white) and Ellipse (red)')
ax2.imshow(edges2)

plt.show()

#---------------------------------------------------------------------
img3 = io.imread("rgbh0014.bmp")
io.imshow("rgbh0014.bmp")
print("Original image 3: rgbh0014.bmp")
io.show()

gray3 = color.rgb2gray(img3)
io.imshow(gray3)
print("Grayscale:")
io.show()

threshold = filters.threshold_otsu( gray3 )
print ('Otsu method threshold = ', threshold)
binary_img3 = gray3 > threshold
io.imshow(binary_img3)
print("Black & White:")
io.show()

edge3 = canny(gray3, sigma=0.01,
              low_threshold=0.10, high_threshold=0.25)
print("Edges:")
io.imshow(edge3)
io.show()

contours = measure.find_contours(edge3, 0.2)
print("Contours:")
fig, ax = plt.subplots()
ax.imshow(edge3, interpolation='nearest', cmap=plt.cm.gray)
for n, contour in enumerate(contours):
    ax.plot(contour[:, 1], contour[:, 0], linewidth=2)
ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()

print("Colour detection:")

blur3 = cv2.GaussianBlur(img3,(3, 3),0.5)
imgHSV= cv2.cvtColor(blur3,cv2.COLOR_BGR2HSV)

#yellow, blue, green, white & orange
#
mask=cv2.inRange(imgHSV,lower_yel,upper_yel)
io.imshow(mask)
print("Yellow:")
io.show()

mask=cv2.inRange(imgHSV,lower_blu,upper_blu)
io.imshow(mask)
print("Blue:")
io.show()

mask=cv2.inRange(imgHSV,lower_gre,upper_gre)
io.imshow(mask)
print("Green:")
io.show()

#for white use the grayscale image and change the threshold
binary_imgw3 = gray3 > 0.46
io.imshow(binary_imgw3)
print("White:")
io.show()

mask=cv2.inRange(imgHSV,lower_ora,upper_ora)
io.imshow(mask)
print("Orange:")
io.show()

probabilistic_line3 = probabilistic_hough_line(edge3, threshold=10,
                                    line_length=2,
                                    line_gap=1)
fig, ax = plt.subplots()
ax.imshow(edge3 * 0)
for line in probabilistic_line3:
    p0, p1 = line
    ax.plot((p0[0], p1[0]), (p0[1], p1[1]))
ax.set_xlim((0, img3.shape[1]))
ax.set_ylim((img3.shape[0], 0))
ax.set_title('Probabilistic Hough Lines')
plt.show()

print("Circle detection, image 3:")
hough_radii = np.arange(15, 25, 2)
hough_res = hough_circle(edge3, hough_radii)

# Select the most prominent 5 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii,
                                           total_num_peaks=3)

# Draw them
fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius)
    img3[circy, circx] = (220, 200, 200)

ax.imshow(img3, cmap=plt.cm.gray)
plt.show()

#-----------------------------------------------------------------------
img4 = io.imread("rgbh0015.bmp")
io.imshow("rgbh0015.bmp")
print("Original image 4: rgbh0015.bmp")
io.show()

gray4 = color.rgb2gray(img4)
io.imshow(gray4)
print("Grayscale:")
io.show()

threshold = filters.threshold_otsu( gray4 )
print ('Otsu method threshold = ', threshold)
binary_img4 = gray4 > threshold
io.imshow(binary_img4)
print("Black & White:")
io.show()

edge4 = canny(gray4, sigma=0.01,
              low_threshold=0.10, high_threshold=0.25)
io.imshow(edge4)
print("Edges:")
io.show()

contours = measure.find_contours(edge4, 0.2)
print("Contours:")
fig, ax = plt.subplots()
ax.imshow(edge4, interpolation='nearest', cmap=plt.cm.gray)
for n, contour in enumerate(contours):
    ax.plot(contour[:, 1], contour[:, 0], linewidth=2)
ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()

print("Colour detection:")

blur4 = cv2.GaussianBlur(img4,(3, 3),0.5)
imgHSV= cv2.cvtColor(blur4,cv2.COLOR_BGR2HSV)

#yellow, blue, green, white & orange
#
mask=cv2.inRange(imgHSV,lower_yel,upper_yel)
io.imshow(mask)
print("Yellow:")
io.show()

mask=cv2.inRange(imgHSV,lower_blu,upper_blu)
io.imshow(mask)
print("Blue:")
io.show()

mask=cv2.inRange(imgHSV,lower_gre,upper_gre)
io.imshow(mask)
print("Green:")
io.show()

#for white use the grayscale image and change the threshold
binary_imgw4 = gray4 > 0.46
io.imshow(binary_imgw4)
print("White:")
io.show()

mask=cv2.inRange(imgHSV,lower_ora,upper_ora)
io.imshow(mask)
print("Orange:")
io.show()

probabilistic_line4 = probabilistic_hough_line(edge4, threshold=10,
                                    line_length=2,
                                    line_gap=1)
fig, ax = plt.subplots()
ax.imshow(edge4 * 0)
for line in probabilistic_line4:
    p0, p1 = line
    ax.plot((p0[0], p1[0]), (p0[1], p1[1]))
ax.set_xlim((0, img4.shape[1]))
ax.set_ylim((img4.shape[0], 0))
ax.set_title('Probabilistic Hough Lines')
plt.show()

print("Circle detection, image 4:")
hough_radii = np.arange(10, 20, 2)
hough_res = hough_circle(edge4, hough_radii)

# Select the most prominent 5 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii,
                                           total_num_peaks=3)

# Draw them
fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius)
    img4[circy, circx] = (220, 200, 200)

ax.imshow(img4, cmap=plt.cm.gray)
plt.show()

#--------------------------------------------------------------------------

img5 = io.imread("rgbh0016.bmp")
io.imshow("rgbh0016.bmp")
print("Original image 4: rgbh0015.bmp")
io.show()

gray5 = color.rgb2gray(img5)
io.imshow(gray5)
print("Grayscale:")
io.show()

threshold = filters.threshold_otsu( gray5 )
print ('Otsu method threshold = ', threshold)
binary_img5 = gray5 > threshold
io.imshow(binary_img5)
print("Black & White:")
io.show()

edge5 = canny(gray5, sigma=0.01,
              low_threshold=0.10, high_threshold=0.25)
io.imshow(edge5)
print("Edges:")
io.show()

contours = measure.find_contours(edge5, 0.5)
print("Contours:")
fig, ax = plt.subplots()
ax.imshow(edge5, interpolation='nearest', cmap=plt.cm.gray)
for n, contour in enumerate(contours):
    ax.plot(contour[:, 1], contour[:, 0], linewidth=1)
ax.axis('image')
ax.set_xticks([])
ax.set_yticks([])
plt.show()

print("Colour detection:")

blur5 = cv2.GaussianBlur(img5,(3, 3),0.5)
imgHSV= cv2.cvtColor(blur5,cv2.COLOR_BGR2HSV)

#yellow, blue, green, white & orange
#
mask=cv2.inRange(imgHSV,lower_yel,upper_yel)
io.imshow(mask)
print("Yellow:")
io.show()

mask=cv2.inRange(imgHSV,lower_blu,upper_blu)
io.imshow(mask)
print("Blue:")
io.show()

mask=cv2.inRange(imgHSV,lower_gre,upper_gre)
io.imshow(mask)
print("Green:")
io.show()

#for white use the grayscale image and change the threshold
binary_imgw5 = gray5 > 0.46
io.imshow(binary_imgw5)
print("White:")
io.show()

mask=cv2.inRange(imgHSV,lower_ora,upper_ora)
io.imshow(mask)
print("Orange:")
io.show()

probabilistic_line5 = probabilistic_hough_line(edge5, threshold=10,
                                    line_length=2,
                                    line_gap=1)
fig, ax = plt.subplots()
ax.imshow(edge5 * 0)
for line in probabilistic_line5:
    p0, p1 = line
    ax.plot((p0[0], p1[0]), (p0[1], p1[1]))
ax.set_xlim((0, img5.shape[1]))
ax.set_ylim((img5.shape[0], 0))
ax.set_title('Probabilistic Hough Lines')
plt.show()

print("Circle detection, image 5:")
hough_radii = np.arange(50, 100, 20)
hough_res = hough_circle(edge5, hough_radii)

# Select the most prominent 5 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii,
                                           total_num_peaks=9)

# Draw them
fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius)
    img5[circy, circx] = (220, 200, 200)

ax.imshow(img5, cmap=plt.cm.gray)
plt.show()




























