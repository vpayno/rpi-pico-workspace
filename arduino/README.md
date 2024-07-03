# Raspberry Pi Pico/Pico W Arduino Experiments

Journaling [Raspberry Pi Pico/Pico W Arduino](https://arduino-pico.readthedocs.io/en/latest/) experiments here.

## Links

- [Raspberry Pi Pico and Pico W Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Raspberry Pi Pico and Pico W Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Arduino Pico and Pico W Documentation](https://arduino-pico.readthedocs.io/en/latest/)
- [Adafruit Examples](https://github.com/arduino/arduino-examples)
- [Adafruit RP2040 Tutorial](https://learn.adafruit.com/rp2040-arduino-with-the-earlephilhower-core)
- [Arduino Pico Documentation PDF](https://arduino-pico.readthedocs.io/_/downloads/en/latest/pdf/)

## Installing Tools

Install [Arduino](https://docs.arduino.cc/software/ide/) tooling dependencies.

```bash { background=false category=arduino-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-dependencies promptEnv=true terminalRows=10 }
# install arduino tooling dependencies

set -e

printf "\n"

sudo nala install -y --no-autoremove minicom picocom setserial libfuse2

sudo tee /etc/udev/rules.d/99-arduino-picodebug.rules <<EOF
ATTRS{product}=="*CMSIS-DAP*", MODE="664", GROUP="plugdev"
EOF

sudo tee /etc/udev/rules.d/99-arduino-picoprobe.rules <<EOF
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0004", GROUP="users", MODE="0666"
EOF

sudo tee /etc/udev/rules.d/99-arduino-rpipico.rules <<EOF
SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE="660", GROUP="plugdev"
SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000a", MODE="660", GROUP="plugdev"
EOF

sudo udevadm control --reload-rules
printf "\n"

sudo lsusb
printf "\n"
```

Install the Arduino CLI:

```bash { background=false category=arduino-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-cli promptEnv=true terminalRows=10 }
# install arduino cli

printf "Adding fqbn config.\n"
printf "%s\n" "rp2040:rp2040" | tee .arduino-fqbn.conf
printf "\n"

printf "Adding local copy of the arduino cli config.\n"
arduino-cli config dump | tee .arduino-cli.yaml
yamlfix --config-file ~/.vim/configs/yamlfix-custom.toml .arduino-cli.yaml
printf "\n"

if ! go install github.com/arduino/arduino-cli@latest; then
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="${HOME}/bin" sh
    arduino-cli version
fi
```

Install the Arduino IDE:

```bash { background=false category=arduino-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-ide promptEnv=true terminalRows=10 }
# install arduino ide
set -e

mkdir -pv "${HOME}/.local/"
cd "${HOME}/.local/" || exit

printf -v zip_url "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.assets[].browser_download_url' | grep '_Linux_64bit.zip$')"
printf -v zip_ver "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.name')"
printf -v zip_name "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.assets[].name' | grep Linux_64bit.zip)"

wget "${zip_url}"
unzip "./${zip_name}"
rm -fv "./${zip_name}"
rm -fv arduino-ide
ln -sv "./arduino-ide_${zip_ver}_Linux_64bit" arduino-ide

mkdir -pv "${HOME}/bin"
cat > "${HOME}/bin/arduino-ide" <<-EOF
#!/usr/bin/env bash

cd "${HOME}/.local/arduino-ide" || exit

exec ./arduino-ide "${@}"
EOF
chmod -v a+x "${HOME}/bin/arduino-ide"
```

Install the Arduino SAMD boards package (also manually add it to your global IDE and CLI configs).

It seems like it should be supported but I can't find the FQBN for it.
I guess I need to experiment to see which one was used for the precompiled UF2 files Raspberry Pi makes available.

```text
Port         Protocol Type              Board Name FQBN Core
/dev/ttyACM0 serial   Serial Port (USB) Unknown
```

```bash { background=false category=arduino-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-board promptEnv=true terminalRows=10 }
printf "board_manager:\n  additional_urls:\n    - %s\n" "https://adafruit.github.io/arduino-board-index/package_adafruit_index.json" | tee .arduino-cli.yaml
arduino-cli core update-index --config-file .arduino-cli.yaml
arduino-cli core install rp2040:rp2040 --config-file .arduino-cli.yaml
arduino-cli board listall | grep rp2040 | grep pico
arduino-cli board details --fqbn rp2040:rp2040:rpipico # not a device query
arduino-cli board details --fqbn rp2040:rp2040:rpipicow # not a device query
```

Install Arduino libraries:

```bash { background=false category=arduino-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-libraries promptEnv=true terminalRows=10 }
arduino-cli lib install "Adafruit TFTLCD Library"
arduino-cli lib install "Adafruit DMA neopixel library"
arduino-cli lib install "Adafruit NeoPixel"
arduino-cli lib install "AsyncHTTPRequest_RP2040W"
arduino-cli lib install "AsyncTCP_RP2040W"
arduino-cli lib install "AsyncUDP_RP2040W"
arduino-cli lib install "Pico PIO USB"
arduino-cli lib install "RP2040_PWM"
arduino-cli lib install "RP2040_SD"
arduino-cli lib install "WiFiManager_RP2040W"
arduino-cli lib install "WiFiManager_RP2040W_Lite"
printf "\n"

arduino-cli lib list
printf "\n"
```

## Arduino CLI commands

Compile and export the the bin, elf and uf2 files to `./build/arduino.samd.adafruit_pyportal/`.

```bash { background=false category=build-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-cli-compile promptEnv=true terminalRows=25 }
# choose an arduino project and build it

set -e

# all paths are relative to the /arduino directory

stty cols 80
stty rows 25

declare WD

gum format "# Please choose an Arduino project to build:"
printf "\n"
WD="$(gum choose $(find ./ -maxdepth 1 -type d | grep -v -E '^[.][/]$'))"

cd "${WD}" || exit 1
pwd
ls
printf "\n"

../tool-compile
```

Before you can update the board, you need to reboot the Raspberry Pi Pico/Pico W into update mode by

- disconnect the usb cable
- hold the `BOOTSEL` Button
- connect the usb cable
- let go of the `BOOTSEL` Button

```bash { background=false category=deploy-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-cli-upload promptEnv=true terminalRows=25 }
# choose an arduino project and deploy it

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all commands are relative to the /arduino directory

stty cols 80
stty rows 25

declare WD
declare TD

gum format "# Please choose an Arduino project to deploy:"
printf "\n"
WD="$(gum choose $(find ./ -maxdepth 1 -type d | grep -v -E '^[.][/]$'))"

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"

cd "${WD}" || exit 1
pwd
ls
printf "\n"

echo Running: cp -v ./build/rp2040.rp2040.rpipicow/*uf2 "${TD}"
cp -v ./build/rp2040.rp2040.rpipicow/*uf2 "${TD}"
echo done.
```

## Experiments

### [Hello Pico](hellopico/)

This experiment uses the example Raspberry Pi Pico/Pico W blink and serial sketch.
