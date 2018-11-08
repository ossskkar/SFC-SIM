% DESCRIPTION: Format data from simulation to final structure

%data.raw => [
    % Time stamp
    % Agent ID
    % Current position of agent
    % Current velocity of agent
    % Current force of agent
    % Radius of agent
    % Mass of agent
    % Initial velocity of agent
    % Indicate the temporal POI, if any
    % Indicate the time to remain at temporal POI
    % Agent's intent index of origin
    % Agent's intent index of destination
    % Agent's flag to indicate it joins spectator crowd
    % Agent's timer if it is an spectator
%   ]
     
%data.tracks => [
    % Time stamp
    % Current position of agent
    % Current velocity of agent
    % Current force of agent
    % Radius of agent
    % Mass of agent
    % Initial velocity of agent
    % Indicate the temporal POI, if any
    % Indicate the time to remain at temporal POI
    % Agent's intent index of origin
    % Agent's intent index of destination
    % Agent's flag to indicate it joins spectator crowd
    % Agent's timer if it is an spectator
%   ]

% Clean up
clear; close all; clc;

file_name = 'simulation';
load(strcat('../data/', file_name));

% Get data information
new_data.inf.frame_size = fliplr(size(data.floor.img_plot));
new_data.inf.frame_per_second = 25;
new_data.inf.meter_per_pixel = 0.168;

% Get raw data
new_data.raw = data.floor.log;
%new_data = data;
data = new_data;

% Change orientation of coordinates (for convenience)
%new_data.raw = data.raw;
data.raw = ...
    [new_data.raw(:,1:2) ... % time, ID
     new_data.raw(:,4)   ... % x (corrected) 
     220-new_data.raw(:,3)   ... % y (corrected) 
     new_data.raw(:,6)   ... % vx (corrected)
     new_data.raw(:,5)   ... % vy (corrected)
     new_data.raw(:,8)   ... % fx (corrected) 
     new_data.raw(:,7)   ... % fy (corrected)  
     new_data.raw(:,9:17)];  % rest of data

%  new_data.raw(:,4)   ... % x (corrected) 
%  data.inf.frame_size(2)-new_data.raw(:,3)   ... % y (corrected) 
 
% data.inf.frame_size(2)-new_data.raw(:,3)   ... % y (corrected) 

% Get tracks indexes
tracks_idx = unique(new_data.raw(:,2));

data.tracks = {};

% For each track
for i = 1:length(tracks_idx)
    
    % Update status
    display(strcat('Processing track #', num2str(i)));
    
    % Find data of track i
    this_track_idx = find(data.raw(:,2) == tracks_idx(i));
    
    % Update track
    data.tracks{i} = [data.raw(this_track_idx,1) data.raw(this_track_idx,3:17)];
    
end

% Change shape of structure
data.tracks = data.tracks.';

% Save data
save(strcat('../dataset/', file_name, '_2n_ww'),'data');

% Clean up
clear i new_data this_track_idx tracks_idx file_name;
