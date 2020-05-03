clear all; clc;

%% Question 2.1
zoneplate = imread("zoneplate.tif");

%% Step1: convert the image to double
image = double(zoneplate);

% my filter for the image
% h = fspecial('gaussian');
h = fspecial('average', [1950 1950]);

%% Step2: obtain the padding parameters P,Q and Pad the image
[P, Q] = paddedsize(image, h);

% pad the image using circular, symmetric, or replicate
% paddedimage = padarray(image,[P Q], 'symmetric');

%% Step3: Compute DFT:F(u,v) i.e. transform image from spatial domain to frequency domain
F = fft2(image, P,Q); % image in frequency domain - fft2 autopads with zero padding

% shift the image
shifted_image = real(fftshift(F));

%% Step4: Construct the desired filter in frequency domain, H, of the same size as the padded image.
% H = fft2(double(h), P, Q); % filter in frequency domain
n = 3;

% creating filter in frequency domain
% setting up range of variables
u=single(0:(P-1));
v=single(0:(Q-1));
% compute the indices to use in meshgrid
idx=find(u>P/2);
u(idx)=u(idx)-P;
idy=find(v>Q/2);
v(idy)=v(idy)-Q;
[V,U]=meshgrid(v,u);
% compute the distance from every point to the origin
D = hypot(V,U);
D0 = 0.05 * Q;

H = 1 ./ (1 + power((D./D0),2*n));

%% Step5: Compute G(u,v) = H(u,v)F(u,v)
G = H.*F;
 
%% Step6: Obtain filtered image (of size P,Q) by computing the inverse of G(u,v)
g = real(ifft2(G));

%% Step7: Crop top left rectangle to obtain the image of original size
g = g(1:size(image, 1), 1:size(image, 2));

%% Step8: Convert the image to the class of the input image
% below are the results
%% 1. Lowpass Filter
lowpassButterWorth = uint8(g);

%% 2. Highpass Filter
H = 1 ./ (1 + power((D0./D),2*n)); 
G = H.*F;
g = real(ifft2(G));
g = g(1:size(image, 1), 1:size(image, 2));
highpassButterWorth = uint8(g);

%% 3. Band Reject Filter
D0 = 100;
W = 70;

Hbr = 1 ./ (1 + power(((W.*D)./(power(D,2) - power(D0,2))), 2*n));
G = Hbr.*F;
g = ifft2(G);
g = g(1:size(image, 1), 1:size(image, 2));
bandrejectButterWorth = uint8(g);


%% 4. Band Pass Filter
Hbp = 1 - Hbr;
G = Hbp.*F;
g = ifft2(G);
g = g(1:size(image, 1), 1:size(image, 2));
bandrpassButterWorth = uint8(g);

%% 5. Intensities Scaled Image
scaledHighPass = rescale(highpassButterWorth, 0.20, 0.80);
scaledBandpass = rescale(bandrpassButterWorth, 0.20, 0.80);

%% display images

set(figure, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
subplot(3,3,2)
imshow(zoneplate); title('original image');

subplot(3,3,4)
imshow(lowpassButterWorth); title('Butterworth Low Pass Filtered image');
subplot(3,3,5)
imshow(highpassButterWorth); title('Butterworth High Pass Filtered image');
subplot(3,3,6)
imshow(scaledHighPass); title('Intensities scaled for High Pass Filter');

subplot(3,3,7)
imshow(bandrejectButterWorth); title('Butterworth Bandreject Filtered image');
subplot(3,3,8)
imshow(bandrpassButterWorth); title('Butterworth Bandpass Filtered image');
subplot(3,3,9)
imshow(scaledBandpass); title('Intensities scaled for Bandpass Filter');


%% functions

function [P, Q] = paddedsize(image, filter)
    [A, B] = size(image);
    [C, D] = size(filter);
    if (A == C && B == D)
        P = 2*A - 1;
        Q = 2*B - 1;
    else
        P = A+C - 1;
        Q = B+D - 1;
    end

end