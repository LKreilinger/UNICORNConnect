function data = UnicornGetData(sampels, s)
% This function collects a specific number of samples of data from a Unicorn 
% device via an open serial port connection. 
%
% Inputs:
% samples (integer) - number of samples to be collected from the Unicorn device
% s (serialport object) - the serial port object representing the connection 
% to the Unicorn device
%
% Output:
% data (matrix) - a matrix containing the collected data, with each row representing a sample
% and each column representing a data point (EEG (8), accelerometer (3), gyroscope (3), battery (1), and counter (1))

% Set up parameters
nchan = 16;

% UNICORN Bluetooth commands
start_response =    [0x00, 0x00, 0x00]';
start_sequence =    [0xC0, 0x00]';
stop_sequence =     [0x0D, 0x0A]';
%% collect data; Important bytes alway + 1 (Matlab starts with 1)
data = zeros(sampels, nchan);
accel = zeros(1,3);
gyro = zeros(1,3);
for sampel=1:sampels

    payload = fread(s, 45, 'uint8');

    if ~isequal(payload(1:2), start_sequence)
        error('Invalid packet');
    end
    if ~isequal(payload(44:45), stop_sequence)
        error('Invalid packet');
    end

    battery = 100 * bitand(payload(3), 15) / 15;

    % EEG Calculation
    eeg = zeros(1,8);
    for ch = 1:8
        data_bytes = payload(4 + (ch - 1) * 3: 6 + (ch - 1) * 3);
        eegv = data_bytes(1) * 256^2 + data_bytes(2) * 256 + data_bytes(3);
        if bitget(eegv, 24) % Check the sign bit
            eegv = eegv - 2^24;
        end
        eeg(ch) = double(eegv) * 4500000 / 50331642; % Convert the integer value to microvolts
    end

    % Accelerometer Calculation
    accel(1) = payload(29) * 256 + payload(28); % accx
    if bitget(accel(1), 16) % Check the sign bit
        accel(1) = accel(1) - 2^16;
    end
    accel(2) = payload(31) * 256 + payload(30); % accy
    if bitget(accel(2), 16) % Check the sign bit
        accel(2) = accel(2) - 2^16;
    end
    accel(3) = payload(33) * 256 + payload(32); % accz
    if bitget(accel(3), 16) % Check the sign bit
        accel(3) = accel(3) - 2^16;
    end
    accel = accel / 4096; % convert in Acceleration [g]

    % Gyroscope Calculation
    gyro(1) = payload(34) + payload(35) * 256; % accx
    if bitget(gyro(1), 16) % Check the sign bit
        gyro(1) = gyro(1) - 2^16;
    end
    gyro(2) = payload(36) + payload(37) * 256 ; % accy
    if bitget(gyro(2), 16) % Check the sign bit
        gyro(2) = gyro(2) - 2^16;
    end
    gyro(3) = payload(38) + payload(39) * 256; % accz
    if bitget(gyro(3), 16) % Check the sign bit
        gyro(3) = gyro(3) - 2^16;
    end
    gyro = gyro / 32.8; % convert in Angular Velocity [°/s]

    % Counter Calculation
    counter = payload(40) + payload(41) * 256 + payload(42) * 65536 + payload(43) * 16777216;

    % Combine the values into 'data'
    data(sampel,:) = [eeg, accel, gyro, battery, counter];

end