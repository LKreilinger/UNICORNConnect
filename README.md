# UNICORNConnect
Connect with EEG System UNICORN from g.tec. Other software is not required.

## UNICORN MATLAB Program

This MATLAB program allows you to connect to your g.tec UNICORN device, acquire data, process it, and then stop the data acquisition.

1. Enter your device's COM port.
2. Set the sampling rate, timeout, and recording time.
3. Connect to the device using the UnicornConnect function.
4. Fetch data from UNICORN using UnicornGetData.
5. Process the data as needed.
6. Stop data acquisition using the stop_acq command and clear the connection.


## UNICORN Python Program

This Python script communicates with your g.tec UNICORN device through a serial interface. 

1. Set up the device's COM port, timeout, number of samples, and number of channels.
2. Use Python's serial library to connect to the UNICORN device.
3. Start data acquisition with the start_acq command.
4. Read and process the data from the device, including accelerometer, gyroscope, and EEG data.
5. Stop data acquisition with the stop_acq command and close the connection with the device.


