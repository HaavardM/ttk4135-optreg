%Running optimal trajectory script
addpath('../MatlabFiles/ex3_matlab_files');
run ex3_init;
close;

%Getting data from file
filename = '../data_ex3/ex3_q_10.mat';
m = matfile(filename);
data = m.ans;

%Data from encoders
time = data(1,:);
encoder_travel = data(2,:) + 180;
encoder_travel_rate = data(3,:);
encoder_pitch = data(4,:);
encoder_pitch_rate = data(5,:);

%Data from optimal trajectory
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
figure(1);
subplot(2,1,1);
plot(time, encoder_travel, 'r');
title('Measured travel trajectory vs optimal travel trajectory');
hold;
stairs(opt_time, opt_travel);
axis([0,time(1,length(time)), min(min(opt_travel),min(encoder_travel))-10, max(max(opt_travel),max(encoder_travel))+10]);
l = legend('Measured $\lambda$','Optimal $\lambda^*$','Interpreter', 'latex');
l.Location = 'east';
l.FontSize = 16;
xlabel('Time t [s]');
ylabel('Travel angle [°]');
grid on;

subplot(2,1,2);
plot(time, encoder_travel_rate, 'r');
title('Measured travel rate vs optimal travel rate');
hold;
stairs(opt_time, opt_travel_rate);
axis([0, time(1,length(time)), min(min(opt_travel_rate),min(encoder_travel_rate))-10, max(max(opt_travel_rate),max(encoder_travel_rate))+10]);
l = legend('Measured $r$','Optimal $r^*$','Interpreter','latex');
l.Location = 'southeast';
l.FontSize = 16;
xlabel('Time t [s]');
ylabel('Travel rate [°/s]');
grid on;

%Plotting the pitch and pitch rate
figure(2);
subplot(2,1,1);
plot(time, encoder_pitch, 'r');
title('Measured pitch vs optimal pitch vs optimal manipulated input pitch');
hold;
stairs(opt_time, opt_pitch);
stairs(opt_time, opt_input,'g');
axis([0,time(1,length(time)), min(min(opt_pitch),min(encoder_pitch))-10, max(max(opt_pitch),max(encoder_pitch))+30]);
l = legend('Measured $p$','Optimal $p^*$','Optimal input $p_c^*$ ','Interpreter','latex');
l.FontSize = 12;
xlabel('Time t [s]');
ylabel('Pitch angle [°]');
grid on;

subplot(2,1,2);
plot(time, encoder_pitch_rate, 'r');
title('Optimal pitch rate vs measured pitch rate');
hold;
stairs(opt_time, opt_pitch_rate);
axis([0, time(1,length(time)), min(min(opt_pitch_rate),min(encoder_pitch_rate))-10, max(max(opt_pitch_rate),max(encoder_pitch_rate))+10]);
l = legend('Measured $\dot{p}$','Optimal $\dot{p}^*$','Interpreter','latex');
l.Location = 'southeast';
l.FontSize = 16;
xlabel('Time t [s]');
ylabel('Pitch rate [°/s]');
grid on;

%Plotting the input u = p_c (optimal input pitch)
%versus the measured pitch angle
% figure;
% plot(time, encoder_pitch, 'r');
% title('Optimal input u = p_{c} vs measured pitch trajectory');
% hold;
% stairs(opt_input_time, opt_input);
% axis([0,time(1,length(time)), -40, 40]);
% legend('Measured pitch angle','Optimal input angle u');
% xlabel('Time t [s]');
% ylabel('Pitch angle [°]');
