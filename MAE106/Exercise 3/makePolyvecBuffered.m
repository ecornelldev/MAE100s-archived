function [polyvecbuf] = makePolyvecBuffered(polyvec,d,mlim)
%MAKEPOLYVEC takes in an input struct obstacle with fields px and py
%containing the coordinates of the obstacle vertices and returns both a
%polyvec of the obstacles as well as adds an aditional field containing a
%polyshape for each obstacle
polyvecbuf = [];
for i = 1:length(polyvec)
    polyvecbuf = [polyvecbuf polybuffer(polyvec(i),d,'JointType','miter','MiterLimit',mlim)];
end
end

