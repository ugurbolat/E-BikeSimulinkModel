% This script will be used to prepare the workspace for the simulation.    
%
% First, an example .gpx file will be parsed to get a matrix of gps 
% coordinates and distance information.
%
% Next, this information will be used to extend the spatial data by
% assigning a timespan to each track segment and computing derived factors
% like acceleration.
%
% The result will be stored in the variable "route" (accessible from the
% workspace).
%
% See also loadgpx, assign_speed

clear all;
close;

disp( '#######################' );
%% load track
disp( 'Loading track "track_01_simplified.gpx".' );
track1 = loadgpx( 'track_01_simplified.gpx' );
track2 = track1;
track3 = track1;

%% assign speed
disp( 'Assigning segment speed and computing segment timespan and acceleration.' );
track1 = assign_speed( track1, 1 );
track2 = assign_speed( track2, 2 );
track3 = assign_speed( track3, 3 );


%% prepare the workspace
disp( 'Creating simulation input.' );
% select the sim input from the route matrix and set standard parameters
simin1 = track1( :, [const.COL_CUM_TIME const.COL_SPEED const.COL_SLOPE const.COL_ACC] );
simin2 = track2( :, [const.COL_CUM_TIME const.COL_SPEED const.COL_SLOPE const.COL_ACC] );
simin3 = track3( :, [const.COL_CUM_TIME const.COL_SPEED const.COL_SLOPE const.COL_ACC] );

plot_track(track1, 1);
plot_track(track2, 2);
plot_track(track3, 3);

disp( 'Done.' );
disp( '#######################' );