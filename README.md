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
