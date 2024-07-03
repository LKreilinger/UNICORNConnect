function [s] = UnicornConnect(device, timeout)
% This function connects to a Unicorn device through a specified port and initiates data acquisition.
% Input: 
% - 'device' (string): which is the name of the serial port connected to the device (e.g., 'COM7')
% - 'timeout' (number): which is the time in seconds for the connection timeout
% Output:
% s (serialport object) - a serial port object representing the open connection to the Unicorn device

% UNICORN Bluetooth commands
start_acq =         [0x61, 0x7C, 0x87]';
start_response =    [0x00, 0x00, 0x00]';


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
