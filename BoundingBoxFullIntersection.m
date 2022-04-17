function result = BoundingBoxFullIntersection(A, B)
% B is within A
    result = 0;
    
    if A(1) <= B(1) && A(3) >= B(3)
        if A(2) <= B(2) && A(4) >= B(4)
            result = 1;
        end
    end
end