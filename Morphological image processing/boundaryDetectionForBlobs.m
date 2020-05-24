%% Question 3
clear all;
clc;

% read the images
bw_blobs = imread('imgs/blobs.tif');

% structuring element for small blobs
small_SE = strel('disk',30, 8);
% closing process: dilation followed by erosion
dilate_small = imdilate(bw_blobs, small_SE);
close_small = imerode(dilate_small, small_SE);

% structuring element for large blobs
large_SE = strel('disk', 76, 8);
% opening process: erosion followed by dilation
erode_large = imerode(close_small, large_SE);
open_large = imdilate(erode_large, large_SE);

% binary image
binary_image = imbinarize(open_large);

[r,c] = size(binary_image);
result_image = bw_blobs;

% Threshold the image. So we can create a boundary between the large blobs
% and small blobs. We have found the separation using closing and opening
% methods. We binarised the image so values are 0 or 1. Using this image,
% if the value changes from 0 to 1 then we know that's the boundary. Hence
% we assign the white intensity there (i.e. value of 255 for white pixel intensity)
for i=1:r
    value = 1;
    for j=1:c
        if (binary_image(i,j) == 0 && value == 1)
            result_image(i,j-1:j+1) = 255; % assign white colour to the boundary pixels
            value = 0;
        end
    end
end

% display the results
figure, 
imshow(result_image);
sgtitle("Small and Large Blobs Seperated By Boundary");
