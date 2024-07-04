# Raspberry Pi Pico/Pico W Rust Experiments

Journaling [Raspberry Pi Pico/Pico W Rust](https://crates.io/crates/rp-pico) experiments here.

## Links

- [Raspberry Pi Pico W and Pico WH Documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Pinout Diagram](https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf)
- [Connecting to the Internet](https://datasheets.raspberrypi.com/picow/connecting-to-the-internet-with-pico-w.pdf)
- [Pico W BTStack](https://github.com/bluekitchen/btstack#welcome-to-btstack)
- [RP2040 Datasheet](https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf)
- [Rust Embedded Book](https://docs.rust-embedded.org/book/)
- [Rust Drivers](https://crates.io/crates/rp-pico)
- [Rust HAL](https://github.com/rp-rs/rp-hal-boards/)

## Installing Tools

The RP2040 uses a `ARM Cortex-M0+` processor.

Install Rust tooling dependencies.

```bash { background=false category=setup-rust closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=rust-install-dependencies promptEnv=true terminalRows=10 }
# install rust tooling dependencies

set -e

sudo nala install -y --no-autoremove minicom picocom setserial libfuse2 libusb-1.0-0-dev libudev-dev cmake
printf "\n"

sudo nala install -y --no-autoremove gdb-multiarch gdb-arm-none-eabi openocd qemu-system-arm
printf "\n"

cargo install --locked cargo-binutils
cargo install --locked cargo-generate
cargo install --locked elf2uf2-rs
cargo install --locked probe-rs-tools
cargo install --locked cargo-hf2
cargo install --locked hf2-cli
cargo install --locked uf2conv

printf "\n"

rustup component add llvm-tools
printf "\n"

rustup target add thumbv6m-none-eabi  # M0, M0+, M1 (ARMv6-M)
printf "\n"

sudo udevadm control --reload-rules
printf "\n"

sudo udevadm trigger
printf "\n"

sudo lsusb
printf "\n"

sudo lsscsi
printf "\n"
```

## Rust CLI commands

Compile and export the the elf and uf2 files to `./target/thumbv6m-none-eabi/release/`.

```bash { background=false category=build-rust closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=rust-cli-compile promptEnv=true terminalRows=25 }
# choose an rust project and build it

set -e

# all paths are relative to the /rust directory

stty cols 80
stty rows 25

declare WP
declare WE
declare PN

gum format "# Please choose a Rust project to build:"
printf "\n"
WP="$(gum choose $(find ./*/examples/ -maxdepth 1 -type f -name '*[.]rs';))"
printf "\n"

# project name
PN="${WP#*/}"
# example name (optional)
WE="${WP##*/}"; WE="${WE%.rs}"

echo Running: cargo clean
time cargo clean
printf "\n"

echo Running: cargo build --release --example "${WE}"
time cargo build --release --example "${WE}"
printf "\n"

declare ELF_FILE
ELF_FILE=$(file ../target/thumbv6m-none-eabi/release/*/* | grep ELF | cut -f1 -d: | grep -E "/${WE}$")
echo Running: elf2uf2-rs "${ELF_FILE}{,.uf2}"
time elf2uf2-rs "${ELF_FILE}"{,.uf2}
printf "\n"

file "${ELF_FILE}"{,.uf2}
printf "\n"

ls -lhv "${ELF_FILE}"{,.uf2}
printf "\n"
```

Before you can update the board, you need to reboot the Raspberry Pi Pico/Pico W into update mode by

- holding the `Boot` button
- pressing the `Reset` button
- let go of the `Boot` button
- wait for the `RPI-RP2` drive to show up

```bash { background=false category=deploy-rust closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=rust-cli-upload promptEnv=true terminalRows=25 }
# choose a rust project and deploy it

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all paths are relative to the /rust directory

stty cols 80
stty rows 25

declare PF
declare TD

gum format "# Please choose a Rust project to deploy:"
printf "\n"
PF="$(gum choose $(ls ../target/thumbv6m-none-eabi/release/*/* | grep -E ".uf2$"))"
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

Browse projects:

```bash { background=false category=browse-rust closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=rust-cli-browse promptEnv=true terminalRows=25 }
# choose a rust project and browse it

set -e

stty cols 80
stty rows 25

# all paths are relative to the /rust directory

declare SD
printf "Choose a project directory to browse:\n"
SD="$(gum choose $(find ./*/examples/ -maxdepth 1 -type d))"
printf "\n"

printf "Projects under %s:\n" "${SD}"
ls -lhv "${SD}"
printf "\n"

printf "Release binaries under %s:\n" ../target/thumbv6m-none-eabi/release/examples/
ls ../target/thumbv6m-none-eabi/release/examples/
printf "\n"
file ../target/thumbv6m-none-eabi/release/examples/*
printf "\n"
```

## Rust Workspace

When adding dependencies, if they are or may be shared between experiments, add
them from the top level directory with the Cargo workspace `Cargo.toml` file
first before adding it to the project `Cargo.toml`.

All the projects also share the top level `/memory.x` file and
`.cargo/config.toml` files.
