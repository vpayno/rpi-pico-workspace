# Raspberry Pico SDK Experiments

Journaling [Raspberry Pico SDK](https://www.raspberrypi.com/documentation/microcontrollers/c_sdk.html) experiments here.

## Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Pico SDK Documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-c-sdk.pdf)

## Installing Tools

The Pico SDK is installed in this repo as a git submodule.

Install dependencies:

```bash { background=false category=install-picosdk closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=install-picosdk-dependencies promptEnv=true terminalRows=25 }
nala install -y --no-auto-remove gdb-multiarch automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev
```

```bash { background=false category=install-picosdk closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=install-picosdk-update promptEnv=true terminalRows=25 }
cd pico-sdk
git pull
git submodule update --init
```

## Updating the Pico

To put the Pico/Pico W in update mode,

- disconnect the usb cable
- hold the `BOOTSEL` Button
- connect the usb cable
- let go of the `BOOTSEL` Button
