function animate_robot(X, indx, indy, Y, dUdx, dUdy, start_x, start_y, goal_x, goal_y, C,obstacles, Ugrid, plot_title)
dt = 0.1;
figure

hold on

dxp = dUdx;
dxp(dxp>1) = 1;
dxp(dxp<-1) = -1;
dyp = dUdy;
dyp(dyp>1) = 1;
dyp(dyp<-1) = -1;
contourf(X,Y,Ugrid,0:10)
quiver(X(indx,indy),Y(indx,indy),-1*dxp(indx,indy),-1*dyp(indx,indy))

plot(goal_x, goal_y, '*c', 'MarkerSize',20); 

h1 = plot(start_x,start_y,'.k','MarkerSize',20);
for i = 1:length(obstacles)
    poly = obstacles(i).poly;
    plot([poly(:,1); poly(1,1)],[poly(:,2); poly(1,2)],'k-')
end

axis equal

pose = [start_x,start_y];

goal = [goal_x,goal_y];
title(plot_title); 
tic
while (norm(pose-goal) > 0.05) && toc < 20
    [~, u1x, u1y]  =  calculatePotential(pose(1),pose(2),goal,obstacles,C);
    
    pose = pose + [-u1x,-u1y]*dt;
    h1.XData = pose(1);
    h1.YData = pose(2);

    drawnow limitrate
    pause(dt)
end
drawnow
end