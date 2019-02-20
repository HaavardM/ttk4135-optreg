run init.m
%%
Dt = 0.25;
N = 10;
q = 4;
lambda_f = 20;
A = [1 Dt 0 0;
    0 10 -K_2*Dt 0;
    0 0 1 Dt;
    0 0 -K_1*K_pp*Dt 1-K_1*K_pd*Dt];
B = [0; 0; 0; K_1*K_pp*Dt];


%% Merging optimalization and control note on blackboard page 34
R = zeros(4);
R(1,1) = 1;

l_H = kron(eye(N), R);
p_H = kron(eye(N), q);
H = [l_H zeros(N*4, N);
    zeros(N, N*4) p_H];

l_f = kron(eye(N), R*2*lambda_f);
p_f = zeros(N);
f = [l_f zeros(N*4, N);
    zeros(N, N*4) p_f];

A_eye = eye(N*4);
A_mini = kron(eye(N-1), -A);
A_big = [zeros(4, N*4);
        A_mini zeros(N*4-4,4)];
A_final = A_big + A_eye    


