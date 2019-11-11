function Obj = ObjectiveFunction(X, Y, requirement_num, ...
                             uj1, uj2, uj3, ...
                             E1, E2, E3, E, ...
                             C1, C2, t, T, q)
    %% Instructions on parameters
    % 'X' is the Position Matrix. (i*2 dimensional)
    % 'Xi1', 'Xi2' means the i-th cabinet has a position of (xi1, xi2).
    % 'Y' is the If-Served Matrix. (i*j dimensional)
    % 'Yij' means the i-th carbinet serves the j-th demanding ponit.
    % 'requirement_num' is a matrix describing the required number of each
    % requirement point.
    
    %% max Z = profit - cost
    
    % profit = Obj1 + Obj2 
    for i=1:size(requirement_num)
        Obj1 = Obj1 + requirement_num(i)  ...
                               * (uj1*E1 + uj2*E2 + uj3*E3);
    end
    
    Obj2 = E * sum(sum(Y));
    
    % cost = Obj3
    Obj3 = (C1/t+C2+q) / T * sum(sum(Y));
    
    % Compute the Objective Function Z
    Obj = Obj1 + Obj2 - Obj3;
 
end