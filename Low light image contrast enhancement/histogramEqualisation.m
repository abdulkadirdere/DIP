clear all; clc;

% Q1.2. Histogram Equalisation
% read images
road_low_1 = imread("road_low_1.jpg");
road_low_2 = imread("road_low_2.jpg");
sports_low = imread("sports_low.png");

% histogram equalisation of each image
road_low_1_histEqualised = histEqual(road_low_1);
road_low_2_histEqualised = histEqual(road_low_2);
sports_low_histEqualised = histEqual(sports_low);

% display images with histograms
imageAndHist(road_low_1, road_low_1_histEqualised, "road\_low\_1");
imageAndHist(road_low_2, road_low_2_histEqualised, "road\_low\_2");
imageAndHist(sports_low, sports_low_histEqualised, "sports\_low");


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
imshow(road_low_1_histEqualised);
title("Histogram Equalised road\_low\_1");
subplot(2,3,5);
imshow(road_low_2_histEqualised);
title("Histogram Equalised road\_low\_2");
subplot(2,3,6);
imshow(sports_low_histEqualised);
title("Histogram Equalised sports\_low");
sgtitle("Subplot Grid of Histogram Equalisation")


function g = histEqual(image)
    original = image;
    imsize = size(image);
    row = imsize(1); column = imsize(2);
    total_num_pixels = row * column; % this is MN
    L = power(2,8); % 8 bit image [0,255]
    nk = zeros(1,L); % total occurance of each pixel will be stored
    
    % count occurence of each pixels
    for k = 0:L-1
        count = 0;
        for i = 1:row
            for j = 1:column
                if (image(i,j) == k)
                    count = count + 1;
                end  
            end
        end
        nk(k+1) = count;
    end

    % probability of occurrence of gray level
    probability = nk/total_num_pixels;

    % transformation function
    tk= zeros(1,L);
    for k = 1:L
        total = 0;
        for l = 1:k
            total = total + probability(l);
        end
        tk(k) = (L-1) * total;
    end
    sk = round(tk);

    % replace each pixel value with their new pixel value
    for k = 0:255
        for i = 1:row
            for j = 1: column
                if (original(i,j) == k)
                    image(i,j) = sk(k+1); 
                end
            end 
        end
    end
g = image;    
end

function imageAndHist(image, hist_equalised, imageName)
    image_hist = imhist(image);
    histEqualised_hist = imhist(hist_equalised);

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
    imshow(hist_equalised);
    title("Histogram Equalised "+imageName);
    subplot(2,2,4);
    bar(histEqualised_hist);
    xlabel('Bins');
    ylabel('Counts');
    title("Histogram Equalised Histogram for "+imageName);
    sgtitle("Histogram Equalisation for "+ imageName + " image and Respective Histograms")
end