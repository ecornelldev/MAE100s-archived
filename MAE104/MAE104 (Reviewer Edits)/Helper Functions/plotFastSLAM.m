function plotFastSLAM(pfArgs,u,robotXY)


M = 30;
% pfArgs.X = 4*rand(2,M) - 2;
pfArgs.u = [0;0];

% pfArgs.alpha = [pi, pi/2, 0, -pi/2]';
% pfArgs.Q = diag(0.1*ones(1,length(pfArgs.alpha)));
% pfArgs.dt = 0.01;
% pfArgs.map = load('MAP103M1.txt');
% pfArgs.maxRange = 4;
% pfArgs.measFunc = @ExpectedMeasurementLidar;
% 
% robotXY = [1.25;1];
% pfArgs.procFunc = @procFuncHolonomic;
% Vx = [zeros(1,200), -1*ones(1,200)]; 
% Vy = [-1*ones(1,200), zeros(1,200)];
% u = zeros(2,300);
% pfArgs.stateDim = length(robotXY);
% pfArgs.R = diag([100, 100]);

% robotXY = [1.25;1];
% pfArgs.procFunc = @procFuncHolonomic;
% Vx = [zeros(1,200), -1*ones(1,200)]; 
% Vy = [-1*ones(1,200), zeros(1,200)];
% u = [Vx;Vy];
% pfArgs.stateDim = length(robotXY);
% pfArgs.R = diag([100, 100]);

% robotXY = [1.25;.5;-pi/2];
% pfArgs.procFunc = @procFuncDiffDrive;
% goal_xy = [-1.25; .4];
% [V,omega,time] = findArcPath(robotXY',goal_xy',10);
% t = 0:pfArgs.dt:time;
% u = [V*ones(1,length(t));omega*ones(1,length(t))];
% pfArgs.stateDim = length(robotXY);
% pfArgs.R = diag([10, 10, 10]);

data.M = M;
data.pfArgs = pfArgs;
data.u = u;
data.robotXY = robotXY;

f = figure;

set(f,'position',[10,10,550,550])
ax = axes('Parent',f,'position',[0.13 0.25  0.77 0.67]);
hold on
map = pfArgs.map;
for i = 1:length(map)
    plot([map(i,1),map(i,3)],[map(i,2),map(i,4)], 'k');
    hold on;
end
if isfield(pfArgs,'beacons')
    plot(pfArgs.beacons(:,1),pfArgs.beacons(:,2),'.m','markersize',20)
end
axis([min(map(:,1))-1 max(map(:,1))+1 min(map(:,2))-1 max(map(:,2))+1])
axis equal


% temp = transform_points(pose_begin,[.25 0]);
% plot([pose_begin(1) temp(1)],[pose_begin(2) temp(2)],'k','linewidth',2);
% plot(xg,yg,'ro');

X = getInitParticles(M,pfArgs.map,pfArgs.stateDim);

if size(X,1) == 3
    thetas = X(3,:);
else
    thetas = zeros(1,size(X,2));
end

data.hpf(1) = scatter(X(1,:),X(2,:),10,[0 0 255]/256,'filled');
data.hpf(2) = scatter(X(1,:) + .02*cos(thetas), X(2,:) + .02*sin(thetas),3, [255 0 0]/256 ,'filled');
h(1) = scatter(X(1,:),X(2,:),10,[0 255 0]/256,'filled');
h(2) = scatter(X(1,:) + .02*cos(thetas), X(2,:) + .02*sin(thetas),3, [255 0 0]/256 ,'filled');
data.hpf(3) = scatter([],[],5,[255 0 0]/256,'filled');


data.ht = plot(robotXY(1),robotXY(2),'ko','MarkerSize',10);
if length(robotXY) == 3
    th = robotXY(3);
else 
    th = 0;
