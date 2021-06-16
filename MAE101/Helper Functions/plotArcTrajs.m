f = figure;
set(f,'position',[10,10,550,550])
ax = axes('Parent',f,'position',[0.13 0.25  0.77 0.77]);
hold on
axis([-4 4 -4 4])
axis equal
maxWheelSpeed = 10;
pose_begin = [0 0 0];
xg = [linspace(-3,3,7) 3*ones(1,5) linspace(3,-3,7) -3*ones(1,5)];
yg = [3*ones(1,6) linspace(3,-3,7) -3*ones(1,6) linspace(-2,2,5)];
for i = 1:length(xg)
    goal_xy = [xg(i) yg(i)];

    [V,omega,time] = findArcPath(pose_begin,goal_xy,maxWheelSpeed);

    [t,y] = ode45(@(t,y) diff_drive(t,y,V,omega),[0 time],pose_begin);

    h(i) = plot(y(:,1),y(:,2),'b');
end

plot(pose_begin(1),pose_begin(2),'ko','MarkerSize',10);
temp = transform_points(pose_begin,[.25 0]);
h1 = plot([pose_begin(1) temp(1)],[pose_begin(2) temp(2)],'k','linewidth',2);
plot(xg,yg,'ro');


b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',0, 'min',0, 'max',2*pi);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','2pi','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','theta','BackgroundColor',bgcolor);
            
addlistener(b,'ContinuousValueChange',@(hObject, event) updatePlot(hObject, event,h1,h));

function updatePlot(hObject,event,h1,h)
    maxWheelSpeed = 10;
    theta = hObject.Value;
    pose_begin = [0 0 theta];
    temp = transform_points(pose_begin,[.25 0]);
    h1.XData = [pose_begin(1) temp(1)];
    h1.YData = [pose_begin(2) temp(2)];
    xg = [linspace(-3,3,7) 3*ones(1,5) linspace(3,-3,7) -3*ones(1,5)];
    yg = [3*ones(1,6) linspace(3,-3,7) -3*ones(1,6) linspace(-2,2,5)];
    for i = 1:length(xg)
        goal_xy = [xg(i) yg(i)];

        [V,omega,time] = findArcPath(pose_begin,goal_xy,maxWheelSpeed);

        [t,y] = ode45(@(t,y) diff_drive(t,y,V,omega),[0 time],pose_begin);
        h(i).XData = y(:,1);
        h(i).YData = y(:,2);
    end
    drawnow
end