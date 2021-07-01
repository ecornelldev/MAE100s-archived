function inmap = checkInMap(X,map)
% CHECKINMAP: checks if particles in X are in map
% 
%   inmap = checkInMap(X,map) returns a vector of ones and zeros with
%   length equal to the number of particles
% 
%   INPUTS
%       X         3-by-M set of particles (could also be 3-by-M)
%       map       N-by-4 matrix of map wall segments
% 
%   OUTPUTS
%       inmap     1-by-M vector of ones or zeros corresponding to the M
%                 particles in X, where 1 indicates the particle is in map 
%                 and 0 indicates it is outside of the map. This function
%                 does not account for holes within map.

    x = [map(:,1); map(:,3)]';
    y = [map(:,2); map(:,4)]';
    xt = X(1,:);
    yt = X(2,:);
    k = boundary(x',y');
    inmap = inpolygon(xt,yt,x(k),y(k));
end