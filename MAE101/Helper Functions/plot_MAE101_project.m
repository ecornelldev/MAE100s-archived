
function MAE101_project()
% simulate data from the mat file.

% for plotting
th_circle = linspace(0,2*pi,30);


% load the mat file
load('MAE101project_workspace.mat')

% setup the parameters
% closeEnough = 0.1;
% robotRadius = 0.16;


angleData= linspace(-angRangeLidar/2,angRangeLidar/2,numPtsLidar);



% Create a struct to keep track of the beacon information
numBeacons = 6; 
beacons(numBeacons) = struct('detected', 0,...
                   'visited', 0, ...
                   'xy_global', []);
[beacons.detected] = deal(0);
[beacons.visited] = deal(0);
foundBeacons = zeros(1,6); %Keeps track of which beacons have been found in a single array to better keep track when all are found


beacon_counter = 1;


figure;
axisMap = axes();
axis([-5 5 -5 5])
hold on   
    
    
for i = 1:length(X)
    
    pose_current = [X(i) Y(i) Th(i)];
    
    globalXYlidar = transform_points(pose_current,transform_points([robotRadius,0,0],range2xy(angleData',DistLidar{i}',rangeLidar)));
    plot(axisMap,globalXYlidar(:,1),globalXYlidar(:,2),'k.');
    
    
    tags = Tags{i};
    
        % Loop through sensed tags/beacons
    for j = 1:size(tags,1)
        beacon_number = round(tags(j,2)); % Get beacon number
        beacon_xy = transform_points([X(i) Y(i) Th(i)],transform_points([robotRadius,0,0],tags(j,3:4))); % Put tag data in global frame
        if ~beacons(beacon_number).detected % If first time detected, set info and plot red marker
            beacons(beacon_number).detected = 1;
            beacons(beacon_number).xy_global = beacon_xy;
            hb(beacon_number) = plot(axisMap,beacon_xy(1),beacon_xy(2),'ro','Markersize',5);
            ht(beacon_number) = text(axisMap,beacon_xy(1)+.1,beacon_xy(2),num2str(beacon_number));
            foundBeacons(beacon_number) = 1; 
        else
            if norm(beacon_xy - beacons(beacon_number).xy_global) > closeEnough % If new data is different, update
                beacons(beacon_number).xy_global = beacon_xy;
                hb(beacon_number).XData = beacon_xy(1);
                hb(beacon_number).YData = beacon_xy(2);
                ht(beacon_number).Position = [beacon_xy(1)+.1 beacon_xy(2)];
            end
        end
    end
    
    % check if beacon is visited
    goal_xy = [];
    if beacons(beacon_counter).detected
        goal_xy = beacons(beacon_counter).xy_global;
    end

    % Check if we've reached the current beacon
    if ~isempty(goal_xy)
        if norm(pose_current(1:2) - goal_xy) < closeEnough
            % If so, replot goal point as green, then remove from matrix
            plot(axisMap,goal_xy(1,1),goal_xy(1,2),'go','MarkerSize',10)
            goal_xy(1,:) = []; % Remove from matrix
            beacons(beacon_counter).visited = 1;
            beacon_counter = beacon_counter +1;
        end
    end
        
    
    % plot the robot
    % robot orientation
    T = @(th)[cos(th), -sin(th)
             sin(th), cos(th)];
    robot_orientation = T(pose_current(3)) * [0.15*cos(th_circle);0.15*sin(th_circle)];
    h1 = plot([pose_current(1)+robot_orientation(1,:) pose_current(1)],[pose_current(2)+robot_orientation(2,:) pose_current(2)], 'k','linewidth',2);
    
    drawnow
    pause(0.001);
    
    delete(h1)
    
    
    
end

end
