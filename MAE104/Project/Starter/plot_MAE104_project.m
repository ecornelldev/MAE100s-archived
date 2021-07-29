
function plot_MAE104_project()
% simulate data from the mat file.
currDir = pwd;
mapfolder_grid = fileFinder(currDir, 'projectMAP_grid.txt');
mapDirectory_grid = fullfile(mapfolder_grid, 'projectMAP_grid.txt');

% for plotting
th_circle = linspace(0,2*pi,30);


% load the mat file
load('MAE104project_workspace.mat')


pfArgs.meas = output.Meas;

Z = output.Z;

landmarkest = output.landmarkest;

Xest = output.Xest;


robotRadius = output.robotRadius;
closeEnough = output.closeEnough;

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
title('FastSLAM'); 
    

figure;
axisMap_occ = axes();
axis([-5 5 -5 5])
hold on   
title('Occupancy Grid'); 

map = load(mapDirectory_grid);

for i = 1:length(map)
    plot(axisMap_occ,[map(i,1),map(i,3)],[map(i,2),map(i,4)], 'k');
    hold on;
end

gridsize = 81;
[X,Y] = meshgrid(linspace(min(map(:,1)),max(map(:,1)),gridsize),linspace(min(map(:,2)),max(map(:,2)),gridsize));
Z0 = zeros(size(X));
Z0 = Z0(1:end-1,1:end-1);

% Plot occupancy grid
colormap(flipud(gray));
h2 = imagesc((X(1,1:end-1)+X(1,2:end))./2,(Y(1:end-1,1)+Y(2:end,1))./2,Z0);
set(gca,'CLim',[-1 1])


    
for i = 1:length(Xest)
    
    % plot estimate
    plot(axisMap,Xest(1,i),Xest(2,i),'r.');
    
    % plot measurement from EKF
%     plot(axisMap,mu(1,i),mu(2,i),'k.')
    for k = 1:length(landmarkest{i}.mu)
        if ~isempty(landmarkest{i}.mu)
            plot(axisMap,landmarkest{i}.mu(k,1),landmarkest{i}.mu(k,2),'.k')
        end
    end
    
%     pose_current = [X(i) Y(i) Th(i)];
    
    x = Xest(1,i);
    y = Xest(2,i);
    th = Xest(3,i);
    pose_current = [x y th];
    
    
        % Loop through sensed tags/beacons
    for j = 1:size(pfArgs.meas{i},1)
        beacon_number = round(pfArgs.meas{i}(j,3)); % Get beacon number
        idx = find(beacon_number == landmarkest{i}.id);
        beacon_xy = landmarkest{i}.mu(idx,:);
        if ~beacons(beacon_number).detected % If first time detected, set info and plot red marker
            beacons(beacon_number).detected = 1;
            beacons(beacon_number).xy_global = beacon_xy;
            hb(beacon_number) = plot(axisMap,beacon_xy(1),beacon_xy(2),'ro','Markersize',5);
            ht(beacon_number) = text(axisMap,beacon_xy(1)+.1,beacon_xy(2),num2str(beacon_number));
        else
            beacons(beacon_number).xy_global = beacon_xy;
%             if norm(beacon_xy - beacons(beacon_number).xy_global) > closeEnough % If new data is different, update
%                 beacons(beacon_number).xy_global = beacon_xy;
                hb(beacon_number).XData = beacon_xy(1);
                hb(beacon_number).YData = beacon_xy(2);
                ht(beacon_number).Position = [beacon_xy(1)+.1 beacon_xy(2)];
%             end
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
            plot(axisMap_occ, goal_xy(1,1),goal_xy(1,2),'go','MarkerSize',10)
            goal_xy(1,:) = []; % Remove from matrix
            beacons(beacon_counter).visited = 1;
            beacon_counter = beacon_counter +1;
        end
    end
    
    h2.CData = Z{i}; % Update the plot
    drawnow;
    
    % plot the robot
    % robot orientation
    T = @(th)[cos(th), -sin(th)
             sin(th), cos(th)];
    robot_orientation = T(pose_current(3)) * [0.15*cos(th_circle);0.15*sin(th_circle)];
    h4 = plot(axisMap,[pose_current(1)+robot_orientation(1,:) pose_current(1)],[pose_current(2)+robot_orientation(2,:) pose_current(2)], 'k','linewidth',2);
    h5 = plot(axisMap_occ,[pose_current(1)+robot_orientation(1,:) pose_current(1)],[pose_current(2)+robot_orientation(2,:) pose_current(2)], 'k','linewidth',2);
    
    
%     drawnow
    pause(0.001);
    
    delete(h4)
    delete(h5)
    
    
end

end
