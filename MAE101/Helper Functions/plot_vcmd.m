function plot_vcmd(Vx,Vy,pose,goalxy, plot_title)

    figure
    title(plot_title + ': Holonomic Robot Velocities')
    hold on
    grid on
    axis equal

    lim = 1.5;
    robotRad = 0.13;
    axis([-lim lim -lim lim])

    quiver(0,0,Vx,Vy,0,'filled')
    plot(goalxy(1),goalxy(2),'g.','MarkerSize',20);
    th = linspace(pose(3),pose(3)+2*pi,30);
    plot([pose(1)+robotRad*cos(th), pose(1)],[pose(2) + robotRad*sin(th), pose(2)],'k-')
    text(0.5,1.4,['Vx = ' num2str(Vx)])
    text(0.5,1.2,['Vy = ' num2str(Vy)])
end