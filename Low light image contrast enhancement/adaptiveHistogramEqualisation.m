% clear all; clc;

% Q1.3. Adaptive Histogram Equalisation
% read images
road_low_1 = imread("imgs/road_low_1.jpg");
road_low_2 = imread("imgs/road_low_2.jpg");
sports_low = imread("imgs/sports_low.png");

% adaptive histogram equalisation of each image
box_size = 9;
road_low_1_adaptive = sliding_window(road_low_1, box_size);
road_low_2_adaptive = sliding_window(road_low_2, box_size);
sports_low_adaptive = sliding_window(sports_low, box_size);

% display images with histograms
imageAndHist(road_low_1, road_low_1_adaptive, "road\_low\_1");
imageAndHist(road_low_2, road_low_2_adaptive, "road\_low\_2");
imageAndHist(sports_low, sports_low_adaptive, "sports\_low");

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
imshow(road_low_1_adaptive);
title("Adaptive HE road\_low\_1");
subplot(2,3,5);
imshow(road_low_2_adaptive);
title("Adaptive HE road\_low\_2");
subplot(2,3,6);
imshow(sports_low_adaptive);
title("Adaptive HE sports\_low");
sgtitle("Subplot Grid of Adaptive Histogram Equalisation")


function g = adaptiveHistEqual(subimage)
    original = subimage;
    [row, column] = size(subimage);
    total_num_pixels = row * column; % this is MN
    L = power(2,8); % 8 bit image 256 [0,255]
    nk = zeros(1,L); % nk is the total number of each pixel in the image
    
    % count occurence of each pixels
    for k = 0:L-1 % all pixel values
        count = 0;
        for i = 1:row
            for j = 1:column
                if (subimage(i,j) == k)
                    count = count + 1;
                end  
            end
        end
        nk(k+1) = count;
    end

    % probability of occurrence of gray level
    probability = nk/total_num_pixels;

    tk= zeros(1,L);
    
    % CDF of probability. Transformation function
    for k = 1:L % all pixels
        total = 0;
        for l = 1:k
            total = total + probability(l);
        end
        tk(k) = (L-1) * total;
        if (tk(k) == 255)
            break;
        end
    end
    
    sk = round(tk);

    % replace each pixel value with their new pixel value
    for k = 0:L-1 % all pixel values 0 to 255
        for i = 1:row
            for j = 1: column
                if (original(i,j) == k)
                    subimage(i,j) = sk(k+1); 
                end
            end 
        end
    end
g = subimage(2,2);
end

function adaptiveHE = sliding_window(image, box_size)
    % sliding window function.
    adaptiveHE = image;
    half_box = floor(box_size/2);
    [row, column] = size(image);
    image = padarray(image,[3 3],'symmetric');
    
    for i=1:row
        for j=1:column
            left = i - half_box;
            right = i + half_box;
            down = j - half_box;
            up = j + half_box;
            
            if (left >= 1 && right <= row && down >= 1 && up <= column)
                window = image((left:right),(down:up));
                adaptiveHE(i,j) = adaptiveHistEqual(window);
            end
        end
    end
end

function imageAndHist(image, adaptive, imageName)
    image_hist = imhist(image);
    adaptive_hist = imhist(adaptive);

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
    imshow(adaptive);
    title("Adaptive Histogram Equalised "+imageName);
    subplot(2,2,4);
    bar(adaptive_hist);
    xlabel('Bins');
    ylabel('Counts');
    title("Adaptive Histogram Equalised Histogram for "+imageName);
    sgtitle("Adaptive Histogram Equalisation for "+ imageName + " image and Respective Histograms")
end