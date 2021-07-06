function plotOddsLidarUpdate(X,Y,Zlast,Z,lim,pose,hitbox,cone, plot_title)
figure;
subplot(1,2,1)
imagesc((X(1,1:end-1)+X(1,2:end))./2,(Y(1:end-1,1)+Y(2:end,1))./2,Zlast,[-lim,lim]);
colormap(flipud(gray));
hold on
th = linspace(pose(3), pose(3)+2*pi,20);
plot([pose(1)+0.13.*cos(th), pose(1)],[pose(2)+0.13*sin(th),pose(2)],'r-')
plot([hitbox(:,1);hitbox(1,1)],[hitbox(:,2);hitbox(1,2)],'r-')
plot([cone(:,1);cone(1,1)],[cone(:,2);cone(1,2)],'r-')
axis equal
set(gca,'YDir','normal')
subplot(1,2,2)
imagesc((X(1,1:end-1)+X(1,2:end))./2,(Y(1:end-1,1)+Y(2:end,1))./2,Z,[-lim,lim]);
colormap(flipud(gray));
hold on
th = linspace(pose(3), pose(3)+2*pi,20);
plot([pose(1)+0.13.*cos(th), pose(1)],[pose(2)+0.13*sin(th),pose(2)],'r-')
plot([hitbox(:,1);hitbox(1,1)],[hitbox(:,2);hitbox(1,2)],'r-')
plot([cone(:,1);cone(1,1)],[cone(:,2);cone(1,2)],'r-')
axis equal
set(gca,'YDir','normal')
title(plot_title); 
end