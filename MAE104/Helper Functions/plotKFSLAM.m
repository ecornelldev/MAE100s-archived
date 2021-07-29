function plotKFSLAM(mu,sigma,pose,map, plot_title)

if size(pose,1)==2
    pose(3,:) = 0;
end

N = size(mu,2);
lim = 3;
epsilon = 1;
f = figure;
set(f,'position',[10,10,550,550])
set(f,'Units','normal','position',[.1 .1 .8 .8])
% ax = axes('Parent',f,'position',[0.05 0.25  0.4 0.67]);
ax = axes('Parent',f,'position',[0.05 0.25  0.4 0.67]);

hold on
axis([-lim lim -lim lim])
axis equal
title(plot_title); 

plot(ax,map(:,1),map(:,2),'.m','MarkerSize',15)
% for i = 1:size(map,1)
%     plot(ax,[map(i,1),map(i,3)],[map(i,2),map(i,4)], 'k');
%     hold on;
% end

% plot(pose(1,1),pose(2,1),'ko','MarkerSize',10);
plot(pose(1,:),pose(2,:),'k-')
th = linspace(pose(3,1),2*pi+pose(3,1),25);

hr = plot([(pose(1,1)+0.13*cos(th)) pose(1,1)],[(pose(2,1)+0.13*sin(th)) pose(2,1)],'k','linewidth',1);

ax2 = axes('Parent',f,'position',[0.55 0.25  0.4 0.67]);

% plotCovEllipse(mu(1:2,1), sigma(1:2,1:2,1),1,[{'color'},{'g'},{'linestyle'},{'-'},{'linewidth'},{1}]);
hold on
plot(mu(1,1),mu(2,1),'g.','MarkerSize',15);
plot(mu(1,:),mu(2,:),'r-')
% he = plotCovEllipse(mu(:,end), sigma(:,:,end),1,[{'color'},{'k'},{'linestyle'},{'-'},{'linewidth'},{1}]);
% h = plotCovEllipse(mu(1:2,1), sigma(1:2,1:2,1),1,[{'color'},{'r'},{'linestyle'},{'-'},{'linewidth'},{1}]);
th = linspace(mu(3,1),2*pi+mu(3,1),25);
h2 = plot([(mu(1,1)+0.13*cos(th)) mu(1,1)],[(mu(2,1)+0.13*sin(th)) mu(2,1)],'k-');
for i = 1:2:(size(mu,1)-3)
    hb(i) = plot(mu(i+3,1),mu(i+4,1),'m.','MarkerSize',15);
%     hbc(i) = plotCovEllipse(mu(i+3:i+4,1),sigma(i+3:i+4,i+3:i+4,1),1,[{'color'},{'m'},{'linestyle'},{'-'},{'linewidth'},{1}]);
end
 
t = text(-lim+0.5,lim-0.5,0,num2str(0));
axis equal
data.hr = hr;
data.t = t;
% data.h = h;
data.h2 = h2;
data.hb = hb;
% data.hbc = hbc;
data.mu = mu;
data.sigma = sigma;
data.pose = pose;


if N>1
%     b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
%                   'value',1, 'min',1, 'max',N,'SliderStep',[1/(N-1),0.1]);
              
    b = uicontrol('Parent',f,'Style','slider','Units','normal','Position',[.15,54/540,419/540,23/540],...
              'value',1, 'min',1, 'max',N,'SliderStep',[1/(N-1),0.1]);
    bgcolor = f.Color;
    bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                    'String','0','BackgroundColor',bgcolor);
    bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                    'String',num2str(N-1),'BackgroundColor',bgcolor);
    bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                    'String','timestep','BackgroundColor',bgcolor);

    addlistener(b,'ContinuousValueChange',@(hObject, event) updatePlot(hObject, event));

%     b2 = uicontrol('Parent',f,'Position',[250,525,50,20],...
%                   'String','Run KF');

    b2 = uicontrol('Parent',f,'Units','normal','Position',[250/540,505/540,50/540,30/540],...
              'String','Run KF');
          
    b2.Callback = @runKF;
    data.b = b;
    guidata(f,data);
end
end

function updatePlot(hObject,event)
    eps = round(hObject.Value);
    data = guidata(hObject);
    data = plotThings(data,eps);
    guidata(hObject,data)
end

function runKF(hObject,event)
    data = guidata(hObject);
    mu = data.mu;
    for i = 1:size(mu,2)
        data = plotThings(data,i);
        data.b.Value = i;
        guidata(hObject,data);
        
        pause(.01)
    end
end

function data = plotThings(data,eps)
%     h = data.h;
%     hbc = data.hbc;
    hb = data.hb;
    mu = data.mu;
    sigma = data.sigma;
%     if isgraphics(h)
%         delete(h)
%         clear h
%     end
%     if isgraphics(hbc)
%         delete(hbc)
%         clear hbc
%     end
%     h = plotCovEllipse(mu(1:2,eps), sigma(1:2,1:2,eps),1,[{'color'},{'r'},{'linestyle'},{'-'},{'linewidth'},{1}]);
    
    th = linspace(mu(3,eps),2*pi+mu(3,eps),25);
    data.h2.XData = [(mu(1,eps)+0.13*cos(th)) mu(1,eps)];
    data.h2.YData = [(mu(2,eps)+0.13*sin(th)) mu(2,eps)];
    
    for i = 1:2:(size(mu,1)-3)
        hb(i).XData = mu(i+3,eps);
        hb(i).YData = mu(i+4,eps);
%         hbc(i) = plotCovEllipse(mu(i+3:i+4,1),sigma(i+3:i+4,i+3:i+4,1),1,[{'color'},{'m'},{'linestyle'},{'-'},{'linewidth'},{1}]);
    end
 
    
    if size(data.pose,2) > 1
        th = linspace(data.pose(3,eps),2*pi+data.pose(3,eps),25);
        data.hr.XData = [(data.pose(1,eps)+0.13*cos(th)) data.pose(1,eps)];
        data.hr.YData = [(data.pose(2,eps)+0.13*sin(th)) data.pose(2,eps)];
    end
%     data.h = h;
    data.hb = hb;
%     data.hbc = hbc;
    set(data.t,'string',num2str(eps-1))
    drawnow
end
    