function [distance,manual_pwm,target,deadpan] = read_data(device)
%% Reads data sent back from Ball and Pipe system
% Inputs:
%  ~ device: serialport object controlling the real world system
% Outputs:
%  ~ distance: the IR reading from the time of flight sensor
%  ~ pwm: the PWM from the manual knob of the system (NOT THE SAME AS THE
%  PWM YOU MAY SET THROUGH SERIAL COMMUNICATION)
%  ~ target: the desired height of the ball set by the manual knob of the
%  system
%  ~ deadpan: the time delay after an action set by the manual knob of the
%  system
%
% Created by:  Kyle Naddeo 1/3/2022
% Modified by: Jack Campanella 2/24/2022
% Modified by: Robbie Sunbury 2/5/2022

% Needs to be modified and tested with ball and tube in class

%% Ask nicely for data
% use the serialport() command options to write the correct letter to the
% system (Hint: the letters are in the spec sheet)
write(device, "S", "string");
pause(0.1);

%% Read data
% use the serialport() command options to read the response
resultStr = read(device, 20, "string");
resultStrSplit = split(resultStr, ",");

resultStrSplit(1) = extractBetween(resultStrSplit(1), 2, 5);%Remove semicolon

%% Translate
% translate the response to 4 doubles using str2double() and
% extractBetween() (Hint: the response is in the spec sheet)
distance   = str2double(resultStrSplit(1));
manual_pwm = str2double(resultStrSplit(2));
target     = str2double(resultStrSplit(3));
deadpan    = str2double(resultStrSplit(4));

end