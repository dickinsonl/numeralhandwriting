function [c] = findChar(im)
%Function outputs a character given an image

readRange = 'C2:L15';
sheet = readmatrix('data.xlsx', 'Sheet', 1, 'Range', readRange);
data = getData2(im);
data(1) = [];
err = inf(14,8);
for i=1:10
    for j=1:8
        err(i,j) = (data(j) - sheet(i,j)) / sheet(i,j);
        
    end
end
if data(1) >= .8
    for i=11:14
        for j=1:8                        
            err(i,j) = (data(j) - sheet(i,j)) / sheet(i,j);            
        end
    end
end
err = mean(abs(err),2);

%Bias against 4 because chooses it too often
err(4) = err(4) * 1.2;

c = find(err == min(min(err)));

end

