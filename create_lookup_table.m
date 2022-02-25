function [values] = create_lookup_table(device)
%Create lookup table of values by sweeping the usable range of PWM values
%   Detailed explanation goes here

start_value = 123;
end_value = 333;

set_pwm(device, 1950); % Initial burst to pick up ball
pause(0.1) % Wait 0.1 seconds

steps = start_value:5:end_value;
sensor_readings = zeros(size(steps),1);


for i = steps
    set_pwm(device,i);
    pause(0.1);
    sensor_readings[i] = read_data(device)(1);
end

values = [steps;sensor_readings]
end