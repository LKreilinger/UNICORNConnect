import numpy as np
from UNICORNConnect import UNICORNDevice

if __name__ == '__main__':
    # Select your device
    device = 'COM9'

    # Set up parameters
    recTime = 2  # in seconds
    timeout = 5 # wait until UNICORN response
    nchan = 16
    fs = 250 # sampling rate UNICORN
    samples = fs * recTime

    unicorn_device = UNICORNDevice(device, timeout)
    unicorn_device.connect()