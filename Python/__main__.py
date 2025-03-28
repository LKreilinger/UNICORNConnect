import numpy as np
from UNICORNConnect import UNICORNDevice
from UNICORNGetData import UNICORNGetData
if __name__ == '__main__':
    # Select your device
    device = 'COM9'

    # Set up parameters
    recTime = 2  # in seconds
    timeout = 5 # wait until UNICORN response
    nchan = 16
    fs = 250 # sampling rate UNICORN
    samples = fs * recTime

    # Connect with Unicorn 
    unicorn_device = UNICORNDevice(device, timeout)
    unicorn_device.connect()
    ser = unicorn_device.serial_conn()

    # Get data
    # EEG/µV (8), accelerometer xyz /g (3), gyroscope xyz / (°/s) (3), battery / % (1), and counter (1)
    data = UNICORNGetData(ser, samples)
    