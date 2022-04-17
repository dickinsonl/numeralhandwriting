function [frm] = findFunction(im)
%Program is given an image of a math function and outputs an array of the
%characters in the function
im = rgb2gray(im);
im = imcomplement(im);
im = imadjust(im);
im = imbinarize(im, 0.4);

boxes = GetCharacterBoundingBoxes(im);
func = zeros(size(boxes,1),1);
for i=1:size(boxes,1)
    b = min(boxes(:,1));
    for j=1:length(boxes)
        if b == boxes(j,1)
            b = boxes(j,:);
            break
        end
    end
    
    c = im(b(2):b(4),b(1):b(3));
    char = findChar(c);
    func(i) = char;
    boxes(j,:) = [];
end
frm = strings(size(func,1),1);
for i=1:size(func,1)
    if func(i) == 10
        frm(i) = '0';
    elseif func(i) == 11
        frm(i) = '+';
    elseif func(i) == 12
        frm(i) = '-';
    elseif func(i) == 13
        frm(i) = '*';    
    elseif func(i) == 14
        frm(i) = '/';            
    else
        frm(i) = int2str(func(i));
    end
end
frm = strjoin(frm);
end

