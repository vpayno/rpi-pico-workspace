# Raspberry Pi Pico/Pico W TinyGo experiments

Journaling [Raspberry Pi Pico/Pico W TinyGo](https://tinygo.org/docs/reference/microcontrollers/pico/) experiments here.

## Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Connecting to the Internet](https://datasheets.raspberrypi.com/picow/connecting-to-the-internet-with-pico-w.pdf)
- [Pico W BTStack](https://github.com/bluekitchen/btstack#welcome-to-btstack)
- [RP2040 Datasheet](https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf)
- [TinyGo Pico](https://tinygo.org/docs/reference/microcontrollers/pico/)
- [TinyGo Tutorial](https://tinygo.org/docs/tutorials/)
- [TinyGo Documentation](https://tinygo.org/docs/)
- [TinyGo Drivers](https://github.com/tinygo-org/drivers)
- [TinyGo PicoW Examples](https://github.com/soypat/cyw43439/)
- [TinyGo Machine Docs](https://tinygo.org/docs/reference/microcontrollers/machine/pico/)

## Installing Tools

Install TinyGo depdendencies:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-dependencies promptEnv=true terminalRows=10 }
# install Atmel AVR microcontroller packages
sudo nala install -y --no-autoremove avr-libc avra avrdude avrdude-doc avrp dfu-programmer
```

Install TinyGo:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-cli promptEnv=true terminalRows=10 }
# install tinygo deb package

set -e

wget -c "$(curl -sSL https://api.github.com/repos/tinygo-org/tinygo/releases/latest | jq -r '.assets[].browser_download_url' | grep amd64[.]deb)"
printf "\n"

sudo dpkg -i "$(curl -sSL https://api.github.com/repos/tinygo-org/tinygo/releases/latest | jq -r '.assets[].name' | grep 'amd64[.]deb')"
printf "\n"

tinygo version
printf "\n"
```

Setup new TinyGo module:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-module-new promptEnv=true terminalRows=10 }
set -e

export PN="projectname"

mkdir "${PN}"
cd "${PN}"
go mod init "${PN}"
go get tinygo.org/x/drivers
```

## TinyGo CLI commands

Compile and export the the elf and uf2 files to the project directory.

Using target `pico` for the Raspberry Pi Pico/Pico W.

```bash { background=false category=build-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-cli-compile promptEnv=true terminalRows=25 }
# choose an tinygo project and build it

set -e

# all paths are relative to the /tinygo directory

stty cols 80
stty rows 25

declare PF
declare WD
declare FN

gum format "# Please choose a TinyGo project to build:"
printf "\n"
PF="$(gum choose $(find ./* -maxdepth 1 -type f -name '*[.]go';))"
printf "\n"

# working directory
WD="$(dirname "${PF}")"
cd "${WD}" || exit

# project file
FN="$(basename "${PF}")"

echo Running: rm -fv "${FN//.go/.elf}" "${FN//.go/.uf2}"
time rm -fv "${FN//.go/.elf}" "${FN//.go/.uf2}"
printf "\n"

echo Running: tinygo build -target=pico "${FN}"
time tinygo build -target=pico "${FN}"
printf "\n"

echo Running: elf2uf2-rs "${FN//.go/.elf}" "${FN//.go/.uf2}"
time elf2uf2-rs "${FN//.go/.elf}" "${FN//.go/.uf2}"
printf "\n"

file ./*elf ./*uf2
printf "\n"

ls -lhv ./*elf ./*uf2
printf "\n"
```

Before you can update the board, you need to reboot the Raspberry Pi Pico/Pico W into update mode by

- holding the `Boot` button
- pressing the `Reset` button
- let go of the `Boot` button
- wait for the `RPI-RP2` drive to show up

```bash { background=false category=deploy-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-cli-upload promptEnv=true terminalRows=25 }
# choose a tinygo project and deploy it

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all paths are relative to the /tinygo directory

stty cols 80
stty rows 25

declare PF
declare TD

gum format "# Please choose a TinyGo project to deploy:"
printf "\n"
PF="$(gum choose $(find . -type f -name '*.uf2'))"
printf "\n"

if [[ -z ${PF} ]]; then
    printf "ERROR: no UF2 file selected\n"
    exit 1
fi

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

echo Running: cp -v "${PF}" "${TD}"
cp -v "${PF}" "${TD}"
echo done.
```

## Experiments

Current LSP setup, linting, etc, not working very well with TinyGo.
I got most of my debugging help from `tinygo build`.
Still, Arduino and TinyGo seems like the best options for me so far.

### [Hello Pico](hellopico/)

Using the official [TinyGo Tutorial](https://tinygo.org/docs/tutorials/) for this experiment.

### [Hello Pico W](hellopicow/)

Using the [cyw43439 blinky example](https://github.com/soypat/cyw43439/blob/main/examples/blinky/blinky.go) for this experiment.
