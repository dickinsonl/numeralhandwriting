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
