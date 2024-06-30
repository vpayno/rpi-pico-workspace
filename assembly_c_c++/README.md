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

## Pico SDK CLI commands

Compile and export the the bin, elf and uf2 files to `./build/rp2040.rp2040.adafruit_kb2040/`.

```bash { background=false category=build-picosdk closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=picosdk-cli-compile promptEnv=true terminalRows=25 }
# choose a pico sdk project and build it

set -e

# all paths are relative to the /assembly_c_c++ directory

stty cols 80
stty rows 25

# -DPICO_SDK_PATH="../pico-sdk"
# path from build directory
declare -x PICO_SDK_PATH="../pico-sdk"

declare WD

gum format "# Please choose a Pico SDK project to build:"
printf "\n"
WD="$(gum choose $(dirname $(find ./ -maxdepth 2 -type l -name pico-sdk | grep -v -E '^[.][/]$')))"

cd "${WD}" || exit 1
pwd
ls
printf "\n"

rm -rf build
mkdir -pv build
cd build
cmake ..
make
printf "\n"

ls -lh ./*.elf ./*.uf2
printf "\n"
```

Upload the desired UF2 file to the Pico board.

Note: Before you can update the board, you need to put the Pico in update mode.

```bash { background=false category=deploy-picosdk closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=picosdk-cli-upload promptEnv=true terminalRows=25 }
# choose a pico sdk project and deploy it

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all commands are relative to the /assembly_c_c++ directory

stty cols 80
stty rows 25

declare SF
declare TD

gum format "# Please choose a UF2 Pico SDK firmware file to deploy:"
printf "\n"
SF="$(gum choose $(find ./ -maxdepth 3 -type f -name '*.uf2' | grep -v -E '^[.][/]$'))"

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"

echo "Running: cp -v ${SF} ${TD}"
cp -v "${SF}" "${TD}"
echo done.
```

## Demos

### Blink

Blink LED demo for the Pico and Pico W.

To update the board, it needs to be in update mode.

```bash { background=false category=picosdk-demos closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=demo-picosdk-blink promptEnv=true terminalRows=25 }
# install the firmware for the pico or pico w that blinks the led

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /assembly_c_c++ directory

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

declare uf2_pico_url="https://datasheets.raspberrypi.com/soft/blink.uf2"
declare uf2_picow_url="https://datasheets.raspberrypi.com/soft/blink_picow.uf2"

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

### Hello World

Writes "Hello World" to the serial console on the Pico/PicoW boards.

To update the board, it needs to be in update mode.

```bash { background=false category=picosdk-demos closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=demo-picosdk-helloworld promptEnv=true terminalRows=25 }
# install the firmware for the pico or pico w that blinks the led

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /assembly_c_c++ directory

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

declare uf2_url="https://datasheets.raspberrypi.com/soft/hello_world.uf2"

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

printf "Waiting for %s:\n" "/dev/ttyACM0"
while [[ ! -e /dev/ttyACM0 ]]; do
    printf "."
    sleep 1s
done
printf "\n"
printf "\n"

printf "serial: "
cat /dev/ttyACM0 | head -n 2
printf "\n"
```

## Experiments

### [Hello Blink Pico in C](hello_blink-pico-c)

This experiment blinks the LED on the Raspberry Pi Pico board using the C Pico SDK.

### [Hello Blink for Pico W in C](hello_blink-picow-c)

This experiment blinks the LED on the Raspberry Pi Pico W board using the C Pico SDK.
