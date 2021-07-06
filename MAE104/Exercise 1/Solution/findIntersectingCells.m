function [r,c,linidx] = findIntersectingCells(X,Y,poly)
%findIntersectingCells finds all the cells that intersects with the sensor
%footprintof the robot.

%INPUT
%X,Y = grid cell edges
%poly = the sensor footprint of the robot

%OUTPUT
%(r,c) = rows and columns of the intersecting cells
% linidx = indexes of intersecting cells 


    X1 = X(1:end-1,1:end-1);
    X2 = X(1:end-1,2:end);
    X3 = X(2:end,1:end-1);
    X4 = X(2:end,2:end);
    X5 = 0.5*(X1+X2);
    X6 = 0.5*(X3+X2);
    X7 = 0.5*(X3+X4);
    X8 = 0.5*(X1+X4);
    
    Y1 = Y(1:end-1,1:end-1);
    Y2 = Y(1:end-1,2:end);
    Y3 = Y(2:end,1:end-1);
    Y4 = Y(2:end,2:end);
    Y5 = 0.5*(Y1+Y2);
    Y6 = 0.5*(Y3+Y2);
    Y7 = 0.5*(Y3+Y4);
    Y8 = 0.5*(Y1+Y4);
    
    in1 = inpolygon(X1(:),Y1(:),poly(:,1),poly(:,2));
    in2 = inpolygon(X2(:),Y2(:),poly(:,1),poly(:,2));
    in3 = inpolygon(X3(:),Y3(:),poly(:,1),poly(:,2));
    in4 = inpolygon(X4(:),Y4(:),poly(:,1),poly(:,2));
    in5 = inpolygon(X5(:),Y5(:),poly(:,1),poly(:,2));
    in6 = inpolygon(X6(:),Y6(:),poly(:,1),poly(:,2));
    in7 = inpolygon(X7(:),Y7(:),poly(:,1),poly(:,2));
    in8 = inpolygon(X8(:),Y8(:),poly(:,1),poly(:,2));

    
    in = in1 | in2 | in3 | in4 | in5 | in6 | in7 | in8;
    
    % Get the subscripts from the indices where the centers are within
    % hitbox
    linidx = find(in);
    [r,c] = ind2sub(size(X1),linidx);
    
%     r = [];
%     c = [];
%     poly1 = polyshape(poly(:,1),poly(:,2));
%     for i=1:size(X1,2)
%         for j=1:size(X1,1)
%             poly2 = polyshape([X1(j,i),X2(j,i),X4(j,i),X3(j,i)], ...
%                               [Y1(j,i),Y2(j,i),Y4(j,i),Y3(j,i)]);
%             if overlaps(poly1,poly2)
%                 r = [r,j];
%                 c = [c,i];
%             end
%         end
%     end
end

