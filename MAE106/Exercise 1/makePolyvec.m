function [polyvec, obstacle] = makePolyvec(obstacle)
%MAKEPOLYVEC takes in an input struct obstacle with fields px and py
%containing the coordinates of the obstacle vertices and returns both a
%polyvec of the obstacles as well as adds an aditional field containing a
%polyshape for each obstacle
polyvec = [];
for i = 1:length(obstacle)
    obstacle(i).poly = polyshape(obstacle(i).px,obstacle(i).py);
    polyvec = [polyvec obstacle(i).poly];
end
end

