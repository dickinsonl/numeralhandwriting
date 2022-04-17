Image = imread('training-sample-2.jpg');
Image = imresize(Image, 0.1);

OriginalImage = Image;

Image = rgb2gray(Image);
Image = imcomplement(Image);
Image = imadjust(Image);

Image = imbinarize(Image, 0.9);
Image = imdilate(Image, strel('square', 2));

BoundingBoxesInitial = uint8(Image(:, :, [1 1 1]) * 255);

BoundingBoxes = GetCharacterBoundingBoxes(Image);

for i = 1:size(BoundingBoxes)
    box = BoundingBoxes(i, :);
    
    for y = box(2):box(4)
        for x = box(1):box(3)
            BoundingBoxesInitial(y, x, 1) = 255;
        end
    end
end

figure;

subplot(1, 3, 1);
imshow(OriginalImage);

subplot(1, 3, 2);
imshow(Image);

subplot(1, 3, 3);
imshow(BoundingBoxesInitial);

pause;

clc;
close all;
clear all;

function result = GetCharacterBoundingBoxes(image)
    CC = bwconncomp(image);
    BoundingBoxes = zeros(CC.NumObjects, 4);

    for i = 1:CC.NumObjects
        indexList = CC.PixelIdxList{i};

        minX = 100000;
        minY = 100000;
        maxX = -100000;
        maxY = -100000;

        height = CC.ImageSize(1);
        width = CC.ImageSize(2);

        for j = 1:size(indexList)
            index = indexList(j) - 1;
            x = floor(index / height);
            y = index - x * height;
            x = x + 1;
            y = y + 1;

            if x < minX
                minX = x;
            end

            if x > maxX
                maxX = x;
            end

            if y < minY
                minY = y;
            end

            if y > maxY
                maxY = y;
            end
        end

        BoundingBoxes(i, :) = [minX, minY, maxX, maxY];
    end

    for i = 1:size(BoundingBoxes)
        bb = BoundingBoxes(i, :);
        width = bb(3) - bb(1);
        height = bb(4) - bb(2);
        aspectRatio = width / height;
        
        if aspectRatio > 1
            centerY = (bb(2) + bb(4)) / 2.0;
            height = width;

            bb(2) = max(round(centerY - height / 2.0), 1);
            bb(4) = min(round(centerY + height / 2.0), size(image, 1));

            BoundingBoxes(i, :) = bb;
        end
    end

    boxesToRemove = zeros(CC.NumObjects);
    btrI = 1;

    for i = 1:size(BoundingBoxes)
        A = BoundingBoxes(i, :);

        for j = i + 1:size(BoundingBoxes)
            B = BoundingBoxes(j, :);

            if BoundingBoxFullIntersection(A, B)
                boxesToRemove(btrI) = j;
                btrI = btrI + 1;
            end
        end
    end

    numBoxes = CC.NumObjects;

    for j = btrI - 1:-1:1
        BoundingBoxes(boxesToRemove(j), :) = BoundingBoxes(numBoxes, :);
        numBoxes = numBoxes - 1;
    end

    finalBoxes = zeros(numBoxes, 4);
    finalBoxes(:) = BoundingBoxes(1:numBoxes, :);
    
    result = finalBoxes;
end

% B is within A
function result = BoundingBoxFullIntersection(A, B)
    result = 0;
    
    if A(1) <= B(1) && A(3) >= B(3)
        if A(2) <= B(2) && A(4) >= B(4)
            result = 1;
        end
    end
end