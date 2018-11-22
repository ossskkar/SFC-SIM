% DESCRIPTION: Plot tracks with background image

format_data();

% Clean up
clear; close all; clc;

% Load data
load ../dataset/simulation_2n_ww;

% Get number of tracks
n = length(data.tracks);

% Open figure in fullscreen mode
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);

% Plot background image to specific coordinates
img = imread('../images/cstation_c.png');
imagesc([0 data.inf.frame_size(1)], [0 data.inf.frame_size(2)], img);
hold on

% For each track
for i = 1:n

    % Update progress
    display(strcat('Processing track #', num2str(i)));
    
    % Get current track
    this_track = data.tracks{i};
    
    % Plot current track
    plot(this_track(:,2), data.inf.frame_size(2)-this_track(:,3));
    
end

hold off