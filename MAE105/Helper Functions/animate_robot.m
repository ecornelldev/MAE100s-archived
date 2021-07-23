function animate_robot(X, indx, indy, Y, dUdx, dUdy, start_x, start_y, dUdx2, dUdy2, goal_x, goal_y, C, plot_title)
dt = 0.1;
figure
subplot(1,2,1)
hold on
quiver(X(indx,indy),Y(indx,indy),-1*dUdx(indx,indy),-1*dUdy(indx,indy),0)
h1 = plot(start_x,start_y,'.k','MarkerSize',20);
axis equal
title("Linear Potential Function"); 
subplot(1,2,2)
hold on
quiver(X(indx,indy),Y(indx,indy),-1*dUdx2(indx,indy),-1*dUdy2(indx,indy),0)
h2 = plot(start_x,start_y,'.k','MarkerSize',20);
plot(goal_x, goal_y, '*c', 'MarkerSize',20); 
axis equal
title("Quadratic Potential Function"'); 
pose1 = [start_x,start_y];
pose2 = [start_x,start_y];
goal = [goal_x,goal_y];
sgtitle(plot_title); 
tic
while (norm(pose1-goal) > 0.05 || norm(pose2-goal) > 0.05) && toc < 20
    [~, u1x, u1y]  =  linearPotential(pose1(1),pose1(2),goal,C);
    pose1 = pose1 + [-u1x,-u1y]*dt;
    [~, u2x, u2y]  =  quadraticPotential(pose2(1),pose2(2),goal,C);
    pose2 = pose2 + [-u2x,-u2y]*dt;  
    h1.XData = pose1(1);
    h1.YData = pose1(2);
    h2.XData = pose2(1);
    h2.YData = pose2(2);
    drawnow limitrate
    pause(dt)
end
drawnow
end