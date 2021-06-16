function plot_arc(V,omega, pose, goal,time, plot_title)
posex = pose(1);
posey = pose(2);
poseth = pose(3);
goalx = goal(1);
goaly = goal(2);
L = .26;
r = 0.05;
title(plot_title + ': Arc Trajectory')
hold off
hold on
grid on
axis equal
% th2 = linspace(pi/2,pi/2+omega,50);
th = linspace(poseth,poseth+2*pi,30);
rad = L/4;
[t,y] = ode45(@(t,y) diff_drive(t,y,V,omega),[0 time],pose);
lim = 2.5;
robotRad = L/2;
axis([-lim lim -lim lim])
plot(goalx,goaly,'g.','markersize',20)
plot(y(:,1),y(:,2),'r-')
plot([posex+robotRad*cos(th) posex],[posey+robotRad*sin(th) posey],'k-')
th2 = linspace(y(end,3),y(end,3)+2*pi,30);
plot([y(end,1)+robotRad*cos(th2) y(end,1)],[y(end,2)+robotRad*sin(th2) y(end,2)],'k-')

end