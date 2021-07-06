function [vx, vy, px, py] = getVertices(polyvec)
vx = [];
vy = [];
px = [];
py = [];
if ~isempty(polyvec)
    for i = 1:length(polyvec)
        vx = [vx polyvec(i).Vertices(:,1)'];
        vy = [vy polyvec(i).Vertices(:,2)'];
        if i == 1
            px = [px polyvec(i).Vertices(:,1)'];
            py = [py polyvec(i).Vertices(:,2)'];
        else
            px = [px nan polyvec(i).Vertices(:,1)'];
            py = [py nan polyvec(i).Vertices(:,2)'];        
        end
    end
    temp = [vx' vy'];
    temp = sortrows(temp,[1,2]);
    vx = temp(:,1)';
    vy = temp(:,2)';
end
end