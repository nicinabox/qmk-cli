# qmk-cli

A CLI to make common QMK tasks easier.

## Usage

    Usage:
      qmk COMMAND KEYBOARD [options]

    Commands:
      setup             Setup QMK firmware to flash keyboards
      update            Update QMK firmware to latest
      build KEYBOARD    Compile a keyboard
      flash KEYBOARD    Flash a keyboard
      clean [KEYBOARD]  Cleans up output folders so things compile from scratch

    Options:
      -k, --keymap KEYMAP              Your keymap name (default: nic)
      -h, --help                       Show this help message
