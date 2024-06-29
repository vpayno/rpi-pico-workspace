# rpi-pico-workspace

[![actionlint](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/gh-actions.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/gh-actions.yaml)
[![git](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/git.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/git.yaml)
[![json](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/json.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/json.yaml)
[![markdown](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/markdown.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/markdown.yaml)
[![shell](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/shell.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/shell.yaml)
[![spellcheck](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/spellcheck.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/spellcheck.yaml)
[![woke](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/woke.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/woke.yaml)
[![yaml](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/yaml.yaml/badge.svg?branch=main)](https://github.com/vpayno/rpi-pico-workspace/actions/workflows/yaml.yaml)

Personal Raspberry Pi Pico/Pico W workspace for learning Arduino, MicroPython, TinyGo, and Rust.

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
