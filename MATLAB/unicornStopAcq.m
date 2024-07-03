function unicornStopAcq(s)
% This function stops connection to a Unicorn device.
% Input: 
% - s (serialport object) - a serial port object representing the open connection to the Unicorn device

fwrite(s, stop_acq);
clear s;
