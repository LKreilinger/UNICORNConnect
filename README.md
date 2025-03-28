# UNICORNConnect
UNICORNConnect enables direct connection and data acquisition from the g.tec's UNICORN EEG System using MATLAB or Python, without the need for any additional software.
To check payload conversion, see pdf
https://github.com/unicorn-bi/Unicorn-Suite-Hybrid-Black/blob/master/Unicorn%20Bluetooth%20Protocol/UnicornBluetoothProtocol.pdf

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
1. Install requirements
```bash 
pip install -r requirements.txt
```
2. Set up the device's COM port, timeout, number of samples, and number of channels.
4. Connect to the device using UnicornConnect.py
5. Fetch data from UNICORN using UnicornGetData.py


