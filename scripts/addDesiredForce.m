function data = addDesiredForce(data)
%ADDDESIREDFORCE add 'desired' force contribution (towards nearest exit or
%staircase)

% For each floor
for fi = 1:data.floor_count

    % For each agent
    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        m = data.floor(fi).agents(ai).m;
        v0 = data.floor(fi).agents(ai).v0;
        v = data.floor(fi).agents(ai).v;
        temp = data.floor(fi).agents(ai).temp;
        ti_dest = data.floor(fi).agents(ai).ti_dest;
        spectator = data.floor(fi).agents(ai).spectator;
        
        % If simulation is in escape mode
        if (data.simulation{data.cur_sim}.escape_mode)
            % get direction towards nearest exit
            ex = lerp2(data.floor(fi).img_dir_x, p(1), p(2));
            ey = lerp2(data.floor(fi).img_dir_y, p(1), p(2));
        elseif (spectator ~= 0) % Spectator crowd
            if (spectator == 1) % Agent is an spectator
                % get direction towards audience area
                ex = lerp2(data.floor(fi).img_audience_dir_x, p(1), p(2));
                ey = lerp2(data.floor(fi).img_audience_dir_y, p(1), p(2));
            elseif (spectator == 2) % Agent is a performer
                % get direction towards audience area
                ex = lerp2(data.floor(fi).img_performers_dir_x, p(1), p(2));
                ey = lerp2(data.floor(fi).img_performers_dir_y, p(1), p(2));
            end
        elseif (temp ~= 0)
            % get direction towards destination intent
            ex = lerp2(data.floor(fi).intent.img_dir_x_t{temp}, p(1), p(2));
            ey = lerp2(data.floor(fi).intent.img_dir_y_t{temp}, p(1), p(2));
        else
            % get direction towards destination intent
            ex = lerp2(data.floor(fi).intent.img_dir_x{ti_dest}, p(1), p(2));
            ey = lerp2(data.floor(fi).intent.img_dir_y{ti_dest}, p(1), p(2));
        end
        
        % Assign direction towards intent
        % CORRECTION: double noise added to make tracks look more natural
        %e = [ex ey];
        e = awgn([ex ey],1,'measured'); % First noise
        e = awgn(e,1,'measured');       % Second noise
        
        
        % get force
        Fi = m * (v0*e - v)/data.simulation{data.cur_sim}.tau;
        
        % Add white gaussian noise
        %Fi = awgn(Fi,1,'measured');
        
        % add force
        data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi;
    end
end

