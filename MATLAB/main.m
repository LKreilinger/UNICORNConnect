% Select your device
device ='COM7'; 


% Set up parameters
timeout = 5;
sampels = 10;

% Connect with Unicorn 
s = UnicornConnect(device, timeout);

% Get Data
% EEG (8), accelerometer (3), gyroscope (3), battery (1), and counter (1)
data = UnicornGetData(sampels, s);



% Do Something with data
% .
% .
% .

% Stop data acquesition
unicornStopAcq(s);