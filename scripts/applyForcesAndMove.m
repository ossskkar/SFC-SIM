function data = applyForcesAndMove(data)
%APPLYFORCESANDMOVE apply current forces to agents and move them using
%the timestep and current velocity

function agent_log = getAgentLog()
    agent_log = [ ...
        data.total_time + data.time ... % Time stamp
        data.floor(fi).agents(ai).id ... % Agent ID
        data.floor(fi).agents(ai).p  ... % Current position of agent
        data.floor(fi).agents(ai).v  ... % Current velocity of agent
        data.floor(fi).agents(ai).f  ... % Current force of agent
        data.floor(fi).agents(ai).r  ... % Radius of agent
        data.floor(fi).agents(ai).m  ... % Mass of agent
        data.floor(fi).agents(ai).v0 ... % Initial velocity of agent
        data.floor(fi).agents(ai).temp ... % Indicate the temporal POI, if any
        data.floor(fi).agents(ai).temp_timer ... % Indicate the time to remain at temporal POI
        data.floor(fi).agents(ai).ti_origin ... % Agent's intent index of origin
        data.floor(fi).agents(ai).ti_dest   ... % Agent's intent index of destination
        data.floor(fi).agents(ai).spectator ... % Agent's flag to indicate it joins spectator crowd
        data.floor(fi).agents(ai).spectator_timer ... % Agent's timer if it is an spectator
        ];
end

n_velocity_clamps = 0;

% loop over all floors
for fi = 1:data.floor_count

    % init logical arrays to indicate agents that change the floor or exit
    % the simulation
    floorchange = false(length(data.floor(fi).agents),1);
    exited = false(length(data.floor(fi).agents),1);
    
    % loop over all agents
    for ai=1:length(data.floor(fi).agents)
        % add current force contributions to velocity
        v = data.floor(fi).agents(ai).v + data.dt * ...
            data.floor(fi).agents(ai).f  / data.floor(fi).agents(ai).m;
        
        % clamp velocity
        if norm(v) > data.simulation{data.cur_sim}.v_max
            v = v / norm(v) * data.simulation{data.cur_sim}.v_max;
            n_velocity_clamps = n_velocity_clamps + 1;
        end
        
        % get agent's new position
        newp = data.floor(fi).agents(ai).p + ...
               v * data.dt / data.meter_per_pixel;
           
        % if the new position is inside a wall, remove perpendicular
        % component of the agent's velocity
        if lerp2(data.floor(fi).img_wall_dist, newp(1), newp(2)) < ...
                 data.floor(fi).agents(ai).r
            
            % get agent's position
            p = data.floor(fi).agents(ai).p;
            
            % get wall distance gradient (which is off course perpendicular
            % to the nearest wall)
            nx = lerp2(data.floor(fi).img_wall_dist_grad_x, p(1), p(2));
            ny = lerp2(data.floor(fi).img_wall_dist_grad_y, p(1), p(2));
            n = [nx ny];
            
            % project out perpendicular component of velocity vector
            v = v - dot(n,v)/dot(n,n)*n;
            
            % get agent's new position
            newp = data.floor(fi).agents(ai).p + ...
                   v * data.dt / data.meter_per_pixel;
        end
        
        if data.floor(fi).img_wall(round(newp(1)), round(newp(2)))
            newp = data.floor(fi).agents(ai).p;
            v = [0 0];
        end
        
        % update agent's velocity and position
        data.floor(fi).agents(ai).v = v;
        data.floor(fi).agents(ai).p = newp;
        
        % Update agent's log
        data.floor(fi).log = [data.floor(fi).log; getAgentLog()];
        
        % reset forces for next timestep
        data.floor(fi).agents(ai).f = [0 0];
        
        % check if agent reached a staircase and indicate floor change
        if data.floor(fi).img_stairs_down(round(newp(1)), round(newp(2)))
            floorchange(ai) = 1;
        end
        
        % Get pixel index of agent's new position
        pi = find(data.floor(fi).intent.y == round(newp(1)) & data.floor(1).intent.x == round(newp(2)));
        
        % If agent has a temporal POI
        if (data.floor(fi).agents(ai).temp ~= 0)
            
            % Get pixel index of agent's new position
            pi_temp = find(data.floor(fi).intent.y_t == round(newp(1)) & data.floor(1).intent.x_t == round(newp(2)));
            
            % check if agent reached its temporal POI
            if (data.floor(fi).agents(ai).temp == data.floor(1).intent.ti_t(pi_temp))
                if data.floor(fi).agents(ai).temp_timer > 0
                    data.floor(fi).agents(ai).temp_timer = ...
                        data.floor(fi).agents(ai).temp_timer - data.dt;
                else 
                    data.floor(fi).agents(ai).temp = 0;
                end
            end
        end
        
        % If agent is an spectator
        if (data.floor(fi).agents(ai).spectator ~= 0)
            
            % If timer hasn't expire
            if data.floor(fi).agents(ai).spectator_timer > 0
                
                % Reduce spectator time (regardless if it has reached audience area)
                data.floor(fi).agents(ai).spectator_timer = ...
                    data.floor(fi).agents(ai).spectator_timer - data.dt;
            else 
                % Flag agent as non-spectator
                data.floor(fi).agents(ai).spectator = 0;
            end
        end
        
        % If in escape mode
        if (data.simulation{data.cur_sim}.escape_mode)
            
            % If agent reached nearest exit point
            if data.floor(fi).img_exit(round(newp(1)), round(newp(2)))
                
                % Marked agent as exited
                exited(ai) = 1;
                data.agents_exited = data.agents_exited +1;
            end
            
        % check if agent reached its intended exit
        elseif (data.floor(fi).agents(ai).ti_dest == data.floor(1).intent.ti(pi))
            
            % Marked agent as exited
            exited(ai) = 1;
            data.agents_exited = data.agents_exited +1;
        end    
    end
    
    % add appropriate agents to next lower floor
    if fi > 1
        data.floor(fi-1).agents = [data.floor(fi-1).agents ...
                                   data.floor(fi).agents(floorchange)];
    end
    
    % delete these and exited agents
    % Agents should not be deleted, will cause problem with Agents ID
    data.floor(fi).agents = data.floor(fi).agents(~(floorchange|exited));
end

if n_velocity_clamps > 0
    fprintf(['WARNING: clamped velocity of %d agents, ' ...
            'possible simulation instability.\n'], n_velocity_clamps);
end
end