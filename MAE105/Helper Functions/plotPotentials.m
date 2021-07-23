function [indx, indy] = plotPotentials(dUdx, dUdy, X, Y, Ugrid,Ugrid2, dUdx2, dUdy2, plot_title)
figure
subplot(1,2,1)
hold off
surf(X,Y,Ugrid,'EdgeColor',"none",'FaceAlpha',0.75)
hold on
indx = 1:10:size(X,2);
indy = 1:10:size(Y,1);
quiver(X(indx,indy),Y(indx,indy),-1*dUdx(indx,indy),-1*dUdy(indx,indy),'r')
axis([-4 4 -4 4 0 10])
subplot(1,2,1)
view([-23.9 11.1])

subplot(1,2,2)
hold off
surf(X,Y,Ugrid2,"EdgeColor",'none','FaceAlpha',0.75)
hold on
quiver(X(indx,indy),Y(indx,indy),-1*dUdx2(indx,indy),-1*dUdy2(indx,indy),'r')
axis([-4 4 -4 4 0 10])
subplot(1,2,2)
view([-23.9 11.1])
sgtitle(plot_title); 
end