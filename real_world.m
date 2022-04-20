% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by YOUR NAME AND DATE

%% Start fresh
close all; clc; clear device;

%% Connect to device
%str = input("What COM port do you have?",'s')
str = "COM3"; %CHANGE THIS
device = serialport(str, 19200);
flush(device);

write(device, 'H', 'string')

set_pwm(device, 0);

% device = open serial communication in the proper COM port
%device = serialport("COM3", 19200);

%% Parameters
strTarg = input("Desired height in meters?",'s')
target      = str2double(strTarg);   % Desired height of the ball [m]
sample_rate = 0.01;  % Amount of time between controll actions [s]

%% Give an initial burst to lift ball and keep in air
%set_pwm(device, "4000"); % Initial burst to pick up ball
pause(0.1) % Wait 0.1 seconds
% set_pwm(add_proper_args); % Set to lesser value to level out somewhere in
% the pipe

%% Initialize variables
% action      = ; % Same value of last set_pwm   
error_prev = 0;
error       = 0;
error_sum   = 0;
cycles = 20;
currCycles = 0;
heavyBall = 1;

%% Feedback loop
while true
    %% Read current height
    data = read_data(device);
    height = data(1);
    disp(height)
    y = ir2y(height); % Convert from IR reading to distance from bottom [m]
    
    %Ball Characterization
    if (cycles > currCycles)
        set_pwm(device, 2500);
        if(y < 900)
            heavyBall = heavyBall + 1;
        end
        currCycles = currCycles + 1;
    %Final Control Loop
    else
        %% Calculate errors for PID controller
        error_prev2 = error_prev;
        error_prev = error;             % D
        error      = target - y;        % P
        error_sum  = -error + error_sum; % I
        D = (error_prev - error) / 0.02;   % D
        %D2 = (error - 2* error_prev + error_prev2); %D2
        
        %% Control
        %prev_action = action;
        action = (0.7 - error) * 4000 + 350*D; %+ error_sum*50
        %action = 1500 + -15000*D + 100*error_sum; % Come up with a scheme no answer is right but do something
        %action = action + error_sum; %Integral control
        action = floor(action);
    
        %Floor/ceiling
        if action > 3400
             action = 3400;
        elseif action < 1600
             action = 1600;
        end
    
        %Secondary Control Loop
        if abs(error) < 0.1
            "happy!"
            %Control the ball in it's happy place
            if heavyBall==1
                if D < 0
                    D = -0.5;
                end
                action = floor(2550 + 250*D);
            else
                if D < 0
                    D = -0.5;
                end
                action = floor(2000 + 60*D);
            end
        end
    
        set_pwm(device, action); % Implement action
            
        % Wait for next sample
    end
   
    %Delay
    pause(sample_rate)
end

