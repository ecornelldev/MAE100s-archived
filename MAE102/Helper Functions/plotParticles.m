
function plotParticles(map, X, plot_title)
for i = 1:length(map)
    plot([map(i,1),map(i,3)],[map(i,2),map(i,4)], 'k');
    hold on;
end
axlim = [min(map(:,1))-1, max(map(:,1))+1, min(map(:,2))-1, max(map(:,2))+1];
axis(axlim)
scatter(X(1,:),X(2,:), 'r')
hold off;
title(plot_title); 
end

