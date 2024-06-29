# rpi-pico-workspace

[![actionlint](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/gh-actions.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/gh-actions.yaml)
[![devcontainer](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/devcontainer.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/devcontainer.yaml)
[![git](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/git.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/git.yaml)
[![json](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/json.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/json.yaml)
[![markdown](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/markdown.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/markdown.yaml)
[![shell](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/shell.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/shell.yaml)
[![spellcheck](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/spellcheck.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/spellcheck.yaml)
[![woke](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/woke.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/woke.yaml)
[![yaml](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/yaml.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/yaml.yaml)

Personal Raspberry Pi Pico/Pico W workspace for learning Arduino, C/C++, CircutPython, MicroPython, TinyGo, and Rust.

## Raspberry Pi Pico / Pico W Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Arduino](https://arduino-pico.readthedocs.io/en/latest/)
- [C/C++](https://www.raspberrypi.com/documentation/microcontrollers/c_sdk.html)
- [CircuitPython for Pico W](https://circuitpython.org/board/raspberry_pi_pico_w/)
- [CircuitPython for Pico](https://circuitpython.org/board/raspberry_pi_pico/)
- [MicroPython](https://projects.raspberrypi.org/en/projects/getting-started-with-the-pico)
- [Rust](https://crates.io/crates/rp-pico)
- [TinyGo](https://tinygo.org/docs/reference/microcontrollers/pico/)

## RunMe Playbook

This and other readme files in this repo are RunMe Playbooks.

Use this playbook step/task to update the [RunMe](https://runme.dev) CLI.

If you don't have RunMe installed, you'll need to copy/paste the command. :)

```bash { background=false category=runme closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=runme-install-cli promptEnv=true terminalRows=10 }
go install github.com/stateful/runme/v3@v3
```

Install Playbook dependencies:

```bash { background=false category=runme closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=runme-install-deps promptEnv=true terminalRows=10 }
go install github.com/charmbracelet/gum@latest
go install github.com/charmbracelet/glow@latest
go install github.com/mikefarah/yq/v4@latest
```

## Updating the Pico

To put the Pico/Pico W in update mode,

- disconnect the usb cable
- hold the `BOOTSEL` Button
- connect the usb cable
- let go of the `BOOTSEL` Button

## Setup spare Pico as a debugger

[Debug with a second Pico (page 69)](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf)

To update the board, it needs to be in update mode.

```bash { background=false category=setup-debugger-fw closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=pico-install-debugprobe promptEnv=true terminalRows=25 }
# install Raspberry Pi Pico DebugProbe firmware

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the / directory

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

declare uf2_url="$(curl -sS https://api.github.com/repos/raspberrypi/debugprobe/releases/latest | jq -r '.assets[].browser_download_url | match(".*/debugprobe_on_pico.uf2").string')"

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

printf "After the Pico reboots, share it with linux.\n"
printf "Waiting for [%s] to show up...\n" "Raspberry Pi Debugprobe on Pico (CMSIS-DAP)"
while ! lsusb | grep -q 'Raspberry Pi Debugprobe on Pico (CMSIS-DAP)'; do sleep 1s; done
printf "\n"

lsusb
printf "\n"

dmesg -T | grep -e usb -e cdc_acm | tail -n 5
printf "\n"
```

## Factory reset the Pico/Pico W

Use this to reset the storage on the Pico/Pico W.

To update the board, it needs to be in update mode.

```bash { background=false category=setup-reset-fw closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=pico-install-reset-storage promptEnv=true terminalRows=25 }
# reset the storage on the Raspberry Pi Pico

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the / directory

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

declare uf2_url="https://datasheets.raspberrypi.com/soft/flash_nuke.uf2"

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
