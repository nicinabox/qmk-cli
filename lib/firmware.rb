require 'fileutils'
require 'open3'
require 'programmer'
require 'git'

module QMK
  class Firmware
    def initialize(keyboard, keymap)
      @keyboard = keyboard
      @keymap = keymap
      @repo = Git.new("/usr/local/etc/qmk_firmware")
    end

    def make(target = nil)
      if keymaps_only?
        prepare_firmware
      end

      in_repo do
        run "make #{make_target(target)}"
      end
    end

    def clone
      @repo.clone 'https://github.com/qmk/qmk_firmware.git'
    end

    def update_submodules
      in_repo do
        run "make git-submodule"
      end
    end

    def checkout_stable
      in_repo do
        @repo.fetch_origin
        @repo.checkout_latest_tag
      end
    end

    def update
      in_repo do
        @repo.clean
        checkout_stable
      end
    end

    def keyboard_name
      @keyboard.gsub(/\/rev.*/, '')
    end

    def programmer
      Programmer.new(qmk_keyboard_path).flasher
    end

    private
    def in_repo(&block)
      @repo.in_repo &block
    end

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
      "#{@repo.path}/keyboards/#{keyboard_name}"
    end

    def keymap_path
      if handwired?
        qmk_keyboard_path
      else
        "#{qmk_keyboard_path}/keymaps/#{@keymap}"
      end
    end

    def keymaps_only?
      File.exists? '.qmk'
    end

    def handwired?
      @keyboard =~ /handwired/
    end
  end
end
