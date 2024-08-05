import serial

class UNICORNDevice:
    def __init__(self, device, timeout):
        self.device = device
        self.timeout = timeout
        self.start_acq = [0x61, 0x7C, 0x87]
        self.start_response = [0x00, 0x00, 0x00]
        self._ser = None  # Use _ prefix to indicate it should not be accessed directly

    def connect(self):
        # Method to connect to the device
        self._ser = serial.Serial(self.device, 115200, timeout=self.timeout)
        self._ser.reset_input_buffer()
        self._ser.write(bytearray(self.start_acq))

        payload = self._ser.read(3)

        if payload == bytearray(self.start_response):
            print('Connection with Unicorn successful!')
        else:
            raise Exception(f'Unsuccessful start data stream on port: {self.device}')
            

    def serial_conn(self):
        # Method to access the serial port object
        if self._ser is None:
            raise Exception('Device not yet connected. Use connect() method first.')
        return self._ser
