clear all; clc;

%% Spatial Domain Filtering Methods
% read the image
zoneplate = imread("zoneplate.tif");

%% Step1: convert the image to double
image = double(zoneplate);

%% Step2: Create filter in spatial domain
disk_filter = 1/300 * fspecial('disk',9); 
laplacian_filter = 1/50 * fspecial('laplacian');

band_low_filter = 1/250 * fspecial('disk', 3); 
band_high_filter = 9 * fspecial('laplacian');
%% Step3:Apply the filter to the image
disk = imfilter(image, disk_filter, 'replicate', 'conv');
laplacian = imfilter(image, laplacian_filter, 'replicate', 'conv');

%% Step4: Mid-range filters
median = 1/250 * medfilt2(image, [19 19]);

bandpass_result = imfilter(image, band_low_filter, 'replicate', 'conv');
bandpass_result = imfilter(bandpass_result, band_high_filter, 'replicate', 'conv');
%% 5. Intensities Scaled Image
scaledHighPass = rescale(laplacian, 0.20, 0.80);
scaledBandpass = rescale(bandpass_result, 0.20, 0.80);

%% display images
set(figure, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
subplot(2,3,1)
imshow(disk); title('Lowpass Disk Filter');
subplot(2,3,2)
imshow(laplacian); title('Highpass Laplacian Filter');
subplot(2,3,3)
imshow(scaledHighPass); title('Intensities scaled - Highpass');

subplot(2,3,4)
imshow(median); title('Median Filtered image');
subplot(2,3,5)
imshow(bandpass_result); title('Low and High Pass Filtered image');
subplot(2,3,6)
imshow(scaledBandpass); title('Intensities scaled');
sgtitle("Filtering in Spatial Domain")