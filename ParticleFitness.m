function [Pbest_x_out, Pbest_y_out] = ...
                ParticleFitness(x, y, requirement_pos, ...
                                Pbest_x_in, Pbest_y_in)
    %% Comments
    % requirement_pos is the position matrix of the requirement points.
    % This is a j*2 matrix. 
    
    %% Computation
    num_cabinet = size(y, 1);
    num_requirement = size(y, 2);
    candidate_fitness = zeros(num_cabinet, 1);
    inputxy_fitness = zeros(num_cabinet, 1);
    
    %% Compute inputxy_fitness. 
    for i = 1:num_cabinet
        count = 0; dist_sum = 0;
        for j = 1:num_requirement
            if(Pbest_y_in(i, j) == 1)
                count = count + 1;
                dist_sum = dist_sum + ...
                    distance(Pbest_x_in(i,:), requirement_pos(i,:));
            end
        end
        inputxy_fitness(i) = count / dist_sum;
    end
    
    %% Compute candidate_fitness.
    for i = 1:num_cabinet
        count = 0; dist_sum = 0;
        for j = 1:num_requirement
            if (y(i, j) == 1)
                count = count + 1;
                dist_sum = dist_sum + ...
                    distance(requirement_pos(j,:), x(i,:));
            end
        end
        candidate_fitness(i) = count / dist_sum;
    end
    
    %% Compare candidate_fitness & inputxy_fitness.
    for i = 1:num_cabinet
        
        if candidate_fitness(i) >= inputxy_fitness(i)
            Pbest_x_out(i, :) = x(i, :);
            Pbest_y_out(i, :) = y(i, :);
            
        elseif candidate_fitness(i) < inputxy_fitness(i)
            Pbest_x_out(i, :) = Pbest_x_in(i, :);
            Pbest_y_out(i, :) = Pbest_y_in(i, :);
        end
        
    end
    
end 