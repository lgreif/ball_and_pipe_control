function [values] = create_lookup_table(device)
%Create lookup table of values by sweeping the usable range of PWM values
%   Detailed explanation goes here

start_value = 1650;
end_value = 1950;

set_pwm(device, 3000); % Initial burst to pick up ball
pause(0.5);

steps = start_value:5:end_value;
sensor_readings = zeros(size(steps),1);

% go to first step and stabilize before starting sweep
set_pwm(device,start_value;
pause(10);


for i = steps
    set_pwm(device,i);
    pause(0.5);
    sensor_readings[i] = read_data(device)(1);
end

values = [steps;sensor_readings]
end