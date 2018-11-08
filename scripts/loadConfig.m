function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%

% get the path from the config file -> to read the images
config_path = fileparts(config_file);
if strcmp(config_path, '') == 1
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% read the images
for i=1:config.floor_count
    
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    img_build = imread(file_name);
    
    % decode images
    % BLACK COLOR
    config.floor(i).img_wall = (img_build(:, :, 1) ==   0 ...
                              & img_build(:, :, 2) ==   0 ...
                              & img_build(:, :, 3) ==   0);
    % PURPLE COLOR                      
    config.floor(i).img_temp_poi = (img_build(:, :, 1) == 255 ...
                               & img_build(:, :, 2) ==   0 ...
                               & img_build(:, :, 3) == 255);
    % GREEN COLOR                       
    config.floor(i).img_exit = (img_build(:, :, 1) ==   0 ...
                              & img_build(:, :, 2) == 255 ...
                              & img_build(:, :, 3) ==   0);
    % RED COLOR                      
    config.floor(i).img_stairs_up = (img_build(:, :, 1) == 255 ...
                                   & img_build(:, :, 2) ==   0 ...
                                   & img_build(:, :, 3) ==   0);
    % BLUE COLOR                           
    config.floor(i).img_stairs_down = (img_build(:, :, 1) ==   0 ...
                                     & img_build(:, :, 2) ==   0 ...
                                     & img_build(:, :, 3) == 255);
    
    % YELLOW COLOR                           
    config.floor(i).img_audience = (img_build(:, :, 1) == 255 ...
                                  & img_build(:, :, 2) == 255 ...
                                  & img_build(:, :, 3) == 0);
    
    % ORANGE COLOR                           
    config.floor(i).img_performers = (img_build(:, :, 1) == 255 ...
                                  & img_build(:, :, 2) == 155 ...
                                  & img_build(:, :, 3) == 0);
    
                                 
    %init the plot image here, because this won't change
    config.floor(i).img_plot = 6*config.floor(i).img_wall ...
        + 5*config.floor(i).img_stairs_up ...
        + 4*config.floor(i).img_stairs_down ...
        + 4*config.floor(i).img_exit ...
        + 3*config.floor(i).img_temp_poi ...
        + 2*config.floor(i).img_audience ...
        + 1*config.floor(i).img_performers;
                        
    config.color_map = [1.0 1.0 1.0; ... % Background color
                        0.8 0.0 0.8; ... % Temporal POIs color
                        0.0 1.0 0.0; ... % Entry/Exit POIs
                        0.4 0.4 1.0; ...
                        1.0 0.4 0.4; ...
                        0.0 0.0 0.0];    % Walls color
end

