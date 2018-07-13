require 'fileutils'
require 'open3'
require 'programmer'
require 'git'

LIB_PATH = "/usr/local/lib/qmk_firmware"

module QMK
  class Firmware
    def initialize(keyboard, keymap, keymaps_only)
      @keyboard = keyboard
      @keymap = keymap
      @repo = Git.new(LIB_PATH)
      @keymaps_only = keymaps_only
    end

    def make(target = nil)
      if @keymaps_only
        prepare_firmware
      end

      in_repo do
        run "make #{make_target(target)}"
      end
    end

    def setup
      @repo.clone 'https://github.com/qmk/qmk_firmware.git'

      in_repo do
        @repo.checkout_latest_tag
      end
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

    def keyboards
      if @keymaps_only
        standalone_keyboards
      else
        qmk_keyboards @keymap
      end
    end

    def standalone_keyboards
      Dir["**/keymap.c"]
        .map {|path| File.dirname(path) }
        .sort
    end

    def qmk_keyboards(keymap=nil)
      Dir["#{keyboards_path}/**/#{keymap}/keymap.c"]
        .map {|path|
          File.dirname(path)
            .gsub(keyboards_path, '')
            .split('/')
            .reject(&:empty?)
            .first
        }
        .uniq
        .sort
    end

    def keyboard_name
      @keyboard.gsub(/\/rev.*/, '')
    end

    def programmer
      Programmer.new(@keyboard, keyboard_path).flasher
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

    def keyboards_path
      "#{@repo.path}/keyboards"
    end

    def keyboard_path
      "#{keyboards_path}/#{keyboard_name}"
    end

    def keymap_path
      if handwired?
        keyboard_path
      else
        "#{keyboard_path}/keymaps/#{@keymap}"
      end
    end

    def handwired?
      @keyboard =~ /handwired/
    end
  end
end
