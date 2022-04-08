% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by YOUR NAME AND DATE

%% Start fresh
close all; clc; clear device;

%% Connect to device
str = input("What COM port do you have?",'s')
device = serialport(str, 19200);

% device = open serial communication in the proper COM port
%device = serialport("COM3", 19200);

%% Parameters
target      = 0.5;   % Desired height of the ball [m]
sample_rate = 0.25;  % Amount of time between controll actions [s]

%% Give an initial burst to lift ball and keep in air
set_pwm(device, "4000"); % Initial burst to pick up ball
pause(0.5) % Wait 0.1 seconds
% set_pwm(add_proper_args); % Set to lesser value to level out somewhere in
% the pipe

%% Initialize variables
% action      = ; % Same value of last set_pwm   
error       = 0;
error_sum   = 0;
rollInt = zeros(5, 1);

%% Feedback loop
while true
    %% Read current height
    data = read_data(device);
    height = data(1);
    y = ir2y(height); % Convert from IR reading to distance from bottom [m]
    
    %% Calculate errors for PID controller
    error_prev = error;             % D
    D = (error_prev - error) / 2;
    error      = target - y;        % P
    error_sum  = error + error_sum; % I

    %%Rolling integral
    rollInt(1:end-1) = rollInt(2:end);
    rollInt{end} = error;
    
    %% Control
    %prev_action = action;
    action = (0.4 - error)*1875 + 2000; % Come up with a scheme no answer is right but do something
    action = action + (sum(rollInt)*0.5); %Integral control
    action = floor(action);


%     if error > 0.4
%         action = 2000;
%     elseif error > 0.2
%         action = 2500;
%     elseif error < -0.2
%         action = 3000;
%     elseif error < -0.4
%         action = 3500;
%     else
%         error = 2750;
%     end

    set_pwm(device, action); % Implement action
        
    % Wait for next sample
    pause(sample_rate)
end

