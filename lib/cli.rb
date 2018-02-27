require 'optparse'
require 'firmware'

USAGE = <<-USAGE
  Usage:
    qmk COMMAND KEYBOARD [options]

  Commands:
    setup             Setup QMK firmware to flash keyboards
    update            Update QMK firmware to latest
    build KEYBOARD    Compile a keyboard
    flash KEYBOARD    Flash a keyboard
    clean [KEYBOARD]  Cleans up output folders so things compile from scratch

  Options:
USAGE

module QMK
  class CLI
    def initialize(args)
      @options = parser(args)
      command, keyboard = args
      @firmware = Firmware.new(keyboard, @options[:keymap])

      self.send(parse_command(command || 'help'))
    end

    def setup
      @firmware.clone
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

    def help
      puts @options[:help]
    end

    private
    def parser(args)
      options = {}

      OptionParser.new do |parser|
        parser.banner = USAGE

        options[:keymap] = `whoami`.strip
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

    def method_missing(*args)
      help
    end
  end
end
