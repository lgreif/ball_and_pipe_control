function [values] = create_lookup_table(device)
%Create lookup table of values by sweeping the usable range of PWM values
%   Detailed explanation goes here

start_value = 2800;
end_value = 2500;

set_pwm(device, 3000); % Initial burst to pick up ball
pause(0.5);

step_size = 20;

steps = start_value:step_size*-1:end_value;
sensor_readings = zeros((start_value - end_value)/step_size + 1,1);

% go to first step and stabilize before starting sweep
set_pwm(device,3000);
pause(4);


for i = steps
    set_pwm(device,i);
    pause(4);
    data = read_data(device);
    sensor_readings(i) = data(1);
end
steps
sensor_readings
values = [steps;sensor_readings]
end