end
temp = transform_points([robotXY(1) robotXY(2) th], [0.1 0]);
data.ht = plot(robotXY(1),robotXY(2),'ko','MarkerSize',10);
data.hl = plot([robotXY(1) temp(1)],[robotXY(2) temp(2)],'k','linewidth',2);
data.pfArgs.X = X;
% for i = 1:length(a)
%     traj = a(i).pose_history;
%     h(i) = plot(traj(:,1),traj(:,2),'b');
% end
guidata(f,data);    

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',30, 'min',10, 'max',200,'SliderStep',[10/(200-10),10/(200-10)]);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','10','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','200','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','Number of Particles','BackgroundColor',bgcolor);
       
            
addlistener(b,'ContinuousValueChange',@(hObject, event) updatePlot(hObject, event,h));

b2 = uicontrol('Parent',f,'Position',[250,525,50,20],...
              'String','Run PF');
b2.Callback = @runPF;

end

function updatePlot(hObject,event,h)
    M = round(hObject.Value);
    data = guidata(hObject);
    pfArgs = data.pfArgs;
    X = getInitParticles(M,pfArgs.map,pfArgs.stateDim);
    h(1).XData = X(1,:);
    h(1).YData = X(2,:);
    if size(X,1) == 3
    thetas = X(3,:);
    else
        thetas = zeros(1,size(X,2));
    end
    h(2).XData = X(1,:) + .02*cos(thetas);
    h(2).YData = X(2,:) + .02*sin(thetas);
    data.hpf(1).XData = X(1,:);
    data.hpf(1).YData = X(2,:);
    data.hpf(2).XData = [];
    data.hpf(2).YData = [];
    data.hpf(3).XData = [];
    data.hpf(3).YData = [];
    drawnow
    data.pfArgs.X = X;
    data.M = M;
    guidata(hObject,data);
end


function runPF(hObject,event)
    data = guidata(hObject);
    pfArgs = data.pfArgs;
    robotXY = data.robotXY;
    u = data.u;
    Xesthist = [];
    for i = 1:size(u,2)
        robotXY = feval(pfArgs.procFunc,reshape(robotXY,length(robotXY),1),u(:,i),0.*pfArgs.R,pfArgs.dt);
        data.ht.XData = robotXY(1);
        data.ht.YData = robotXY(2);
        if length(robotXY) == 3
            th = robotXY(3);
        else 
            th = 0;
        end
        temp = transform_points([robotXY(1) robotXY(2) th], [0.1 0]);
        data.hl.XData = [robotXY(1) temp(1)];
        data.hl.YData = [robotXY(2) temp(2)];
        
%         pfArgs.meas = ExpectedMeasurementLidar(reshape(robotXY,length(robotXY),1),pfArgs.alpha,pfArgs.map,pfArgs.maxRange);
        pfArgs.meas = feval(pfArgs.measFunc,reshape(robotXY,length(robotXY),1),pfArgs);
        pfArgs.u = u(:,i);
        [pfArgs.X,w] = PF(pfArgs);
        data.hpf(1).XData = pfArgs.X(1,:);
        data.hpf(1).YData = pfArgs.X(2,:);
        if size(pfArgs.X,1) == 3
            thetas = pfArgs.X(3,:);
        else
            thetas = zeros(1,size(pfArgs.X,2));
        end
        data.hpf(2).XData = pfArgs.X(1,:) + .02*cos(thetas);
        data.hpf(2).YData = pfArgs.X(2,:) + .02*sin(thetas);
        if isfield(pfArgs,'estimateFunc')
            if isfield(pfArgs,'k')
                k = pfArgs.k;
            else 
                k = 1;
            end
            Xest = feval(pfArgs.estimateFunc,pfArgs.X,w,k);
            Xesthist = [Xesthist Xest];
            data.hpf(3).XData = Xesthist(1,:);
            data.hpf(3).YData = Xesthist(2,:);
        end
        if mod(i,10) == 0
            drawnow
        end
    end
        
end