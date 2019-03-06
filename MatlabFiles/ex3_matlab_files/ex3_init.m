%% Exercise 10.3
addpath('../ex2_matlab_files');
run ex_2 %Find optimal path and input

Q_lqr = diag([100 30 1 1]); %State weight
R_lqr = diag(0.1);         %Input weight

%Calculate discret LQR
[K,S,E] = dlqr(A1,B1,Q_lqr,R_lqr); 
