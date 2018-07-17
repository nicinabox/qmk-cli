require 'fileutils'
require 'open3'
require 'yaml'
require 'programmer'
require 'git'

LIB_PATH = "/usr/local/lib/qmk_firmware"

module QMK
  class Firmware
    def initialize(keyboard, keymap, config)
      @config = config

      @keyboard = keyboard
      @qmk_keyboard = get_keyboard keyboard
      @keymap = get_keymap(keyboard) || keymap

      @repo = Git.new(LIB_PATH)
    end

    def make(target = nil)
      if @config[:standalone_keymaps]
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
      if @config[:standalone_keymaps]
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

    def qmk_keyboards(keymap = nil)
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

    def programmer
      Programmer.new(keyboard_path).flasher
    end

    private
    def get_keyboard(local_keyboard)
      @config[:keyboards][local_keyboard] || local_keyboard
    end

    def get_keymap(keyboard)
      @config[:keymaps][keyboard]
    end

    def in_repo(&block)
      @repo.in_repo &block
    end

    def run(cmd)
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        while line = stdout.gets
          puts line
        end

        while line = stderr.gets
          puts line
        end
      end
    end

    def prepare_firmware
      local_keyboard_path = File.expand_path "./#{@keyboard}"
      files = Dir.glob "#{local_keyboard_path}/*"

      FileUtils.mkdir_p keymap_path
      FileUtils.cp_r files, keymap_path
    end

    def make_target(target = nil)
      return target unless @keyboard

      [@qmk_keyboard, @keymap, target].compact.join(':')
    end

    def keyboards_path
      "#{@repo.path}/keyboards"
    end

    def keyboard_path
      "#{keyboards_path}/#{@qmk_keyboard}"
    end

    def keymap_path
      if /handwired/ =~ @qmk_keyboard
        return handwired_keymap_path
      end

      standard_keymap_path
    end

    def standard_keymap_path
      "#{keyboard_path}/keymaps/#{@keymap}"
    end

    def handwired_keymap_path
      keyboard_path
    end
  end
end
