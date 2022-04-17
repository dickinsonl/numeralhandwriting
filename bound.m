function [out] = bound(im)
%Function takes in a binary image (0 is background, 1 is foreground)
%Outputs the image with border whitespace removed

while true
    val = sum(abs(im(1,:)));
    if(val == 0)
       im(1,:) = []; 
    else
        break
    end
end
while true
    val = sum(abs(im(:,1)));
    if(val == 0)
       im(:,1) = [];
    else
        break
    end
end

while true
    val = sum(abs(im(size(im,1),:)));
    if(val == 0)
       im(size(im,1),:) = [];
    else
        break
    end
end
while true
    val = sum(abs(im(:,size(im,2))));
    if(val == 0)
       im(:,size(im,2)) = [];
    else
        break
    end
end

out = im;
end

