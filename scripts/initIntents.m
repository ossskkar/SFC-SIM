function data = initIntents(data)
% DESCRIPTION:
% 
% Takes the img_exit pixels as cluster them into
% different itents given max_intent
%
% An intent can be temporal or not. If temporal, the agents do not
% dissapear after reaching the POI but change to another POI

% For each floor
for i=1:data.floor_count
    
    % Get coordinates of entry/exit POIs pixels
    [data.floor(i).intent.y, data.floor(i).intent.x] = find(data.floor(i).img_exit);
    
    % Get coordinates of temporal POIs pixels
    [data.floor(i).intent.y_t, data.floor(i).intent.x_t] = find(data.floor(i).img_temp_poi);

    % Cluster pixels and returns indexes for each intent
    if (data.intent_count > 0)
        data.floor(i).intent.ti = clusterdata(...
            [data.floor(i).intent.y data.floor(i).intent.x], ...
            'maxclust', data.intent_count);
    end
        
    % Cluster pixels and returns indexes for each temporal intent
    if (data.temp_intent_count > 0)
        data.floor(i).intent.ti_t = clusterdata(...
            [data.floor(i).intent.y_t data.floor(i).intent.x_t], ...
            'maxclust', data.temp_intent_count);
    end
    % For each intent
    for ti = 1:data.intent_count
        
        % Get pixel indexes of intent ti
        pi = find(data.floor(i).intent.ti == ti);
        
        % Initialize boundary matrix
        boundary_data = zeros(size(data.floor(i).img_wall));
        
        % Mark wall pixels
        boundary_data(data.floor(i).img_wall) = 1;
        
        % Mark pixels of intent ti
        boundary_data(data.floor(i).intent.y(pi), data.floor(i).intent.x(pi)) = -1;
        
        % Calculate distance to intent ti
        intent_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
        
        % Normalize and assign data
        [data.floor(i).intent.img_dir_x{ti}, data.floor(i).intent.img_dir_y{ti}] = ...
        getNormalizedGradient(boundary_data, -intent_dist);
    end
    
    % For each temporal intent
    for ti = 1:data.temp_intent_count
        
        % Get pixel indexes of intent ti
        pi = find(data.floor(i).intent.ti_t == ti);
        
        % Initialize boundary matrix
        boundary_data = zeros(size(data.floor(i).img_wall));
        
        % Mark wall pixels
        boundary_data(data.floor(i).img_wall) =  1;
        
        % Mark pixels of temporal intent ti
        boundary_data(data.floor(i).intent.y_t(pi), data.floor(i).intent.x_t(pi)) = -1;
        
        % Calculate distance to temporal intent ti
        intent_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
        
        % Normalize and assign data
        [data.floor(i).intent.img_dir_x_t{ti}, data.floor(i).intent.img_dir_y_t{ti}] = ...
        getNormalizedGradient(boundary_data, -intent_dist);
    end
    
end