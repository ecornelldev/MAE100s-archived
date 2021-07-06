function [nodes,idx] = findStartEndNodes(nodes_xy,polyvec,start,goal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i = 1:2
    if i == 1
        point = start;
    else
        point = goal;
    end
    dist = sqrt((nodes_xy(1,:) - point(1)).^2 + (nodes_xy(2,:) - point(2)).^2);
    [mdist,midx] = sort(dist);
    for j = 1:length(midx)
        seg = [point'; nodes_xy(:,midx(j))'];
        if ~checkIfIntersects(polyvec,seg)
            nodes(:,i) = nodes_xy(:,midx(j));
            idx(i) = midx(j);
            break
        end
    end
end
end