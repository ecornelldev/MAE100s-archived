function newAng= wrap2pi(oldAng)
% newAng = wrap2pi(oldAng)
% Wrap angle in radians to [-pi pi]
% Replace wrapToPi to avoid dependence on mapping toolbox
%
% Input:
% oldAng - Angle to be wrapped within limits (rad)
%
% Output:
% newAng - Output angle within limits (rad)

    % Increase if too low
    while oldAng < -pi
        oldAng= oldAng+2*pi;
    end

    % Decrease if too high
    while oldAng > pi
        oldAng= oldAng-2*pi;
    end
    newAng= oldAng;
end
