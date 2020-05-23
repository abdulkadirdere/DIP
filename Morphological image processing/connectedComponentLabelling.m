%% Connected Component Labelling
clear all;
clc;

% keep track of visited pixels.
global visited;

% read the images
dip = imread('imgs/DIP.tif');
balls_with_reflections = imread('imgs/balls-with-reflections.tif');

% convert images to binary images where background pixel is represented by
% 0 and foreground pixels are represented by the value of 1
dip_image = binaryImage(dip);
ball_image = binaryImage(balls_with_reflections);

%% colour the connected components
[result_dip, num_dip] = allComponents(dip_image);

figure,
subplot(1,2,1);
imshow(result_dip);
xlabel("Number of Connected Components: "+num_dip);
colormap([0 0 0; 0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 1 0]);
caxis([0 6]);
title("Labelled Image");

subplot(1,2,2);
imshow(dip);
title("Original Image");
sgtitle("DIP (Original vs My Implimantation)")

% balls with reflection
[result_ball, num_ball] = allComponents(ball_image);

figure,
subplot(1,2,1);
imshow(result_ball);
xlabel("Number of Connected Components: "+num_ball);
colormap(hot(17));
caxis([0 17]);
title("Labelled Image");


subplot(1,2,2);
imshow(balls_with_reflections);
title("Original Image");
sgtitle("Balls with Reflection ( Original vs My Implimantation)")

%% Q2.c) Compare Bwlabel with my method
[dip_bwlabel, dip_cc_num] = bwlabel(dip);

figure,
subplot(1,3,1)
imshow(dip_bwlabel);
xlabel("Number of Connected Components: "+dip_cc_num);
caxis([0 6]);
title("Labelled Image - Built-in");

subplot(1,3,2);
imshow(result_dip);
xlabel("Number of Connected Components: "+num_dip);
colormap([0 0 0; 0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 1 0]);
caxis([0 6]);
title("Labelled Image - My Function");

subplot(1,3,3);
imshow(dip);
title("Original Image");
sgtitle("Built-in Function vs My Function vs Original")


% balls_with_reflections
[ball_bwlabel, ball_cc_num] = bwlabel(balls_with_reflections);

figure,
subplot(1,3,1)
imshow(ball_bwlabel);
xlabel("Number of Connected Components: "+ball_cc_num);
colormap(hot(17));
caxis([0 17]);
title("Labelled Image - Built-in");

subplot(1,3,2);
imshow(result_ball);
xlabel("Number of Connected Components: "+num_ball);
colormap(hot(17));
caxis([0 17]);
title("Labelled Image - My Function");

subplot(1,3,3);
imshow(balls_with_reflections);
title("Original Image");
sgtitle("Built-in Function vs My Function vs Original")

%% functions 

function [new_image, colour] = allComponents(image)
global visited;
% initialise visited matrix to the size of the image
visited = zeros(size(image));

% start coding the images from 2 to number of components. We are using 2
% because 1 currently represents foreground pixel.
colour = 2;

% zero pad the image to accomodate the corner pixels
pad_size = 6;
new_image = padarray(image,[pad_size pad_size]);
    
    % run the algorithm for 20 components. It will stop executing when it
    % reaches the maximum number of components in an image.
    for h=1:20
        % get the first pixel of each component
        [el_row, el_col] = getFirstElement(new_image);
        % if algorithm runs out of connected components it will return 0
        % for row and column. So stop executing.
        if (el_row == 0 && el_col == 0)
            break;
        end
        % get all the connected pixels for each component. Recursive.
        connectedComponent(new_image, el_row, el_col);
        % create copy of the visited pixels. Visited shows all the
        % connected pixels of each component.
        component = visited;
        [comp_row, comp_col] = size(component);
        
        % give each component series of integers starting from 2
        for i=1:comp_row
            for j=1:comp_col
                if component(i,j) == 1
                    new_image(i,j) = colour;
                end
            end
        end
        % reset visited pixels to compute all the pixels for the next
        % component
        visited = zeros(size(new_image));
        % increment the series value
        colour = colour + 1;
    end
    % trim the padded area to achieve the correct image size
    new_image = new_image(pad_size+1:end-pad_size,pad_size+1:end-pad_size); % unpad
    [row,col]=size(new_image);
    % re-ogranise the series to start fromm 1 instead of 2
    for i=1:row
        for j=1:col
            if new_image(i,j) > 0
                new_image(i,j) = new_image(i,j)-1;
            end
        end
    end
    colour = colour-2;
end


function connectedComponent(image, row, col)
    global visited;
    % get all the neighbours of the pixel at location row,col
    neighbours = getNeighbours(image, row, col);
    
    [im_row, im_col] = size(neighbours);
    % If the pixel is visited, then exit recursion. Else continue with
    % recursion
    if visited(row,col) == 1
        return;
    else
        % mark the pixel as visited 
        visited(row, col) = 1;
        % doing intersection and dialtion by checking only values which equal
        % to 1. Because dilation will only match with elements which overlay
        % the original image anyway. Hence, we only consider the values which
        % are already foreground pixels and not background pixels
        for r = 1:im_row
            for c = 1:im_col
                if neighbours(r,c) == 1
                    % We returned neighbours of origina pixel at location pixel(or,col).
                    % Check each neighbour. If a neighbour has foreground pixel then find its
                    % neighbours and compute the connected pixels.
                    if r == 1 && c == 1 % top left
                        connectedComponent(image, row-1, col-1);
                    elseif r == 1 && c == 2 % top middle
                        connectedComponent(image, row-1, col);
                    elseif r == 1 && c == 3 % top right
                        connectedComponent(image, row-1, col+1);
                    end

                    if r == 2 && c == 1 % middle left
                        connectedComponent(image, row, col-1);
                    elseif r == 2 && c == 2 % middle middle
                        connectedComponent(image, row, col);
                    elseif r == 2 && c == 3 % middle right
                        connectedComponent(image, row, col+1);
                    end

                    if r == 3 && c == 1 % bottom left
                        connectedComponent(image, row+1, col-1);
                    elseif r == 3 && c == 2 % bottom middle
                        connectedComponent(image, row+1, col);
                    elseif r == 3 && c == 3 % bottom right
                        connectedComponent(image, row+1, col+1);
                    end

                end
            end
        end
    end

end


function n = getNeighbours(image, row, col)
% this function returns 8 connected neighbours of the given pixel
% at location pixel(row, col)
    n = [image(row-1,col-1), image(row-1,col), image(row-1,col+1);...
        image(row,col-1), image(row,col), image(row,col+1);...
        image(row+1,col-1), image(row+1,col), image(row+1,col+1)];
end

function binaryImage = binaryImage(image)
[r,c] = size(image);
% convert image intensity values such that background is represented by 0
% and foreground is by 1
binaryImage = zeros(r,c);
for i=1:r
    for j=1:c
        if image(i,j) == 0
            pixel = 0; 
        else
            pixel = 1;
        end
        binaryImage(i,j) = pixel;
    end
end
end

function [i,j] = getFirstElement(image)
i=0;
j=0;
% retrieve the first element (pixel location) of the connected component
    [row, column] = size(image);
    for r=1:row
        for c=1:column
            if image(r,c) == 1
                i = r;
                j = c;
                return;
            end
        end
    end
end