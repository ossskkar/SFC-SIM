function data = addAgents(data)

% place agents randomly in desired spots, without overlapping

function radius = getAgentRadius()
    radius = getNormrnd(cur_sim.r, cur_sim.r_sigma);
end

function m = getAgentMass()
    m = getNormrnd(cur_sim.m, cur_sim.m_sigma);
end

function v0 = getAgentV0()
    v0 = getNormrnd(cur_sim.v0, cur_sim.v0_sigma);
end

function value = getNormrnd(mu, sigma)
    % Get random value from normal distribution
    value = normrnd(mu, sigma);
    
    % Check random value is within the desired range
    while ((value < (mu - sigma)) || (value > mu + sigma))
        value = normrnd(mu, sigma);
    end
end

function temp_timer = getAgentTempTimer()
    temp_timer = round(getNormrnd(cur_sim.temp_timer, cur_sim.temp_timer_max_variation)); 
end

function spectator_time = getSpectatorTimer()
    spectator_time = round(getNormrnd(cur_sim.spectator_time, cur_sim.spectator_time*0.05));
end

function agent_id = getAgentID()
    
    % Assign unique agent ID
    agent_id = data.agent_id_counter;
                        
    % Update agent ID counter
    data.agent_id_counter = data.agent_id_counter + 1;
    
end

% Initialize list of entry/exit POI for agents
ti = [];
agent_count = 0;

% Get current simulations
cur_sim = data.simulation{data.cur_sim};

for i=1:data.floor_count
    
    % Initialize agents list
    agents_not_placed = 0;
    
    % If there are any agents to be added in this simulation segment
    if (isempty(cur_sim.ti)) 
        break; 
    end
        
    % Get indexes of agents to be added in this time iteration
    ai = find((round(cur_sim.ti(:,4),2) - round(data.time,2)) <= 0);

    % Filter out agents already added
    fai = find(cur_sim.ti(ai,5)==0);

    length(ai)
    
    % Get data for this time iteration
    ti = cur_sim.ti(ai(fai),:);
    
    % Update agent count, variation may occur due to POI's distribution
    [agent_count, ~] = size(ti);

    if (agent_count == 0) break; end
    
    % Get indexes of entry points
    ep.idx = unique(ti(:,1));
    
    % For each entry point
    for k = 1:length(ep.idx)
        % Get pixel indexes of intent ep.idx(k)
        pi = find(data.floor(i).intent.ti == ep.idx(k));
        ep.x{k} = data.floor(i).intent.x(pi);
        ep.y{k} = data.floor(i).intent.y(pi);    
    end
    
    % For each agent 
    for j=1:agent_count
        cur_agent = length(data.floor(i).agents) + 1;
            
        % init agent
        
        data.floor(i).agents(cur_agent).r = getAgentRadius(); % Radius (size) of agent
        data.floor(i).agents(cur_agent).v = [0, 0];           % current velocity of agent
        data.floor(i).agents(cur_agent).f = [0, 0];           % current force of agent
        data.floor(i).agents(cur_agent).m = getAgentMass();           % mass of agent
        data.floor(i).agents(cur_agent).v0 = getAgentV0();         % Initial velocity of agent
        data.floor(i).agents(cur_agent).temp = ti(j,3); % Indicate if the destination POI is temporal or not
        data.floor(i).agents(cur_agent).temp_timer = getAgentTempTimer(); % Indicate the time to remain at temporal POI
        
        data.floor(i).agents(cur_agent).ti_origin = ti(j,1); % Agent's intent index of origin
        data.floor(i).agents(cur_agent).ti_dest   = ti(j,2); % Agent's intent index of destination
        
        % If agent is an spectator or performer (ti(j,6) = 1 or 2)
        if (ti(j,6) ~= 0)
            data.floor(i).agents(cur_agent).spectator = ti(j,6);
            data.floor(i).agents(cur_agent).spectator_timer = getSpectatorTimer();
        else
            data.floor(i).agents(cur_agent).spectator = 0;
            data.floor(i).agents(cur_agent).spectator_timer = 0;
        end
        
        tries = 10;
        while tries > 0
                
            % Get intent index of current agent
            tidx = find(ep.idx(:) == data.floor(i).agents(cur_agent).ti_origin);
                
            % Get random index 'x' of pixels for intent tidx
            idx = randi(length(ep.x{tidx}));
                
            % Assign initial position to agent
            data.floor(i).agents(cur_agent).p = [ep.y{tidx}(idx), ep.x{tidx}(idx)];
                
            if checkForIntersection(data, i, cur_agent) == 0
                tries = -1; % leave the loop
            end
            tries = tries - 1;
        end
        if tries > -1
            %remove the last agent
            data.floor(i).agents = data.floor(i).agents(1:end-1);
        	agents_not_placed = agents_not_placed +1;
        else
            % Update agents count
            data.total_agent_count = data.total_agent_count + 1;
            
            % Flag agent as added 
            cur_sim.ti(ai(fai(j)),5) = 1;
            
            % Assign agent ID only if succesfully placed
            data.floor(i).agents(cur_agent).id = getAgentID();
        end
    end
    
    if (agents_not_placed > 0)
        fprintf(['WARNING: could only place %d agents on floor %d ' ...
        'instead of the desired %d.\n'], ...
        (agent_count - agents_not_placed), i, agent_count);
    end
end

if agents_not_placed==agent_count
    %error('no spots to place agents!');
    fprintf(['WARNING: no spots to place agents!']);
end

% Update current simulations
data.simulation{data.cur_sim} = cur_sim;

end
