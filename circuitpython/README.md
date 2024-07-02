# Raspberry CircuitPython Experiments

Journaling [Raspberry CircuitPython](https://docs.circuitpython.org/en/latest/docs/index.html) experiments here.

## Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [CircuitPython Documentation](https://docs.circuitpython.org/_/downloads/en/latest/pdf/)

## Updating the Pico

To put the Pico/Pico W in update mode,

- disconnect the usb cable
- hold the `BOOTSEL` Button
- connect the usb cable
- let go of the `BOOTSEL` Button

### Install/Update CircuitPython on the Pico/Pico W

CircuitPython update play.

To update the board, it needs to be in update mode.

```bash { background=false category=circuitpython-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-fw-install promptEnv=true terminalRows=25 }
# install/update the circuitpython firmware on the pico/pico w

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /circuitpython directory

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

declare uf2_pico_url="https://downloads.circuitpython.org/bin/raspberry_pi_pico/en_US/adafruit-circuitpython-raspberry_pi_pico-en_US-9.0.5.uf2"
declare uf2_picow_url="https://downloads.circuitpython.org/bin/raspberry_pi_pico_w/en_US/adafruit-circuitpython-raspberry_pi_pico_w-en_US-9.0.5.uf2"

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

## CircuitPython CLI commands

### rshell

To install `rshell` run:

```bash { background=false category=circuitpython-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-rshell promptEnv=true terminalRows=25 }
pip install --upgrade rshell
```

`rshell` commands:

- args: Debug function for verifying argument parsing. This function just prints out each argument that it receives.
- boards: Lists all of the boards that rshell is currently connected to, their names, and the connection.
- cat: Concatenates files and sends to stdout.
- cd: Changes the current directory. ~ expansion is supported, and cd - goes to the previous directory.
- connect: Connects a pyboard to rshell. rshell can be connected to multiple pyboards simultaneously.
- cp: Copies the SOURCE file to DEST. DEST may be a filename or a directory name. If more than one source file is specified, then the destination should be a directory.
- date: Displays and set date on board.
- echo: Display a line of text.
- edit: If the file is on a pyboard, it copies the file to host, invokes an editor and if any changes were made to the file, it copies it back to the pyboard.
- exit: Exit the rshell.
- filesize: Prints the size of the file, in bytes. This function is primarily testing.
- filetype: Prints the type of file (dir or file). This function is primarily for testing.
- help: List available commands with no arguments, or detailed help when a command is provided.
- ls: Pattern matching is performed according to a subset of the Unix rules (see below).
- mkdir: Creates one or more directories.
- repl: Enters into the regular repl with the CircuitPython board.
- rm: Deletes a file.
- rsync: Syncs files between host and board.
- shell: Runs a special, limited shell.

List available boards:

```bash { background=false category=circuitpython-rshell closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-rshell-list promptEnv=true terminalRows=25 }
# list available boards

set -e

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare SD

gum format "# Please choose the pico device:"
printf "\n"
SD="$(gum choose $(find /dev -name 'ttyACM*' -not -path '/dev/.lxc/*' 2>/dev/null | sort -V))"
printf "\n"

rshell -p "${SD}" --buffer-size 512 boards
```

To start an interactive REPL:

```bash { background=false category=circuitpython-rshell closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-rshell-repl promptEnv=true terminalRows=25 }
# run repl on a pico

set -e

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare SD

gum format "# Please choose the pico device:"
printf "\n"
SD="$(gum choose $(find /dev -name 'ttyACM*' -not -path '/dev/.lxc/*' 2>/dev/null | sort -V))"
printf "\n"

rshell -p "${SD}" --buffer-size 512 repl pyboard
```

I'm still trying to figure out how to get Python code to run on CircuitPython without having to "send" an EOF to the REPL.

Push and run selected code on the Pico board:

```bash { background=false category=circuitpython-rshell closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-rshell-deploy promptEnv=true terminalRows=25 }
# deploy code to the pico

set -e

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare SD
declare TF

gum format "# Please choose the target CircuitPython/helloworld/main.pyython device:"
printf "\n"
SD="$(gum choose $(find /dev -name 'ttyACM*' -not -path '/dev/.lxc/*' 2>/dev/null | sort -V))"
printf "\n"

gum format "# Please choose the main.py you want to deploy:"
printf "\n"
TF="$(gum choose ./*/main.py)"
printf "\n"

rshell -p "${SD}" --buffer-size 512 cp "${TF}" /pyboard/main.py
printf "\n"

sleep 2s

# can't "send" and EOF to the REPL to restart it

printf "INFO: Press ctrl-d to restart repl\n"
printf "INFO: Press ctrl-x to detach from the rshell\n"
printf "\n"
rshell -p "${SD}" --buffer-size 512 repl pyboard
printf "\n"
```

Install Adafruit [CircuitPython libraries](https://circuitpython.org/libraries):

```bash { background=false category=circuitpython-setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-libraries promptEnv=true terminalRows=25 }
# install Adafruit CircuitPython libraries

set -e

if [[ ! -d /mnt/chromeos/removable/CIRCUITPY/ ]]; then
    printf "ERROR: You need to share the CIRCUITPY volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/CIRCUITPY/boot_out.txt ]]; then
    printf "ERROR: Board isn't in CircuitPython update mode\n"
    exit 1
fi

# all paths are relative to the /circuitpython directory

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

declare zip_url="https://github.com/adafruit/Adafruit_CircuitPython_Bundle/releases/download/20240702/adafruit-circuitpython-bundle-9.x-mpy-20240702.zip"

mkdir -v lib
cd lib || exit 1
printf "Running: %s\n" "wget -c ${zip_url}"
wget -c "${zip_url}"
unzip "${zip_url##*/}"
cd - || exit 1

printf "Running: %s\n" "cp -v ./lib/adafruit-circuitpython-bundle-9.x-mpy-*/lib ${TD}/"
cp -vr ./lib/adafruit-circuitpython-bundle-9.x-mpy-*/lib "${TD}/"
printf "done.\n"
printf "\n"

printf "Device contents (after):\n"
tree "${TD}"
printf "\n"
```

Deploy selected code.py file to USB drive:

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-code promptEnv=true terminalRows=25 }
# install code.py file

set -e

if [[ ! -d /mnt/chromeos/removable/CIRCUITPY/ ]]; then
    printf "ERROR: You need to share the CIRCUITPY volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/CIRCUITPY/boot_out.txt ]]; then
    printf "ERROR: Board isn't in CircuitPython update mode\n"
    exit 1
fi

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare PF

gum format "# Please choose a CircuitPython project to build:"
printf "\n"
PF="$(gum choose $(find ./* -maxdepth 1 -type f -name 'code.py';))"
printf "\n"

declare TD

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

printf "Device contents (before):\n"
tree "${TD}"
printf "\n"

printf "Running: %s\n" "cp -v ${PF//code.py/settings}.* ${TD}"
cp -v "${PF//code.py/settings}".* "${TD}"
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ${PF//code.py/secrets}.* ${TD}"
cp -v "${PF//code.py/secrets}".* "${TD}"
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ${PF} ${TD}"
cp -v "${PF}" "${TD}"
printf "done.\n"
printf "\n"

printf "Device contents (after):\n"
ls "${TD}"
printf "\n"

printf "Running: %s\n" "sync ${TD}"
sync "${TD}"
printf "\n"
```

## Experiments

### [Hello Pico](hellopico)

This experiment blinks the LED on the Raspberry Pi Pico/Pico W boards using CircuitPython.
