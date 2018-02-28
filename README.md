# qmk-cli

A thin wrapper around QMK's `make` to make common tasks easier.

## Why use this?

- Flashing is more intuitive (Example: `qmk flash planck`)
- Automatic programmer detection (No more "Does this board use dfu-programmer/ avrdude/teensy/other?")
- Supports standalone keymaps

## Usage

    Usage:
      qmk COMMAND KEYBOARD [options]

    Commands:
      flash KEYBOARD    Flash a keyboard
      build KEYBOARD    Compile a keyboard
      clean [KEYBOARD]  Cleans up output folders so things compile from scratch
      setup             Setup QMK firmware to flash keyboards
      update            Update QMK firmware to latest

    Options:
      -k, --keymap KEYMAP              Your keymap name (default: `whoami`)
      -h, --help                       Show this help message

## Standalone keymaps

- Add a `.qmk` file in your keymaps directory to designate this a standalone keymaps directory.
- Keyboard directories should be at the root with the keymap files inside. Since these are *your* keymaps there's no need to add additional namespacing.

View [nicinabox/keymaps](https://github.com/nicinabox/keymaps) for a complete example on how standalone keymaps should be organized.

## Platforms

- [x] macOS
- [ ] linux
- [ ] windows

# Requirements

- Ruby >= 2
- Git
- [build tools](https://docs.qmk.fm/getting_started_build_tools.html)

## License

ISC
