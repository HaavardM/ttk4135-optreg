addpath('../ex2_matlab_files');
run ex_2

Q_lqr = diag([1 1 0 0]);
R_lqr = diag(1);

[K,S,E] = dlqr(A1,B1,Q_lqr,R_lqr);



figure;

f = load('ex3.mat');
