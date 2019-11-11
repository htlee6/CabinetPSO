%% Clear the screen & all previous content
clear;clc;close all;

%% Initialization

% Parameter Initialization
i = 3; % 快递柜数量 Number of cabinets.
j = 5; % 需求点数量 Number of requirement points. 

c1 = 0.3; % 学习因子c1
c2 = 0.5; % 学习因子c2

w_now = 0.4; % 当前惯性权重w
w_min = 0.3; % 惯性权重w min值
w_max = w_now; % 惯性权重w max值

% ts = 0; % 禁忌表长度
K_max = 10; % 最大迭代次数
K_now = 1;
dim = 0; % 搜索空间维度

V_max = 5;  % 速度最大值
V_min = -5; % 速度最小值

x_max = 100; % 横坐标最大值
x_min = 0;   % 横坐标最小值
% x2_max = 100; % 纵坐标最大值
% x2_min = 0;   % 纵坐标最小值

Pbest = zeros(i, 1); % 个体最优值 Particle best (i-dimensional vector)
Gbest = zeros(K_max, 1); % 全局最优值 Global best

threshold = 0.5; % Threshold for discrete PSO (y & Vy) update. 

% Swarm Initialization

  % Horizontal & vertical coordinates of requirement points
requirement_pos = rand(j, 2); 
% x_now; Vx_now; y_now; Vy_now;
[x_now, Vx_now, y_now, Vy_now] = PSOinit(i, j);

x_next  = zeros(i, 2);
Vx_next = zeros(i, 2);
y_next  = zeros(i, j);
Vy_next = zeros(i, j);

Pbest_x = x_now;
Pbest_y = y_now;
Gbest_x = zeros(i, 2);
Gbest_y = zeros(i, j);

%% Integration
for K_now = 1:K_max
    
    [x_next, Vx_next, y_next, Vy_next, ...
     w_min, w_max, w_now] = ...
                    update(x_now, Vx_now, y_now, Vy_now, threshold, ...
                           w_now, c1, c2, ...
                           x_max, x_min, V_max, V_min, ...
                           Pbest_x, Gbest_x, Pbest_y, Gbest_y, ...
                           K_max, K_now, w_min, w_max);
    
    % Updating x, y & their veclocity matrix. 
    x_now = x_next; Vx_now = Vx_next; y_now = y_next; Vy_now = Vy_next;
    
    % Updating Pbest related. 
    [Pbest_x, Pbest_y] = ParticleFitness(x_now, y_now, requirement_pos, ...
                                         Pbest_x, Pbest_y);
    
    % Updating Gbest related. 
    [Gbest(K_now, 1), Gbest_x, Gbest_y] = SwarmFitness();
    
end

%% Fitness Plot
Plot_x = 1:1:K_max;
plot(Plot_x, Gbest, 'o');
axis([0, K_max, min(min(Gbest)), max(max(Gbest))]);
% legend('');
xlabel("Interation"); ylabel("Fitness");