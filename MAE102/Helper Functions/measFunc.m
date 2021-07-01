function [measurements] = measFunc(robotPose,args)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
measurements = [];
if ~isfield(args,'measType')
    args.measType = 'lidar';
end
if ~iscell(args.measType)
    args.measType = {args.measType};
end

for i = 1:numel(args.measType)
    switch args.measType{i}
        case 'lidar'
            measurementsLidar = ExpectedMeasurementLidar(robotPose, args.alpha, args.map, args.maxRange);
            measurements = [measurements;measurementsLidar];
        case 'beacons'
            [dist, ang , id] = ExpectedMeasurementBeacon(robotPose,args.beacons,args.angRange,args.maxBeaconRange,args.map);
            measurements = [measurements;dist;ang];  
        case 'gps'
            measurements = [measurements;robotPose(1);robotPose(2)];
    end        
end


end

