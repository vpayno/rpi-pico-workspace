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
- [Run Go applications on Pico using TinyGo](https://www.slideshare.net/slideshow/run-go-applications-on-pico-using-tinygo/250647741)

## Editor

Getting `gopls` working requires the use of [tinygo-edit](https://github.com/sago35/tinygo-edit).

Didn't work with `helix` but it did work with `vim`. It only accepts the command name without file arguments.

```text
tinygo-edit --editor vim --target pico
```

## Installing Tools

Install TinyGo depdendencies:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-dependencies promptEnv=true terminalRows=10 }
# install Atmel AVR microcontroller packages
sudo nala install -y --no-autoremove avr-libc avra avrdude avrdude-doc avrp dfu-programmer

go install github.com/sago35/tinygo-edit@latest
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

# https://dev.to/sago35/tinygo-vim-gopls-48h1
cd /usr/local/lib/tinygo/src || exit 1
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    [[ -d ${d} ]] && sudo touch "${d}"/go.mod
done

sudo tee go.mod <<-EOF
module tinygo.org/x/drivers

go 1.22

replace (
EOF
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    printf "\t%s => %s\n" "${d}" "/usr/local/lib/tinygo/src/${d}" | sudo tee -a go.mod
done
sudo tee -a go.mod <<-EOF
)
EOF

find /usr/local/lib/tinygo/src -type f -name go.mod
cd - || exit

cd lib/tinygo/src/ || exit 1
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    [[ -d ${d} ]] && touch "${d}"/go.mod
done

tee go.mod <<-EOF
module tinygo.org/x/drivers

go 1.22

replace (
EOF
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    printf "\t%s => %s\n" "${d}" "/usr/local/lib/tinygo/src/${d}" | sudo tee -a go.mod
done
tee -a go.mod <<-EOF
)
EOF

find /usr/local/lib/tinygo/src -type f -name go.mod
cd - || exit

# from tinygo/targets/{pico,picow}.json
jq . > pico.json <<EOF
{
    "inherits": [
        "rp2040"
    ],
    "build-tags": [
        "pico"
    ],
    "serial": "usb",
    "serial-port": [
        "2e8a:000A"
    ],
    "default-stack-size": 8192,
    "ldflags": [
        "--defsym=__flash_size=2048K"
    ],
    "extra-files": [
        "targets/pico-boot-stage2.S"
    ]
}
EOF

jq . > pico-w.json <<EOF
{
    "inherits": [
        "pico"
    ],
    "build-tags": [
        "pico-w",
        "cyw43439"
    ]
}
EOF
```

Setup new TinyGo module:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-module-new promptEnv=true terminalRows=10 }
set -e

export PN="projectname"

mkdir "${PN}"
cd "${PN}"
go mod init "${PN}"
go get tinygo.org/x/drivers
ln -sv ../pico.json ./pico.json
ln -sv ../pico-w.json ./pico-w.json

tee -a go.mod <<-EOF

replace (
    cyw43439 => ../lib/cyw43439
    drivers => ../lib/drivers
	device/arm => ../lib/tinygo/src/device/arm
	device/arm64 => ../lib/tinygo/src/device/arm64
	device/asm.go => ../lib/tinygo/src/device/asm.go
	device/avr => ../lib/tinygo/src/device/avr
	device/gba => ../lib/tinygo/src/device/gba
	device/nxp => ../lib/tinygo/src/device/nxp
	device/riscv => ../lib/tinygo/src/device/riscv
	device/sam => ../lib/tinygo/src/device/sam
	internal/bytealg => ../lib/tinygo/src/internal/bytealg
	internal/fuzz => ../lib/tinygo/src/internal/fuzz
	internal/reflectlite => ../lib/tinygo/src/internal/reflectlite
	internal/task => ../lib/tinygo/src/internal/task
	machine/ => ../lib/tinygo/src/machine/
	os/ => ../lib/tinygo/src/os/
	reflect/ => ../lib/tinygo/src/reflect/
	runtime/ => ../lib/tinygo/src/runtime/
	runtime/interrupt/ => ../lib/tinygo/src/runtime/interrupt/
	runtime/volatile/ => ../lib/tinygo/src/runtime/volatile/
	runtime/metrics/ => ../lib/tinygo/src/runtime/metrics/
	runtime/trace/ => ../lib/tinygo/src/runtime/trace/
	sync/ => ../lib/tinygo/src/sync/
	testing/ => ../lib/tinygo/src/testing/
)
EOF
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
