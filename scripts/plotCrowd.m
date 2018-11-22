clear;

% Load log data
% Load data
file_name = '0001';
load(strcat('../data/raw_', file_name));

% Get size of figure
[h, w] = size(data.floor.img_plot);

img = imread('../images/cstation_c.png');

% Open figure in fullscreen mode
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);

frame_num = 0;

data.time = min(data.floor.log(:,1));

% For each time iteration
while (data.time <= data.total_time)

    frame_num = frame_num + 1;
    
    % Get data for this time iteration
    log_idx = find((round(data.floor.log(:,1),2) - round(data.time,2)) == 0);

    % Get radius of agents
    %sz = (data.floor.log(log_idx,9)./data.r_sigma).*150;
    sz = data.floor.log(log_idx,9).*150;
    
    % Only if any data
    if (~isempty(log_idx))
        
        % Plot agents
        imagesc([0 500], [0 220], img);
        hold on
        scatter(...
            data.floor.log(log_idx,4),  ... % X coordinates
            data.floor.log(log_idx,3), ... % Y coordinates
            sz,                         ... % Radius of circles
            'filled',                   ... % Circles are color filled
            'MarkerEdgeColor', [0 0.1 1], ...
            'MarkerFaceColor', [0 0.9 1], ...
            'LineWidth', 1.5 ...
            );
        
        hold off
        axis ([0 500 0 220]);
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        
        pbaspect([w/h 1 1]);
        drawnow;
    end
    
    % Update time counter
    data.time = data.time + data.dt;
    
    % Save figure to png file
    %print(strcat('../data/frames/frame_', num2str(frame_num)),'-dpng');
end

