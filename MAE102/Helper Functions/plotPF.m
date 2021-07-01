function plotPF(pfArgs,u,robotXY)


M = 30;
% pfArgs.X = 4*rand(2,M) - 2;

if isfield(pfArgs,'k')
    if pfArgs.k>M
        pfArgs.k = M; 
    end
end
pfArgs.u = [0;0];

data.M = M;
data.pfArgs = pfArgs;
data.u = u;
data.robotXY = robotXY;


f = figure;

set(f,'Units','normal','position',[.1 .1 .8 .8])
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

X = getInitParticles(M,pfArgs.map,pfArgs.stateDim, pfArgs.startingTheta);

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
if size(robotXY,1) == 3
    txt = strcat('Robot pos= ','[', num2str(robotXY(1,1)), ',', num2str(robotXY(2,1)),',',num2str(robotXY(3,1)),']');
elseif size(robotXY,1) == 2
    txt = strcat('Robot pos= ','[', num2str(robotXY(1,1)), ',', num2str(robotXY(2,1)),']');
end
text(robotXY(1)-0.5,robotXY(2)+0.2,txt)

temp = transform_points([robotXY(1) robotXY(2) th], [0.1 0]);
data.ht = plot(robotXY(1),robotXY(2),'ko','MarkerSize',10);
data.hl = plot([robotXY(1) temp(1)],[robotXY(2) temp(2)],'k','linewidth',2);
data.pfArgs.X = X;
% for i = 1:length(a)
%     traj = a(i).pose_history;
%     h(i) = plot(traj(:,1),traj(:,2),'b');
% end
guidata(f,data);    

b = uicontrol('Parent',f,'Style','slider','Units','normal','Position',[.15,54/540,419/540,23/540],...
              'value',30, 'min',10, 'max',200,'SliderStep',[10/(200-10),10/(200-10)]);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Units','normal','Position',[50/540,54/540,23/540,23/540],...
                'String','10','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Units','normal','Position',[500/540,54/540,23/540,23/540],...
                'String','200','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Units','normal','Position',[170/540,25/540,200/540,23/540],...
                'String','Number of Particles','BackgroundColor',bgcolor);
       
            
addlistener(b,'ContinuousValueChange',@(hObject, event) updatePlot(hObject, event,h));

b2 = uicontrol('Parent',f,'Units','normal','Position',[250/540,505/540,50/540,30/540],...
              'String','Run PF');
b2.Callback = @runPF;

end

function updatePlot(hObject,event,h)
    M = round(hObject.Value);
    data = guidata(hObject);
    pfArgs = data.pfArgs;
    if isfield(pfArgs,'k')
        if pfArgs.k>M
            pfArgs.k = M; 
        end
    end

    X = getInitParticles(M,pfArgs.map,pfArgs.stateDim,pfArgs.startingTheta);
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
        pfArgs.meas = pfArgs.Q*randn(length(pfArgs.Q),1) + feval(pfArgs.measFunc,reshape(robotXY,length(robotXY),1),pfArgs);
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