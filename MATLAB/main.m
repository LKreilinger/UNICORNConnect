% Select your device
device ='COM9'; 


% Set up parameters
recTime = 120; % in seconds

timeout = 5; % wait until UNICORN response
fs = 250; % sampling rate UNICORN
sampels = fs * recTime;

% Connect with Unicorn 
s = UnicornConnect(device, timeout);

%% Get Data
% EEG/µV (8), accelerometer xyz /g (3), gyroscope xyz / (°/s) (3), battery / % (1), and counter (1)
data = UnicornGetData(sampels, s);



% Do Something with data
% .
% .
% .

%% Stop data acquesition
% UNICORN Bluetooth commands
stop_acq =          [0x63, 0x5C, 0xC5]';

fwrite(s, stop_acq);
clear s;