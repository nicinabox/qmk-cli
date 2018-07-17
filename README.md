# qmk-cli

A wrapper around QMK's `make` to make common tasks easier. **This is a proof of concept and should be considered unstable.**

## Why use this?

- Flashing is more intuitive (Example: `qmk flash planck`)
- Automatic programmer detection (No more "Does this board use dfu-programmer/avrdude/teensy/other?")
- Supports standalone keymaps

## Usage

    Usage:
      qmk COMMAND [options]

    Commands:
      flash KEYBOARD    Flash a keyboard
      build KEYBOARD    Compile a keyboard
      clean [KEYBOARD]  Cleans up output folders so things compile from scratch
      setup             Clone QMK firmware and checkout latest tag
      update            Update QMK firmware to latest tag

    Options:
      -k, --keymap KEYMAP              Your keymap name (default: `whoami`)
      -h, --help                       Show this help message

## Standalone keymaps

- Add a `.qmk` file in your keymaps directory to designate this a standalone keymaps directory.
- Keyboard directories should be at the root with the keymap files inside. Since these are *your* keymaps there's no need to add additional namespacing.

View [nicinabox/keymaps](https://github.com/nicinabox/keymaps) for a complete example on how standalone keymaps should be organized.

### .qmk

This file tells qmk-cli that the directory contains keymaps only, with the directory named after the keyboard it supports. This works well for common cases, but there are a number of cases in which you may want to organize differently and supply a configuration.

Here is an example configuration. All fields are optional.

```yaml
# Specify your keymap name. Uses `whoami` by default.
keymap: nic

# Map local keyboard directories to qmk keyboard directories if needed.
keyboards:
  bananasplit_blocked: bananasplit
  clueboard: clueboard/66
  nh60: handwired/nh60

keymaps:
  # Override keymap names that differ from your keymap setting above.
  nh60: default
```

## Platforms

- [x] macOS
- [x] linux, probably
- [ ] windows

## Requirements

- Ruby >= 2
- Git
- [build tools](https://docs.qmk.fm/getting_started_build_tools.html)

## License

ISC
