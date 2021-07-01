function X_pred = procFuncHolonomic(X,u,R,dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

A = [1,0;0,1];
B = [dt,0;0,dt];
M = size(X,2);
if size(X,1) == 3
    X(3,:) = [];
end
X_pred = A*X + B*repmat(u,1,M) + sqrt(R)*dt*randn(size(X));

end

