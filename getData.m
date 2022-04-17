function [data] = getData(im, num) 
%Function reads data from a given image and writes it to data.xlsl

readRange = 'B2:J15';
writeRange = "B" + (num + 1) + ":J" + (num + 1);
if(num == 0)
    num = 10;
end

data = readmatrix('data.xlsx', 'Sheet', 1, 'Range', readRange);
data = data(num,:);

%Preprocessing commented out if getting image from dataCollection
%{]
im = im2gray(im);
im = imbinarize(im,0.5);
im = 1 - im;
%}
im = bound(im);

%Increment num images stored
data(1,1) = data(1,1) + 1;
count = data(1,1);

%Get aspect ratio
aspect = size(im,2) / size(im,1);
data(1,2) = ((count-1)*data(1,2) + aspect) / count;

%Get center of mass
[r,c] = find(im == 1);
com = [mean(r), mean(c)];
data(1,3) = (((count-1)*data(1,3) + com(1)) / count) / size(im,1);
data(1,4) = (((count-1)*data(1,4) + com(2)) / count) / size(im,2);

%Get ratio of top right half of image to the rest
rHalf = ceil(size(im,1) / 2);
cHalf = ceil(size(im,2) / 2);

topR = im(1:rHalf,cHalf+1:size(im,2));

rest = sum(sum(im)) - sum(sum(topR));
trRatio = sum(sum(topR)) / rest;

data(1,5) = ((count-1)*data(1,5) + trRatio) / count;

%Get ratio of top left half of image to the rest
topL = im(1:rHalf,1:cHalf);

rest = sum(sum(im)) - sum(sum(topL));
tlRatio = sum(sum(topL)) / rest;
data(1,6) = ((count-1)*data(1,6) + tlRatio) / count;

%Get ratio of bottom right half of image to the rest
botR = im(rHalf+1:size(im,1),cHalf+1:size(im,2));

rest = sum(sum(im)) - sum(sum(botR));
brRatio = sum(sum(botR)) / rest;
data(1,7) = ((count-1)*data(1,7) + brRatio) / count;

%Get ratio of bottom left half of image to the rest
botL = im(rHalf+1:size(im,1),1:cHalf);

rest = sum(sum(im)) - sum(sum(botL));
blRatio = sum(sum(botL)) / rest;
data(1,8) = ((count-1)*data(1,8) + blRatio) / count;

%Get Standard Deviation of image
data(1,9) = ((count-1)*data(1,9) + std2(im)) / count;


writematrix(data, 'data.xlsx', 'Sheet', 1, 'Range', writeRange);

end

