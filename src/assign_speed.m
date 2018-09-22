function track_data = assign_speed(gpx_data, speed_type)                               
%ASSIGNSPEED assigns a driving speed to each track point.
% ROUTE = ASSIGNSPEED(TRACK_DATA) extends the gpx data by adding columns
% for velocity, time and acceleration.
%
% GPX_DATA  is a Nx8 array where each row is a track point.
%   Columns 1-3 are the X, Y, and Z coordinates.
%   Column  4 is the distance between the track point and its predecessor
%   Column  5 is the cumulative track length
%   Column  6 is the slope between the track point and its predecessor.
%
% TRACK_DATA  is a Nx11 array where each row is a track point.
%   Columns 1-3 are the X, Y, and Z coordinates.
%   Column  4 is the distance between the track point and its predecessor
%   Column  5 is the cumulative track length
%   Column  6 is the slope between a track point and its predecessor in percent (%).
%   Column  7 is the speed in km/h
%   Column  8 is the time in hours
%   Column  9 is the accumulated time in hours
%   Column  10 is the acceleration in m/s^2.
%
% See also loadgpx

% set track_data for speed, time per segment, cumulated time and acceleration to zero
track_data = gpx_data;
track_data(:,const.COL_SPEED:const.COL_ACC) = 0;

% assign speed to each trackpoint
if speed_type == 1
    track_data = assign_fixed_speed( track_data );
elseif speed_type == 2
    track_data = assign_slope_based_speed( track_data );
elseif speed_type == 3
    track_data = assign_realistic_speed( track_data );
end

track_data = compute_time_and_acceleration( track_data );

end

%% local functions

function out = assign_fixed_speed( in )
out = in;
% assign fixed speed of 20 km/h
out(:,const.COL_SPEED) = 20;

end

function out = assign_slope_based_speed( in )
out = in;
% assign speed based on the slope (given as a percentage in %) of the segment
out(:,const.COL_SPEED) = 20 * cos(atan(out(:,const.COL_SLOPE)/100));

end

function out = assign_realistic_speed( in )
out = in;
% assign speed based on the slope (given as a percentage in %) of the segment
% temp_speed_1 = [0:2:26]'; %14
% temp_speed_2 = randi([20,27],1,100)'; %100
% temp_speed_3 = [28:-2:0]';; %15

% out(:,const.COL_SPEED) = [temp_speed_1; temp_speed_2; temp_speed_3] .* cos(atan(out(:,const.COL_SLOPE)/100));

temp_speed_1 = [0:4:20]' .* cos(atan(out(1:6,const.COL_SLOPE)/100)); 
temp_speed_2(1:5,1) = 21 .* cos(atan(out(7:11,const.COL_SLOPE)/100));
temp_speed_3(1:28,1) = 22 .* cos(atan(out(12:39,const.COL_SLOPE)/100));
temp_speed_4(1:25,1) = 23 .* cos(atan(out(40:64,const.COL_SLOPE)/100));
temp_speed_5(1:25,1) = 24 .* cos(atan(out(65:89,const.COL_SLOPE)/100));
temp_speed_6(1:15,1) = 25 .* cos(atan(out(90:104,const.COL_SLOPE)/100));
temp_speed_7(1:10,1) = 25 .* cos(atan(out(105:114,const.COL_SLOPE)/100));
temp_speed_8(1:15,1) = [28:-2:0]' .* cos(atan(out(115:129,const.COL_SLOPE)/100));

out(:,const.COL_SPEED) = [temp_speed_1; temp_speed_2; temp_speed_3; ...
    temp_speed_4; temp_speed_5; temp_speed_6; temp_speed_7; temp_speed_8] .* cos(atan(out(:,const.COL_SLOPE)/100));


end

function out = compute_time_and_acceleration( in )
out = in;

out(1,const.COL_SEG_TIME) = 0;  % time
out(1,const.COL_CUM_TIME) = 0;  % cumulated time
out(1,const.COL_ACC) = 0;  		% acceleration

for i = 2:size(in, 1)
    % compute average and delta speed over segment ???????
    delta_speed = (in(i-1,const.COL_SPEED) + in(i,const.COL_SPEED)) / 2; %% average velocity
    
    % compute segment time in hours from average speed
    out(i,const.COL_SEG_TIME) = out(i,const.COL_SEG_DST) / delta_speed;
 
    % compute accumulated time in hours
    out(i,const.COL_CUM_TIME) = out(i-1,const.COL_CUM_TIME) + out(i,const.COL_SEG_TIME);
    
    % compute acceleration in m/s^2 from delta speed between two gps coordinates
    out(i,const.COL_ACC) = (in(i,const.COL_SPEED) - in(i-1,const.COL_SPEED)) / out(i,const.COL_SEG_TIME);
    % conversion from km/h^2 to m/s^2
    out(i,const.COL_ACC) = out(i,const.COL_ACC) * 1000 / (3600^2);
end

end
