clear all; clc;

% Contrast stretching
% read images
road_low_1 = imread("imgs/road_low_1.jpg");
road_low_2 = imread("imgs/road_low_2.jpg");
sports_low = imread("imgs/sports_low.png");

% histogram equalisation of each image
contrast_road_low_1 = contrastStretching(road_low_1);
contrast_road_low_2 = contrastStretching(road_low_2);
contrast_sports_low = contrastStretching(sports_low);

% display images with histograms
imageAndHist(road_low_1, contrast_road_low_1, "road\_low\_1");
imageAndHist(road_low_2, contrast_road_low_2, "road\_low\_2");
imageAndHist(sports_low, contrast_sports_low, "sports\_low");

% Enlarge figure to full screen.
set(figure, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]); 
subplot(2,3,1);
imshow(road_low_1);
title("Original road\_low\_1");
subplot(2,3,2);
imshow(road_low_2);
title("Original road\_low\_2");
subplot(2,3,3);
imshow(sports_low);
title("Original sports\_low");

subplot(2,3,4);
imshow(contrast_road_low_1);
title("Contrast road\_low\_1");
subplot(2,3,5);
imshow(contrast_road_low_2);
title("Contrast road\_low\_2");
subplot(2,3,6);
imshow(contrast_sports_low);
title("Contrast sports\_low");
sgtitle("Subplot Grid of Contrast Stretching")


function contrast = contrastStretching(image)
% r_high and r_low are chosen in such a way to eliminate certain 
% range of pixel values
    r_high = max(max(image)) - mean(mean(image))/2; 
    r_low = min(min(image)) + mean(mean(image))/2;
    imsize = size(image);
    L = power(2,8); % 8-bit image
    
    % contrast stretching formula
    for i = 1:imsize(1)
        for j = 1:imsize(2)
            if image(i,j) <= r_low
                image(i,j) = 0; % trying to minimise effects of outliers
            elseif ((r_low > image(i,j)) && (image(i,j) < r_high))
                % piecewise linear transformation of each pixel
                image(i,j) = (L - 1) * ((image(i,j) - r_low)/(r_high-r_low));
            else
                image(i,j) = L - 1; % trying to minimise effects of outliers
            end
        end  
    end
    contrast = image;
end

function imageAndHist(image, contrast_image, imageName)
    image_hist = imhist(image);
    contrast_hist = imhist(contrast_image);

    set(figure, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]); 
    subplot(2,2,1);
    imshow(image);
    title("Original " + imageName);
    subplot(2,2,2);
    bar(image_hist);
    xlabel('Bins');
    ylabel('Counts');
    title("Original Histogram for "+imageName);

    subplot(2,2,3);
    imshow(contrast_image);
    title("Contrast "+imageName);
    subplot(2,2,4);
    bar(contrast_hist);
    xlabel('Bins');
    ylabel('Counts');
    title("Contrast Stretched Histogram for "+imageName);
    sgtitle("Contrast Stretching for "+ imageName + " image and Respective Histograms")
end
