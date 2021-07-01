function plotPFstep(pfArgs, Xnext, robotXY, plot_title)
% Plot the map
figure;
for i = 1:length(pfArgs.map)
    plot([pfArgs.map(i,1),pfArgs.map(i,3)],[pfArgs.map(i,2),pfArgs.map(i,4)], 'k');
    hold on;
end

% Plot the input particle set
scatter(pfArgs.X(1,:),pfArgs.X(2,:));

% Plot the output particle set (with added noise to see multiple copies)
Xnext = Xnext + 0.01*randn(size(Xnext));
scatter(Xnext(1,:),Xnext(2,:));

th = linspace(0,2*pi,25);

plot([(robotXY(1)+0.13*cos(th)) robotXY(1)],[(robotXY(2)+0.13*sin(th)) robotXY(2)],'k','linewidth',1);
title(plot_title); 

end