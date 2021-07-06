function [doesIntersect] = checkIfIntersects(polyvec,seg)
%DOESINTERSECT takes in a polyvec of obstacles and a line segement, returns
%true if the line segment intersects any of the obstacles
doesIntersect = false;
for k = 1:length(polyvec)
    polyt = polyvec(k);
    [in, out]  = intersect(polyt,seg);
    if ~isempty(in)
        doesIntersect = true;
        break
    end
end  
end

