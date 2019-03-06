%Getting data from file
filename = '../data_ex4/ex2q1.mat';
m = matfile(filename);
data = m.ans;

%Running optimal path script
addpath('../MatlabFiles/ex2_matlab_files');
run ex_2;
close;

%Data from encoders
time = data(1,:);
encoder_travel = data(2,:) + 180;
encoder_travel_rate = data(3,:);
encoder_pitch = data(4,:);
encoder_pitch_rate = data(5,:);

%Data from optimal path
opt_x = opt_x';
opt_time = opt_x(1,:);
opt_travel = 180/pi .* opt_x(2,:);
opt_travel_rate = 180/pi .* opt_x(3,:);
opt_pitch = 180/pi .* opt_x(4,:);
opt_pitch_rate = 180/pi .* opt_x(5,:);

opt_u = opt_u';
opt_input_time = opt_u(1,:);
opt_input = 180/pi .* opt_u(2,:);

%Plotting the travel and travel rate
figure;
subplot(2,1,1);
plot(time, encoder_travel, 'r');
title('Optimal travel path vs measured travel path');
hold;
stairs(opt_time, opt_travel);
axis([0,20, -40, 240]);
legend('Measured travel angle','Optimal travel angle');
xlabel('Time t [s]');
ylabel('Travel angle [°]');

subplot(2,1,2);
plot(time, encoder_travel_rate, 'r');
title('Optimal travel rate path vs measured travel rate path');
hold;
stairs(opt_time, opt_travel_rate);
axis([0, 20, -60, 30]);
l = legend('Measured travel rate','Optimal travel rate');
l.Location = 'southeast';
xlabel('Time t [s]');
ylabel('Travel rate [°/s]');
print -depsc ex2_travel_q01

%Plotting the pitch and pitch rate
figure;
subplot(2,1,1);
plot(time, encoder_pitch, 'r');
title('Optimal pitch path vs measured pitch path');
hold;
stairs(opt_time, opt_pitch);
axis([0,20, -40, 40]);
legend('Measured pitch angle','Optimal pitch angle');
xlabel('Time t [s]');
ylabel('Pitch angle [°]');

subplot(2,1,2);
plot(time, encoder_pitch_rate, 'r');
title('Optimal pitch rate path vs measured pitch rate path');
hold;
stairs(opt_time, opt_pitch_rate);
axis([0, 20, -60, 50]);
l = legend('Measured pitch rate','Optimal pitch rate');
l.Location = 'southeast';
xlabel('Time t [s]');
ylabel('Pitch rate [°/s]');

%Plotting the input u = p_c (optimal input pitch)
%versus the measured pitch angle
figure;
plot(time, encoder_pitch, 'r');
title('Optimal input u = p_{c} vs measured pitch path');
hold;
stairs(opt_input_time, opt_input);
axis([0,20, -40, 40]);
legend('Measured pitch angle','Optimal input angle u');
xlabel('Time t [s]');
ylabel('Pitch angle [°]');
