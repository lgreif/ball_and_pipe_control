function [] = set_ball_height(device,height)
%SET BALL HEIGHT Summary of this function goes here
%   Detailed explanation goes here


data = read_data(device);
sensor_reading = data(1);

ball_needs_kick = 9999;

ball_move_up = 2800;
ball_hold_position = 2600;
ball_move_down = 2400;
height_bound = 5;

if ball_needs_kick < sensor_reading
    set_pwm(device, 3000); % Initial burst to pick up ball
    pause(0.5);
end
while true
    data = read_data(device);
    height = data(1);
    if height < height + height_bound
        set_pwm(device, ball_move_down);
    elseif height > height - height_bound
        set_pwm(device, ball_move_up);
    else
        set_pwm(device, ball_hold_position);
    end

end

                


%data = read_data(device);
%sensor_reading = data(1);

end