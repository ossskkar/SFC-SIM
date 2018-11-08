function plotAgentsPerFloor(data, floor_idx)
%plot time vs agents on floor

h = subplot(data.floor(floor_idx).agents_on_floor_plot);

set(h, 'position',[0.05+(data.floor_count - floor_idx)/(data.figure_floors_subplots_w+0.2), ...
    0.05, 1/(data.figure_floors_subplots_w*1.2), 0.3-0.05 ]);

if floor_idx~=data.floor_count
    set(h,'ytick',[]) %hide y-axis label
end

%Compute X axis
if data.plot.time(length(data.plot.time)) < 10
    x_axis(1) = 0;
    x_axis(2) = 10;
else
    x_axis(1) = 0;
    x_axis(2) = data.plot.time(length(data.plot.time));
end

% Compute Y axis
if data.total_agent_count < 10
    y_axis(1) = 0;
    y_axis(2) = 10;
    
else
    y_axis(1) = 0;
    y_axis(2) = (idivide(data.total_agent_count,int32(10))+1) * 10;
end

%hold on;
plot(data.plot.time, data.plot.agents_count, 'b-');

%hold off;

%axis([0 data.duration 0 data.total_agent_count]);
axis([x_axis(1) x_axis(2) y_axis(1) y_axis(2)]);

title(sprintf('agents on floor %i', floor_idx));

