images = dir('images/*.png');
numImages = length(images);

for i=1:numImages
    name = images(i).name;
    name = strcat('images/', name);
    im = imread(name);
    
    im = rgb2gray(im);
    im = imcomplement(im);
    im = imadjust(im);
    im = imbinarize(im, 0.4);

    for j=1:9
        if(contains(name, int2str(j)))
            imshow(im);
            boxes = GetCharacterBoundingBoxes(im);
            
            for k=1:length(boxes)
                
                coord = boxes(k,1:4);
                c = im(coord(2):coord(4),coord(1):coord(3));
                data = getData(c, j);
            end            
        end
    end
end

images = dir('images/ops/*.png');
numImages = length(images);
for i=1:numImages
    name = images(i).name;
    name = strcat('images/ops/', name);
    im = imread(name);
    
    im = rgb2gray(im);
    im = imcomplement(im);
    im = imadjust(im);
    im = imbinarize(im, 0.4);

    for j=10:14
        if(contains(name, int2str(j)))
            imshow(im);
            boxes = GetCharacterBoundingBoxes(im);
            
            for k=1:length(boxes)
                
                coord = boxes(k,1:4);
                c = im(coord(2):coord(4),coord(1):coord(3));
                data = getData(c, j);
            end            
        end
    end
end