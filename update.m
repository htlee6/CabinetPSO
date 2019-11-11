function [upd_x, upd_Vx, upd_y, upd_Vy, ...
          upd_w_min, upd_w_max, upd_w] = ...
                            update(x, Vx, y, Vy, threshold, ...
                                   w_now, c1, c2, ...
                                   x_max, x_min, V_max, V_min, ...
                                   Pbest_x, Gbest_x, Pbest_y, Gbest_y, ...
                                   K_max, K_now, w_min, w_max)
    %% Comments for parameters. 
    % x is a matrix of cabinet position. (i*2)
    % Vx is a matrix of velocity x1 & x2. (i*2)
    % y is a matrix of 'if-required' 0/1. (i*j)
    % Vy is a matrix of velocity of f y matrix. (i*j)
    
    % w_now, c1 & c2 are params.
    
    % Pbest_x is the position matrix when a single particle has a best 
    % fitness. (i*2)
    % Pbest_x(i, :) means the position when i-th cabinet has a best 
    % ParticleFitness() value.
    % Gbest_x is the position matrix when the whole swarm has a best
    % fitness. (i*2)
    % Gbest_x(i, :) means the position when the whole cabinet swarm has 
    % a best SwarmFitness() value. 
    
    % Pbest_y 
    % Gbest_y
    
    % K_max is maximum count of interations, K_now is the index of iteration on-going.
    % K_now is the index of the ongoing interation.  
    % w_min, w_max is the minimum/maximum value of w_now in the process ever.
    
    %% Expand G_best_x/y() -> swarm_size*dim_of_searching_spacing matrix
    % Gbest_x_expand = repmat(Gbest_x, size(x,1), 1);
    % Gbest_y_expand = repmat(Gbest_y, size(y,1), 1);
    
    %% Update Vx.
    % randn() creates a random number ~ N(0,1).
    if(prod(size(Vx)==size(x)) && prod(size(Pbest_x)==size(x)))
        upd_Vx = w_now*Vx ... 
            + c1*abs(randn())*(Pbest_x - x) ...
            + c2*abs(randn())*(Gbest_x - x);
    else
       % print("Dim not same: v&s or single_best_val&s\n");
    end
    
    %% Check Vx velocity limitations
    upd_Vx(upd_Vx > V_max) = V_max;
    upd_Vx(upd_Vx < V_min) = V_min;
    
    %% Update x.
    if(prod(size(x)==size(upd_Vx)))
        upd_x = x + upd_Vx;
    else
       % print("Dim not same: upd_v&s\n");
    end
    
    %% Check x position limitations
    upd_x(upd_x > x_max) = x_max;
    upd_x(upd_x < x_min) = x_min;
    
    %% Update Vy
    if(prod(size(Vy)==size(y)) && prod(size(Pbest_y)==size(y)))
        upd_Vy = w_now*Vy ... 
            + c1*sigmoid(randn())*(Pbest_y - y) ...
            + c2*sigmoid(randn())*(Gbest_y - y);
    else
        % print("Dim not same: v&s or single_best_val&s\n");
    end
    %% Check Vy velocity limitations
    upd_Vy(upd_Vy > V_max) = V_max;
    upd_Vy(upd_Vy < V_min) = V_min;
    
    %% Update y.
    if(prod(size(y)==size(upd_Vy)))
        upd_y = y + upd_Vy;
    else
        % print("Dim not same: upd_v&s\n");
    end
    
    % Becasue y is 0-1 matrix, so transfer it into 0-1 form.
    upd_y(upd_y >  threshold) = 1;
    upd_y(upd_y <= threshold) = 0;
    
    % Check twice that every requirement point needs at least 1 cabinet to
    % serve itself.
    for idx_requ = 1:size(upd_Vy, 2)
        if(sum(upd_Vy(:, idx_requ)) == 0)
            r = rand();
            if(r<=0.25)
                upd_Vy(1,idx_requ) = 1;
            elseif(r<=0.5)
                upd_Vy(2,idx_requ) = 1;
            elseif(r<=0.75)
                upd_Vy(3,idx_requ) = 1;
            else
                upd_Vy(4,idx_requ) = 1;
            end
        end
    end
    
    %% Update w. (dynamic w)
    upd_w = w_min + (K_max-K_now)*(w_max-w_min)/K_max;

    %% Update upd_w_max & upd_w_min
    if upd_w >= w_max
        upd_w_max = upd_w;
    else
        upd_w_max = w_max;
    end
    if upd_w <= w_min
        upd_w_min = upd_w;
    else 
        upd_w_min = w_min;
    end
end