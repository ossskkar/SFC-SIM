function simulate(config_file)
% run this to start the simulation

if nargin==0
    config_file='../data/cstation_cvpr2015.conf';
end

fprintf('Load config file...\n');
config = loadConfig(config_file);
 
data = initialize(config);

% Initialize other variables
data.time = 0;
data.total_time = 0;
data.plot.time = 0;
data.plot.agents_count = 0;
frame = 0;
emission_time = 0;

% TEMPORAL CODE
data.d.max = [];
data.d.min = [];

fprintf('Start simulation...\n');

% For each simulation iteration
for cur_sim = 1:data.num_sim
    
    while (data.time <= data.simulation{cur_sim}.duration)
    
        tstart=tic;
        
        % Update current number of simulation
        data.cur_sim = cur_sim;
    
        % Check emission time
        if (emission_time > data.simulation{cur_sim}.emission_time)
            
            % Add agents per second
            data = addAgents(data);
            
            % Reset emission time
            emission_time = 0;
            
        end
        
        % Compute and apply forces
        data = addDesiredForce(data);
        data = addWallForce(data);
        data = addAgentRepulsiveForce(data);
        data = applyForcesAndMove(data);

        % do the plotting
        set(0,'CurrentFigure',data.figure_floors);
        for floor=1:data.floor_count
            
            data.plot.time = [data.plot.time; (data.total_time + data.time)];
            data.plot.agents_count = [data.plot.agents_count; (data.total_agent_count -data.agents_exited)];

            plotAgentsPerFloor(data, floor);
            plotFloor(data, floor);
        end
        if (data.save_frames==1)
            print('-depsc2',sprintf('frames/%s_%04i.eps', ...
                data.frame_basename,frame), data.figure_floors);
        end

        plotExitedAgents(data);
        
        data.time = data.time + data.dt;
        emission_time = emission_time + data.dt;

        telapsed = toc(tstart);
        pause(max(data.dt - telapsed, 0.01));
        fprintf('Sim %i: Frame %i done (took %.3fs; %.3fs out of %.3gs simulated).\n', cur_sim, frame, telapsed, data.time, data.duration);
        frame = frame + 1;
    end
    
    % Update total simulation time
    data.total_time = data.total_time + data.time;
    data.time = 0;
    
end

% Close all figures
delete(findall(0,'Type','figure'))

% Save log data
%save(strcat("Log ", datestr(datetime)), "data");
save("../data/simulation", "data");

fprintf('Simulation done.\n');

