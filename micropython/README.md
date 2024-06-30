# Raspberry MicroPython Experiments

Journaling [Raspberry MicroPython](https://www.raspberrypi.com/documentation/microcontrollers/micropython.html) experiments here.

## Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Pico MicroPython RP2 Documentation](https://docs.micropython.org/en/latest/rp2/quickref.html)
- [Pico MicroPython SDK Manual](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-python-sdk.pdf)
- [Pico MicroPython Downloads](https://micropython.org/download/?vendor=Raspberry%20Pi)
- [Pico MicroPython RP2 Library](https://docs.micropython.org/en/latest/library/rp2.html)

## Updating the Pico

To put the Pico/Pico W in update mode,

- disconnect the usb cable
- hold the `BOOTSEL` Button
- connect the usb cable
- let go of the `BOOTSEL` Button

### Install/Update MicroPython on the Pico/Pico W

MicroPython update play.

To update the board, it needs to be in update mode.

```bash { background=false category=micropython-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=micropython-fw-install promptEnv=true terminalRows=25 }
# install/update the micropython firmware on the pico/pico w

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /micropython directory

stty cols 80
stty rows 25

declare TD

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

printf "Device contents (before):\n"
tree "${TD}"
printf "\n"

declare uf2_pico_url="https://micropython.org/download/rp2-pico/rp2-pico-latest.uf2"
declare uf2_picow_url="https://micropython.org/download/rp2-pico-w/rp2-pico-w-latest.uf2"

# at this stage, no reliable way to tell them apart at this stage
# - bootloader info in INFO_UF2.TXT tells you more about the age of the board than the type
# - same USB id -> Bus 001 Device 003: ID 2e8a:0003 Raspberry Pi RP2 Boot

declare hw_type

printf "Please select which hardware version you have connected:\n"
hw_type="$(gum choose "Pico" "Pico W")"
printf "\n"

declare uf2_url

if [[ ${hw_type} == "Pico" ]]; then
    uf2_url="${uf2_pico_url}"
elif [[ ${hw_type} == "Pico W" ]]; then
    uf2_url="${uf2_picow_url}"
else
    printf "Hardware type not selected, aborting.\n"
    exit 0
fi

printf "Running: %s\n" "wget -c ${uf2_url}"
[[ -d fw ]] || mkdir fw
cd fw
time wget -c "${uf2_url}"
cd ..
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ./fw/${uf2_url##*/} ${TD}/"
cp -v "./fw/${uf2_url##*/}" "${TD}/"
printf "done.\n"
printf "\n"
```
