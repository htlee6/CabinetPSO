function [x, Vx, y, Vy] = PSOinit(num_cabinet, num_requirement)

    % Initialization of the cabinet position matrix 'x'. 
    x  = rand(num_cabinet, 2);
    Vx = rand(num_cabinet, 2);
    
    % Initialization of the 'if-required' matrix 'y'.
    y  = rand(num_cabinet, num_requirement);
    Vy = rand(num_cabinet, num_requirement);
   
end
 