function [indx, indy] = plotTotalPotential(dUdx, dUdy, X, Y, Ugrid, obstacles, plot_title)
figure
subplot(1,2,1)
hold off
surf(X,Y,Ugrid,'EdgeColor',"none",'FaceAlpha',0.75)
hold on
indx = 1:2:size(X,2);
indy = 1:2:size(Y,1);
dxp = dUdx;
dxp(dxp>1) = 1;
dxp(dxp<-1) = -1;
dyp = dUdy;
dyp(dyp>1) = 1;
dyp(dyp<-1) = -1;
quiver(X(indx,indy),Y(indx,indy),-1*dxp(indx,indy),-1*dyp(indx,indy),'r')
axis([-4 4 -4 4 0 20])
caxis([0 10])
view([-23.9 11.1])
subplot(1,2,2)
contourf(X,Y,Ugrid,0:10)
hold on
for i = 1:length(obstacles)
    poly = obstacles(i).poly;
    plot([poly(:,1); poly(1,1)],[poly(:,2); poly(1,2)],'r-','linewidth',2)
end

sgtitle(plot_title); 
end