require 'fileutils'
require 'open3'
require 'programmer'

INSTALL_ROOT = "/usr/local/etc"
FIRMWARE_ROOT = "#{INSTALL_ROOT}/qmk_firmware"

module QMK
  class Firmware
    def initialize(keyboard, keymap)
      @keyboard = keyboard
      @keymap = keymap
    end

    def make(target = nil)
      if keymaps_only?
        prepare_firmware
      end

      Dir.chdir FIRMWARE_ROOT do
        run "make #{make_target(target)}"
      end
    end

    def clone
      `mkdir -p #{INSTALL_ROOT}`
      `git clone https://github.com/qmk/qmk_firmware.git #{FIRMWARE_ROOT}`
    end

    def update_submodules
      Dir.chdir FIRMWARE_ROOT do
        `make git-submodule`
      end
    end

    def update
      Dir.chdir FIRMWARE_ROOT do
        `git checkout . && git pull`
      end
    end

    def keyboard_name
      @keyboard.gsub(/\/rev.*/, '')
    end

    def programmer
      Programmer.new(qmk_keyboard_path).flasher
    end

    private
    def run(cmd)
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          puts line
        end
      end
    end

    def prepare_firmware
      keyboard_path = File.expand_path "./#{keyboard_name}"
      files = Dir.glob "#{keyboard_path}/*"

      FileUtils.mkdir_p keymap_path
      FileUtils.cp_r files, keymap_path
    end

    def make_target(target = nil)
      return target unless @keyboard
      [@keyboard, @keymap, target].compact.join(':')
    end

    def qmk_keyboard_path
      "#{FIRMWARE_ROOT}/keyboards/#{keyboard_name}"
    end

    def keymap_path
      if handwired?
        qmk_keyboard_path
      else
        "#{qmk_keyboard_path}/keymaps/#{@keymap}"
      end
    end

    def keymaps_only?
      File.exists? '.keymaps'
    end

    def handwired?
      @keyboard =~ /handwired/
    end
  end
end
