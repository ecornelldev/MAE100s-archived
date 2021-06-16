function plot_frames(sensor_pose, dataxy_sensor, dataxy_robot, plot_title)

radius = 0.13;
lim = max(abs(dataxy_sensor(:)));
lim = max([max(abs(dataxy_robot(:))),lim]);
lim = ceil(lim);
figure
subplot(1,2,1)
title('Sensor Frame')

hold on
grid on
axis equal
axis([-lim lim -lim lim])
quiver(0,0,radius,0,0,'filled','s')
th = linspace(0,2*pi,30);
plot(-sensor_pose(1)+radius*cos(th),-sensor_pose(2)+radius*sin(th),'k-')
plot([-sensor_pose(1),-sensor_pose(1)+radius*cos(-sensor_pose(3))], ...
    [-sensor_pose(2),-sensor_pose(2)+radius*sin(-sensor_pose(3))],'k-')
plot(dataxy_sensor(:,1),dataxy_sensor(:,2),'r.','markersize',10)
subplot(1,2,2)
title('Robot Frame')

hold on
grid on
axis equal
axis([-lim lim -lim lim])
quiver(sensor_pose(1),sensor_pose(2),radius*cos(sensor_pose(3)),radius*sin(sensor_pose(3)),0,'filled','s')
plot(radius*cos(th),radius*sin(th),'k-')
plot([0,radius], ...
    [0,0],'k-')
plot(dataxy_robot(:,1),dataxy_robot(:,2),'r.','markersize',10)
sgtitle(plot_title)
end
