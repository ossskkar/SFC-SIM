function data = initSpectatorCrowd(data)
% Initialize audience and performers area

% Audience area
for i=1:data.floor_count

    boundary_data = zeros(size(data.floor(i).img_wall));
    boundary_data(data.floor(i).img_wall) =  1;
    
    boundary_data(data.floor(i).img_audience) = -1;
    
    audience_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
    
    [data.floor(i).img_audience_dir_x, data.floor(i).img_audience_dir_y] = ...
        getNormalizedGradient(boundary_data, -audience_dist);
end

% Performers area
for i=1:data.floor_count

    boundary_data = zeros(size(data.floor(i).img_wall));
    boundary_data(data.floor(i).img_wall) =  1;
    
    boundary_data(data.floor(i).img_performers) = -1;
    
    performers_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
    
    [data.floor(i).img_performers_dir_x, data.floor(i).img_performers_dir_y] = ...
        getNormalizedGradient(boundary_data, -performers_dist);
end
