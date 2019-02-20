%Getting data from file
filename = '../data_ex4/ex4_q_01_w_feedback.mat';
m = matfile(filename);
data = m.ans;

%Running optimal path script
addpath('../MatlabFiles/ex4_matlab_files');
run ex4;
close;

%Data from encoders
time = data(1,:);
encoder_travel = data(2,:) + 180;
encoder_travel_rate = data(3,:);
encoder_pitch = data(4,:);
encoder_pitch_rate = data(5,:);
encoder_elevation = data(6,:);
encoder_elevation_rate = data(7,:);

%Data from optimal path
opt_x = opt_x';
opt_time = opt_x(1,:);
opt_travel = 180/pi .* opt_x(2,:);
opt_travel_rate = 180/pi .* opt_x(3,:);
opt_pitch = 180/pi .* opt_x(4,:);
opt_pitch_rate = 180/pi .* opt_x(5,:);
opt_elevation = 180/pi .* opt_x(6,:);
opt_elevation_rate = 180/pi .* opt_x(7,:);

opt_u = opt_u';
opt_input_time = opt_u(1,:);
opt_input_pitch = 180/pi .* opt_u(2,:);
opt_input_elevation = 180/pi .* opt_u(3,:);

%Plotting the travel and travel rate
figure;
subplot(2,1,1);
plot(time, encoder_travel, 'r');P
title('Optimal travel path vs measured travel path');
hold;
stairs(opt_time, opt_travel);
axis([0,20, -40, 200]);
legend('Measured travel angle','Optimal travel angle');
xlabel('Time t [s]');
ylabel('Travel angle [°]');

subplot(2,1,2);
plot(time, encoder_travel_rate, 'r');
title('Optimal travel rate path vs measured travel rate path');
hold;
stairs(opt_time, opt_travel_rate);
axis([0, 20, -40, 10]);
legend('Measured travel rate','Optimal travel rate');
xlabel('Time t [s]');
ylabel('Travel rate [°/s]');

%Plotting the pitch and pitch rate
figure;
subplot(2,1,1);
plot(time, encoder_pitch, 'r');
title('Optimal pitch path vs measured pitch path');
hold;
stairs(opt_time, opt_pitch);
axis([0,20, -20, 30]);
legend('Measured pitch angle','Optimal pitch angle');
xlabel('Time t [s]');
ylabel('Pitch angle [°]');

subplot(2,1,2);
plot(time, encoder_pitch_rate, 'r');
title('Optimal pitch rate path vs measured pitch rate path');
hold;
stairs(opt_time, opt_pitch_rate);
axis([0, 20, -20, 30]);
legend('Measured pitch rate','Optimal pitch rate');
xlabel('Time t [s]');
ylabel('Pitch rate [°/s]');

%Plotting the input u = p_c (optimal input pitch)
%versus the measured pitch angle
figure;
plot(time, encoder_pitch, 'r');
title('Optimal input u = p_{c} vs measured pitch path');
hold;
stairs(opt_input_time, opt_input);
axis([0,20, -15, 35]);
legend('Measured pitch angle','Optimal input angle u');
xlabel('Time t [s]');
ylabel('Pitch angle [°]');

close all;

%Plot elevation
figure;
plot(time, encoder_elevation, 'r');
title('Optimal elevation vs measured elevation');
hold;
stairs(opt_time, opt_elevation);
axis([0,20, -30, 35]);
