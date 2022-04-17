function [] = segmentation(Image)

%Image = imresize(Image, 0.1);

OriginalImage = Image;
Image = rgb2gray(Image);
Image = imcomplement(Image);
Image = imadjust(Image);
Image = imbinarize(Image, 0.4);

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

close all;


