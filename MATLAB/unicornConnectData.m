% Clear workspace and command window
clear;
clc;

% Set up parameters
timeout = 5;
nchan = 16;
sampels = 10;
%%%%%%%%%%%%%%%%%%%
device ='COM7'; %%% change as needed
%%%%%%%%%%%%%%%%%%%

% UNICORN Bluetooth commands
start_acq =         [0x61, 0x7C, 0x87]';
start_response =    [0x00, 0x00, 0x00]';
start_sequence =    [0xC0, 0x00]';
stop_sequence =     [0x0D, 0x0A]';
stop_response =     start_response;
stop_acq =          [0x63, 0x5C, 0xC5]';


 s = serialport(device, 115200, 'Timeout', timeout);
        disp(['Connected to serial port ', device]);
        fopen(s);
        if strcmp(s.Status, 'open')
            fwrite(s, start_acq);
        else
            error('Port is not open');
        end

        disp(['Started Unicorn on port ', device]);

        % check if first 3 bytes are 0
        payload = fread(s, 3, 'uint8');
        if ~isequal(payload, start_response)
            error(append('Unsuccessful start data stream on port:', device));
        end
%% collect data; Important bytes alway + 1 (Matlab starts with 1)
data = zeros(sampels, nchan);
accel = zeros(1,3);
gyro = zeros(1,3);
for sampel=1:sampels

    payload = fread(s, 45, 'uint8');
    % Check if payload conversion is correct 
    % https://github.com/unicorn-bi/Unicorn-Suite-Hybrid-Black/blob/master/Unicorn%20Bluetooth%20Protocol/UnicornBluetoothProtocol.pdf
    % payload = double([0xC0 0x00 0x0F 0x00 0x9F 0xAF 0x00 0x9F 0xD4 0x00 0xA0 0x40 0x00 0x9F 0x43 0x00 0x9F 0x9A 0x00 0x9F 0xE3 0x00 0x9F 0x85 0x00 0x9F 0xBB 0x2E 0xF6 0xE9 0x02 0x8D 0xF2 0xF3 0xFF 0xEF 0xFF 0x23 0x00 0xB0 0x00 0x00 0x00 0x0D 0x0A]');

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

    % Combine the values into 'dat'
    data(sampel,:) = [eeg, accel, gyro, battery, counter];

end

%% Stop data acquisition
fwrite(s, stop_acq);
clear s;

