% TTK4135 - Helicopter lab
% Hints/template for problem 2.
% Updated spring 2018, Andreas L. Flåten

%% Initialization and model definition
init; % Change this to the init file corresponding to your helicopter
global N mx
% Discrete time system model. x = [lambda r p p_dot]'
delta_t	= 0.25; % sampling time
A1 = [1    delta_t     0                    0               0                       0;
      0       1    -K_2*delta_t             0               0                       0;
      0       0        1               delta_t              0                       0;
      0       0   -K_1*K_pp*delta_t   1-K_1*K_pd*delta_t    0                       0;
      0       0        0                    0               1                       delta_t;
      0       0        0                    0               -K_3*K_ep*delta_t       1-K_3*K_ed*delta_t];
            
B1 = [0     0       0   K_1*K_pp*delta_t    0       0;
      0     0       0       0               0       K_3*K_ep*delta_t]';

%% Number of states and inputs
mx = size(A1,2); % Number of states (number of columns in A)
mu = size(B1,2); % Number of inputs(number of columns in B)

%% Initial values
x1_0 = pi;                               % Lambda
x2_0 = 0;                               % r
x3_0 = 0;                               % p
x4_0 = 0;                               % p_dot
x5_0 = 0;                               % e
x6_0 = 0;                               % e_dot
x0 = [x1_0 x2_0 x3_0 x4_0 x5_0 x6_0]';           % Initial values

%% Time horizon and initialization
N  = 60;                                % Time horizon for states
M  = N;                                 % Time horizon for inputs
z  = zeros(N*mx+M*mu,1);                % Initialize z for the whole horizon
z0 = z;                                 % Initial value for optimization

%% Bounds
u1l 	= -pi/6;                         % Lower bound on control
u1u 	= pi/6;                         % Upper bound on control
u2l     = -Inf;              % Lower bound on states (no bound)
u2u     = Inf;               % Upper bound on states (no bound)
ul      = [u1l u2l]';
uu      = [u1u u2u]';
xl      = -Inf*ones(mx,1);              % Lower bound on states (no bound)
xu      = Inf*ones(mx,1);               % Upper bound on states (no bound)
xl(3)   = ul(1);                           % Lower bound on state x3
xu(3)   = uu(1);                           % Upper bound on state x3

% Generate constraints on measurements and inputs
[vlb,vub]       = gen_constraints(N, M, xl, xu, ul, uu); % hint: gen_constraints
vlb(N*mx+M*mu-1: end)  = [0 0]';               % We want the last input to be zero
vub(N*mx+M*mu-1: end)  = [0 0]';               % We want the last input to be zero

% Generate the matrix Q and the vector c (objecitve function weights in the QP problem) 
Q1 = zeros(mx,mx);
Q1(1,1) = 1;                            % Weight on state x1
Q1(2,2) = 0;                            % Weight on state x2
Q1(3,3) = 0;                            % Weight on state x3
Q1(4,4) = 0;                            % Weight on state x4
Q1(5,5) = 0;                            % Weight on state x5
Q1(6,6) = 0;                            % Weight on state x6
P = zeros(mu,mu);
q_1 = 0.1;
q_2 = 0.1;
P1 = q_1*2;
P2 = q_2*2;
P(1,1) = P1;                            % Weight on pitch input
P(2,2) = P2;                            % Weight on elevation input
Q = gen_q(Q1, P, N, M);                                  % Generate Q, hint: gen_q

%% Generate system matrixes for linear model
Aeq = gen_aeq(A1,B1,N,mx,mu);               % Generate A
beq = zeros(size(Aeq, 1), 1);               % Generate b
beq(1:mx) = A1*x0;

%% Solve QP problem with linear modelbeta = 20;
F_cost = @(z) (1/2) * z' * Q * z;
tic;
opt = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxFunEvals', 400000);
Z = fmincon(F_cost, z0, [], [], Aeq, beq, vlb, vub, @mycon, opt);
t1=toc;

%% Extract control inputs and states
u1  = [Z(N*mx+1:mu:N*mx+M*mu);Z(N*mx+M*mu-1)]; % Control input from solution
u2  = [Z(N*mx+2:mu:N*mx+M*mu);Z(N*mx+M*mu)]; % Control input from solution

x1 = [x0(1);Z(1:mx:N*mx)];              % State x1 from solution
x2 = [x0(2);Z(2:mx:N*mx)];              % State x2 from solution
x3 = [x0(3);Z(3:mx:N*mx)];              % State x3 from solution
x4 = [x0(4);Z(4:mx:N*mx)];              % State x4 from solution
x5 = [x0(5);Z(5:mx:N*mx)];              % State x5 from solutio
x6 = [x0(6);Z(6:mx:N*mx)];              % State x6 from solutio

%%Padding: adding zeros before and after states and input
num_variables = 5/delta_t;
zero_padding = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);

u1  = [zero_padding; u1; zero_padding];
u2  = [zero_padding; u2; zero_padding];
x1  = [pi*unit_padding; x1; zero_padding];
x2  = [zero_padding; x2; zero_padding];
x3  = [zero_padding; x3; zero_padding];
x4  = [zero_padding; x4; zero_padding];
x5  = [zero_padding; x5; zero_padding];
x6  = [zero_padding; x6; zero_padding];

%% Plotting
t = 0:delta_t:delta_t*(length(u1)-1);

figure(2)
subplot(511)
stairs(t,u1),grid
ylabel('u1')
title(sprintf('Optimal travel path with output weight q = %.2f', P1));
subplot(512)
plot(t,x1,'m',t,x1,'mo'),grid
ylabel('lambda')
subplot(513)
plot(t,x2,'m',t,x2','mo'),grid
ylabel('r')
subplot(514)
plot(t,x3,'m',t,x3,'mo'),grid
ylabel('p')
subplot(515)
plot(t,x4,'m',t,x4','mo'),grid
xlabel('tid (s)'),ylabel('pdot')
close;

figure(3)
subplot(411)
stairs(t,x1),grid
ylabel('lambda')
title(sprintf('Optimal travel and elevation path with output weight q_1 = q_2 = %.2f', q_1));
subplot(412)
plot(t,x5,'m',t,x5,'mo'),grid
ylabel('elevation')
subplot(413)
plot(t,u1,'m',t,u1,'mo'),grid
ylabel('pitch')


opt_x = [t', x1, x2, x3, x4, x5, x6];
opt_u = [t', u1, u2];