% DESCRIPTION:
% Plot network in colored zones

function plot_net(TOPO)

    % Start figure
    figure

    % Set background image and axes 
    img = imread(TOPO.plot.s_img);
    imagesc(TOPO.plot.x, TOPO.plot.y, img);
    hold on;

    % Plot training data
    if (TOPO.plot.f_showData)
        scatter(TOPO.trainSet(:,1), -TOPO.trainSet(:,2), 10, 'g');
    end
    
    % For each class (zone)
    for i = 1:TOPO.n_neurons

        % Get the indexes of boundary data points of zone i
        bnd = TOPO.output.bnds{i};

        t_data = TOPO.trainSet(find(TOPO.output.classes == i),:);
        
        % Plot boundary of zone i
        fill(t_data(bnd,1), -t_data(bnd,2),[rand rand rand],'EdgeColor',[0 0 0],'FaceAlpha',0.3);
        
        % Neuron number
        text(TOPO.output.weight(i,1), -TOPO.output.weight(i,2), num2str(i), 'FontSize', 20);
        
    end
    
    title(TOPO.plot.s_title);
    
    % Correct axis when using image background
    %set(gca, 'YDir', 'reverse');

    % Plot network
    if (TOPO.plot.flag_showNet)
        
        % Plot edges
        for i = 1:(length(TOPO.output.edges)-1)
            plot(TOPO.output.weight(TOPO.output.edges(i,:),1),-TOPO.output.weight(TOPO.output.edges(i,:),2), 'b', 'LineWidth', 1);
        end
        
        % Plot neurons
        scatter(TOPO.output.weight(:,1), -TOPO.output.weight(:,2), 60, 'y', 'filled');
        scatter(TOPO.output.weight(:,1), -TOPO.output.weight(:,2), 30, 'r', 'filled');
        
    end
    
    hold off;
end