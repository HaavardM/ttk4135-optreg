%% Exercise 10.3
addpath('../ex2_matlab_files');
run ex_2 %Find optimal path and input

Q_lqr = diag([1 1 0 0]); %State weight
R_lqr = diag(1);         %Input weight

%Calculate discret LQR
[K,S,E] = dlqr(A1,B1,Q_lqr,R_lqr); 

figure();
f = load('ex3.mat');
