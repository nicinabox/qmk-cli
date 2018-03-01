require 'optparse'
require 'firmware'

USAGE = <<-USAGE
  Usage:
    qmk COMMAND [options]

  Commands:
    flash KEYBOARD    Flash a keyboard
    build KEYBOARD    Compile a keyboard
    clean [KEYBOARD]  Cleans up output folders so things compile from scratch
    keyboards         List available keyboards (scope with --keymap)
    setup             Clone QMK firmware and checkout latest tag
    update            Update QMK firmware to latest tag

  Options:
USAGE

module QMK
  class CLI
    def initialize(args)
      @options = parser(args)
      command, keyboard = args
      @firmware = Firmware.new(keyboard, @options[:keymap], keymaps_only?)

      self.send(parse_command(command || 'help'))
    end

    def setup
      @firmware.setup
    end

    def update
      @firmware.update
      @firmware.update_submodules
    end

    def build
      @firmware.make
    end

    def flash
      @firmware.make @firmware.programmer
    end

    def clean
      @firmware.make 'clean'
    end

    def keyboards
      puts @firmware.keyboards
    end

    def help
      puts @options[:help]
    end

    private
    def parser(args)
      options = {}

      OptionParser.new do |parser|
        parser.banner = USAGE

        options[:keymap] = keymaps_only? ? `whoami`.strip : nil
        parser.on("-k", "--keymap KEYMAP", "Your keymap name (default: #{options[:keymap]})") do |v|
          options[:keymap] = v
        end

        options[:help] = parser
        parser.on("-h", "--help", "Show this help message")
      end.parse!

      options
    end

    def parse_command(cmd)
      cmd.gsub(/\-/, '_').downcase
    end

    def keymaps_only?
      File.exists? '.qmk'
    end

    def method_missing(*args)
      help
    end
  end
end
