# UNICORNConnect
[![DOI](https://zenodo.org/badge/823541940.svg)](https://doi.org/10.5281/zenodo.23213189)

UNICORNConnect enables direct connection and data acquisition from the g.tec's UNICORN EEG System using MATLAB or Python, without the need for any additional software.
To check payload conversion, see pdf
https://github.com/unicorn-bi/Unicorn-Suite-Hybrid-Black/blob/master/Unicorn%20Bluetooth%20Protocol/UnicornBluetoothProtocol.pdf

## Requirements

- A g.tec UNICORN headset and a computer with Bluetooth.
- MATLAB: R2019b or newer (uses `serialport`).
- Python: 3.9 or newer, with the packages in `Python/requirements.txt`.

## Find the COM port

1. Switch the UNICORN on and pair it in the Bluetooth settings of your operating system.
2. On Windows, open the Device Manager and look under "Ports (COM & LPT)" for the serial port of the UNICORN (for example `COM9`). If two ports are listed, use the outgoing one.
3. Enter this port as `device` in `MATLAB/main.m` or `Python/__main__.py`.

## UNICORN MATLAB Program

This MATLAB program allows you to connect to your g.tec UNICORN device, acquire data, process it, and then stop the data acquisition.
Open the `MATLAB` folder in MATLAB and run `main.m`.

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
cd Python
pip install -r requirements.txt
```
2. Set up the device's COM port, timeout, and recording time in `__main__.py`.
3. Run the script
```bash
python __main__.py
```
4. The script connects to the device using `UNICORNDevice` from `UNICORNConnect.py`.
5. It fetches data from UNICORN using `UNICORNGetData` from `UNICORNGetData.py`.
6. It stops the data acquisition and closes the port using `disconnect()`.

## Data format

Both programs return a matrix with one row per sample (250 samples per second) and 16 columns:

| Columns | Content | Unit |
|---|---|---|
| 1-8 | EEG channels 1-8 | µV |
| 9-11 | Accelerometer x, y, z | g |
| 12-14 | Gyroscope x, y, z | °/s |
| 15 | Battery level | % |
| 16 | Sample counter | - |

If a packet is lost or damaged, the programs skip to the next valid packet and show a warning. The lost samples are not filled in, so they are visible as a jump in the sample counter.

## Disclaimer

This is an independent project. It is not affiliated with, endorsed by, or supported by g.tec medical engineering GmbH. "Unicorn" and "g.tec" are trademarks of their respective owners. The software is provided as is, without warranty, and is not a medical device.

## Citation

If you use UNICORNConnect in your work, please cite it. GitHub offers a ready-made reference under "Cite this repository" (generated from [CITATION.cff](CITATION.cff)). For example:

> Kreilinger, L. UNICORNConnect [Computer software]. https://doi.org/10.5281/zenodo.23213189

```bibtex
@software{kreilinger_unicornconnect,
  author = {Kreilinger, Laurens},
  title  = {UNICORNConnect},
  doi    = {10.5281/zenodo.23213189},
  url    = {https://github.com/LKreilinger/UNICORNConnect}
}
```

The DOI above always points to the latest release. To cite exactly version 1.0.0, use https://doi.org/10.5281/zenodo.23213190.

## License

Apache License 2.0, see [LICENSE](LICENSE).
