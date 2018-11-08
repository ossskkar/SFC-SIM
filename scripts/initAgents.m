function data = initAgents(data)

data.agents_exited = 0; %how many agents have reached the exit
data.total_agent_count = 0;

for i=1:data.floor_count
    
    % Initialize agents list
    data.floor(i).agents = [];
    
end

end
