import numpy as np
from UNICORNConnect import UNICORNDevice

def accel_calculation(payload, index):
    accel = np.zeros(3)
    for i in range(3):
        value = (payload[index + i * 2] + payload[index + 1 + i * 2] * 256)
        if value & (1 << 15):  # Check the sign bit
            value -= 1 << 16
        accel[i] = value / 4096.0  # convert in Acceleration [g]
    return accel


def gyro_calculation(payload, index):
    gyro = np.zeros(3)
    for i in range(3):
        value = (payload[index + i * 2] + payload[index + 1 + i * 2] * 256)
        if value & (1 << 15):  # Check the sign bit
            value -= 1 << 16
        gyro[i] = value / 32.8  # convert in Angular Velocity [°/s]
    return gyro

def UNICORNGetData(ser, samples):
    # Set up parameters
    nchan = 16

    # UNICORN Bluetooth commands
    start_sequence = [0xC0, 0x00]
    stop_sequence = [0x0D, 0x0A]

    data = np.zeros([samples, nchan])

    for sample in range(samples):
        payload = ser.read(45)
        # to check payload conversion, results in pdf
        # % https://github.com/unicorn-bi/Unicorn-Suite-Hybrid-Black/blob/master/Unicorn%20Bluetooth%20Protocol/UnicornBluetoothProtocol.pdf
        #payload = np.array(
        #    [0xC0, 0x00, 0x0F, 0x00, 0x9F, 0xAF, 0x00, 0x9F, 0xD4, 0x00, 0xA0, 0x40, 0x00, 0x9F, 0x43, 0x00, 0x9F, 0x9A,
        #     0x00, 0x9F, 0xE3, 0x00, 0x9F, 0x85, 0x00, 0x9F, 0xBB, 0x2E, 0xF6, 0xE9, 0x02, 0x8D, 0xF2, 0xF3, 0xFF, 0xEF,
        #     0xFF, 0x23, 0x00, 0xB0, 0x00, 0x00, 0x00, 0x0D, 0x0A], dtype=np.uint8)
        # payload = bytearray(payload)
        if payload[0:2] != bytearray(start_sequence):
            raise Exception("Invalid packet")
        if payload[43:45] != bytearray(stop_sequence):
            raise Exception("Invalid packet")

        battery = (100 * payload[2] & 15) / 15

        eeg = np.zeros(8)
        for ch in range(8):
            data_bytes = payload[3 + ch * 3: 6 + ch * 3 + 1]
            eegv = data_bytes[0] * 256 ** 2 + data_bytes[1] * 256 + data_bytes[2]
            if eegv & (1 << 23):
                eegv -= 1 << 24
            eeg[ch] = eegv * 4500000 / 50331642

        accel = accel_calculation(payload, 27)

        gyro = gyro_calculation(payload, 33)

        counter = payload[39] + payload[40] * 256 + payload[41] * 65536 + payload[42] * 16777216

        data[sample, :] = np.concatenate([eeg, accel, gyro, [battery], [counter]])

        return data